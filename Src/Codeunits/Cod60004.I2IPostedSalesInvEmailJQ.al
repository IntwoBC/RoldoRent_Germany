codeunit 60004 "I2I Posted Sales Inv. Email JQ"
{
    Permissions = tabledata "Sales Invoice Header" = R;

    trigger OnRun()
    begin
        ProcessInvoices();
    end;

    // Processes posted sales invoices in batch for Job Queue execution.
    // Applies skip/sent/error rules per invoice and keeps processing even when one fails.
    // Used as the main orchestration entry for scheduled invoice email delivery.
    local procedure ProcessInvoices()
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SentCount: Integer;
        SkippedCount: Integer;
        ErrorCount: Integer;
        ResultStatusTxt: Text;
    begin
        SalesInvoiceHeader.SetLoadFields("No.", "Bill-to Customer No.", "Sell-to Customer No.");

        if SalesInvoiceHeader.FindSet() then
            repeat
                ProcessSingleInvoice(SalesInvoiceHeader);
                GetLastProcessResult(ResultStatusTxt);
                UpdateCountersFromResult(ResultStatusTxt, SentCount, SkippedCount, ErrorCount);
            until SalesInvoiceHeader.Next() = 0;

        Session.LogMessage(
            'I2I-INVEMAIL-003',
            StrSubstNo(
                'Posted Sales Invoice email job completed. Sent: %1, Skipped: %2, Errors: %3.',
                SentCount,
                SkippedCount,
                ErrorCount),
            Verbosity::Normal,
            DataClassification::SystemMetadata,
            TelemetryScope::ExtensionPublisher,
            'PostedSalesInvoiceEmail',
            'Summary');
    end;

    /// <summary>
    /// Increments one aggregate counter based on the result status returned by the latest single-invoice processing attempt.
    /// </summary>
    /// <param name="ResultStatusTxt">Outcome status text expected to be one of Sent, Skipped, or Error.</param>
    /// <param name="SentCount">Running total of invoices successfully queued for email delivery.</param>
    /// <param name="SkippedCount">Running total of invoices intentionally skipped (for example missing email or already sent marker).</param>
    /// <param name="ErrorCount">Running total of invoices that failed processing with an error condition.</param>
    local procedure UpdateCountersFromResult(ResultStatusTxt: Text; var SentCount: Integer; var SkippedCount: Integer; var ErrorCount: Integer)
    begin
        case ResultStatusTxt of
            StatusSentLbl:
                SentCount += 1;
            StatusSkippedLbl:
                SkippedCount += 1;
            StatusErrorLbl:
                ErrorCount += 1;
            else begin
                ErrorCount += 1;
                Session.LogMessage(
                    'I2I-INVEMAIL-006',
                    StrSubstNo(UnexpectedStatusMsgLbl, ResultStatusTxt),
                    Verbosity::Warning,
                    DataClassification::SystemMetadata,
                    TelemetryScope::ExtensionPublisher,
                    'PostedSalesInvoiceEmail',
                    'UnexpectedStatus');
            end;
        end;
    end;

    // Processes exactly one posted sales invoice using production email flow.
    // Applies validation, duplicate protection, PDF generation, enqueue, and sent marker creation.
    // Used by Job Queue batch execution.
    procedure ProcessSingleInvoice(SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        CustomerEmail: Text[250];
        LastErrorDetailsTxt: Text;
    begin
        if IsInvoiceAlreadySent(SalesInvoiceHeader) then begin
            SetLastProcessResult(StatusSkippedLbl, AlreadySentReasonLbl);
            Session.LogMessage(
                'I2I-INVEMAIL-004',
                StrSubstNo('Invoice %1 skipped because it is already marked as sent.', SalesInvoiceHeader."No."),
                Verbosity::Normal,
                DataClassification::SystemMetadata,
                TelemetryScope::ExtensionPublisher,
                'PostedSalesInvoiceEmail',
                'AlreadySent');
            exit;
        end;

        CustomerEmail := GetCustomerInvoiceEmail(SalesInvoiceHeader);
        if CustomerEmail = '' then begin
            SetLastProcessResult(StatusSkippedLbl, MissingEmailReasonLbl);
            Session.LogMessage(
                'I2I-INVEMAIL-001',
                StrSubstNo('Invoice %1 skipped because customer invoice email is blank.', SalesInvoiceHeader."No."),
                Verbosity::Warning,
                DataClassification::SystemMetadata,
                TelemetryScope::ExtensionPublisher,
                'PostedSalesInvoiceEmail',
                'MissingEmail');
            exit;
        end;

        ClearLastError();

        if TryEnqueueInvoiceEmail(SalesInvoiceHeader, CustomerEmail) then begin
            MarkInvoiceAsQueued(SalesInvoiceHeader);

            SetLastProcessResult(StatusSentLbl, SuccessReasonLbl);
            Codeunit.Run(Codeunit::"Sales Inv.-Printed", SalesInvoiceHeader);

            Session.LogMessage(
                'I2I-INVEMAIL-005',
                StrSubstNo('Invoice %1 successfully queued for email delivery to %2.',
                    SalesInvoiceHeader."No.",
                    CustomerEmail),
                Verbosity::Normal,
                DataClassification::SystemMetadata,
                TelemetryScope::ExtensionPublisher,
                'PostedSalesInvoiceEmail',
                'Queued');
        end else begin
            LastErrorDetailsTxt := GetLastErrorText();
            if LastErrorDetailsTxt = '' then
                LastErrorDetailsTxt := NoErrorTextFallbackLbl;

            SetLastProcessResult(StatusErrorLbl, LastErrorDetailsTxt);
            Session.LogMessage(
                'I2I-INVEMAIL-002',
                StrSubstNo('Invoice %1 failed during email processing. Error: %2', SalesInvoiceHeader."No.", LastErrorDetailsTxt),
                Verbosity::Error,
                DataClassification::SystemMetadata,
                TelemetryScope::ExtensionPublisher,
                'PostedSalesInvoiceEmail',
                'ProcessingFailure');
        end;
    end;

    // Returns the result from the most recent ProcessSingleInvoice execution.
    // Used by ProcessInvoices to aggregate sent/skipped/error counters.
    procedure GetLastProcessResult(var StatusTxt: Text)
    begin
        StatusTxt := LastProcessStatusTxt;
    end;

    // Stores the current invoice processing outcome for immediate caller feedback.
    // Keeps status and reason centralized to avoid duplicating decision logic in callers.
    // Used only inside this codeunit after each single-invoice processing attempt.
    local procedure SetLastProcessResult(StatusTxt: Text; ReasonTxt: Text)
    begin
        LastProcessStatusTxt := StatusTxt;
        LastProcessReasonTxt := ReasonTxt;
    end;

    [TryFunction]
    local procedure TryEnqueueInvoiceEmail(SalesInvoiceHeader: Record "Sales Invoice Header"; CustomerEmail: Text[250])
    begin
        SendInvoiceEmail(SalesInvoiceHeader, CustomerEmail);
    end;
    // Builds and queues one posted sales invoice email with PDF attachment.
    // Validates generated PDF payload before adding it as an attachment.
    // Used inside TrySendInvoiceEmail for successful, email-eligible invoices.
    local procedure SendInvoiceEmail(SalesInvoiceHeader: Record "Sales Invoice Header"; CustomerEmail: Text[250])
    var
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        PdfTempBlob: Codeunit "Temp Blob";
        PdfInStream: InStream;
        PdfSizeBytes: Integer;
        AttachmentName: Text;
        SubjectText: Text;
        BodyText: Text;
        ToRecipients: List of [Text];
        SalesSetup: Record "Sales & Receivables Setup";
        EmailBodyFormatter: Codeunit "I2I Email Body Sig. Inserter";
    begin
        GenerateInvoicePdf(SalesInvoiceHeader, PdfTempBlob);
        SalesSetup.Get();

        if not PdfTempBlob.HasValue() then
            Error(GeneratedPdfEmptyErrLbl, SalesInvoiceHeader."No.");

        PdfSizeBytes := PdfTempBlob.Length();
        if PdfSizeBytes <= 0 then
            Error(GeneratedPdfInvalidSizeErrLbl, SalesInvoiceHeader."No.");

        PdfTempBlob.CreateInStream(PdfInStream);

        SubjectText := StrSubstNo(InvoiceEmailSubjectLbl, SalesInvoiceHeader."No.");
        BodyText := EmailBodyFormatter.BuildEmailBodyWithSignature(SalesSetup."I2I Email Body", SalesSetup."I2I Rental Email Sig. Tmpl");

        ToRecipients.Add(CustomerEmail);
        EmailMessage.Create(ToRecipients, SubjectText, BodyText, true);

        AttachmentName := StrSubstNo(InvoiceAttachmentNameLbl, SalesInvoiceHeader."No.");
        EmailMessage.AddAttachment(AttachmentName, 'application/pdf', PdfInStream);

        Email.Enqueue(EmailMessage, Enum::"Email Scenario"::"Sales Invoice");
    end;

    // Generates PDF content for one posted sales invoice using Report Selections configuration.
    // Ensures the report runs with a single-record filtered dataset.
    // Used by SendInvoiceEmail to prepare attachment content in Temp Blob.
    local procedure GenerateInvoicePdf(SalesInvoiceHeader: Record "Sales Invoice Header"; var PdfTempBlob: Codeunit "Temp Blob")
    var
        PdfOutStream: OutStream;
        SalesInvoiceHeaderForReport: Record "Sales Invoice Header";
        SalesInvoiceHeaderRef: RecordRef;
        ReportId: Integer;
        HeaderFiltersTxt: Text;
    begin
        if SalesInvoiceHeader."No." = '' then
            Error(InvoiceNoBlankErrLbl);

        if not SalesInvoiceHeaderForReport.Get(SalesInvoiceHeader."No.") then
            Error(InvoiceNotFoundErrLbl, SalesInvoiceHeader."No.");

        SalesInvoiceHeaderForReport.SetRecFilter();
        HeaderFiltersTxt := SalesInvoiceHeaderForReport.GetFilters();
        if HeaderFiltersTxt = '' then
            Error(InvoiceFilterBlankErrLbl, SalesInvoiceHeader."No.");

        SalesInvoiceHeaderRef.GetTable(SalesInvoiceHeaderForReport);
        ReportId := ResolveInvoiceReportId();

        PdfTempBlob.CreateOutStream(PdfOutStream);
        Report.SaveAs(ReportId, '', ReportFormat::Pdf, PdfOutStream, SalesInvoiceHeaderRef);
    end;

    // Resolves the report ID for posted sales invoice output.
    // Priority: EQM Rental Report Selections (Invoice, email attachment) then standard Report Selections (S.Invoice).
    local procedure ResolveInvoiceReportId(): Integer
    var
        ReportSelections: Record "Report Selections";
    begin
        // First preference: explicit EQM Rental Invoice usage from the Report Selection Usage enum extension.
        ReportSelections.SetRange(Usage, ReportSelections.Usage::"EQM Rental Invoice");
        ReportSelections.SetRange("Use for Email Attachment", true);
        if ReportSelections.FindFirst() and (ReportSelections."Report ID" <> 0) then
            exit(ReportSelections."Report ID");

        ReportSelections.Reset();
        ReportSelections.SetRange(Usage, ReportSelections.Usage::"S.Invoice");
        ReportSelections.SetRange("Use for Email Attachment", true);
        if ReportSelections.FindFirst() and (ReportSelections."Report ID" <> 0) then
            exit(ReportSelections."Report ID");

        // Final fallback if attachment flag is not configured.
        ReportSelections.SetRange("Use for Email Attachment", false);
        if ReportSelections.FindFirst() and (ReportSelections."Report ID" <> 0) then
            exit(ReportSelections."Report ID");

        Error(InvoiceReportSelectionMissingErrLbl);
    end;

    // Resolves the recipient invoice email from bill-to or sell-to customer.
    // Returns blank when customer is missing or invoice email is not configured.
    // Used by ProcessInvoices to decide whether invoice can be emailed.
    local procedure GetCustomerInvoiceEmail(SalesInvoiceHeader: Record "Sales Invoice Header"): Text[250]
    var
        Customer: Record Customer;
        CustomerNo: Code[20];
    begin
        CustomerNo := SalesInvoiceHeader."Bill-to Customer No.";
        if CustomerNo = '' then
            CustomerNo := SalesInvoiceHeader."Sell-to Customer No.";

        if (CustomerNo = '') or (not Customer.Get(CustomerNo)) then
            exit('');

        exit(Customer."I2I Invoice Email");
    end;

    // Creates a Record Link marker to prevent duplicate email sends for the same invoice.
    // Skips marker creation when the marker already exists.
    // Used after successful enqueue in TrySendInvoiceEmail.
    local procedure MarkInvoiceAsQueued(SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        RecordLink: Record "Record Link";
    begin
        if IsInvoiceAlreadySent(SalesInvoiceHeader) then
            exit;

        RecordLink.Init();
        RecordLink."Record ID" := SalesInvoiceHeader.RecordId;
        RecordLink.Type := RecordLink.Type::Link;
        RecordLink.URL1 := EmailQueuedMarkerUrlLbl;
        RecordLink.Description := CopyStr(StrSubstNo(InvoiceQueuedMarkerDescriptionLbl, SalesInvoiceHeader."No.", CurrentDateTime()), 1, MaxStrLen(RecordLink.Description));
        RecordLink.Notify := false;
        RecordLink.Insert(true);
    end;

    // Checks whether the invoice already has the sent-marker Record Link.
    // Returns true when duplicate protection marker is found.
    // Used before processing and before marker creation for idempotent behavior.
    local procedure IsInvoiceAlreadySent(SalesInvoiceHeader: Record "Sales Invoice Header"): Boolean
    var
        RecordLink: Record "Record Link";
    begin
        RecordLink.SetRange("Record ID", SalesInvoiceHeader.RecordId);
        RecordLink.SetRange(Type, RecordLink.Type::Link);
        RecordLink.SetRange(URL1, EmailQueuedMarkerUrlLbl);
        exit(not RecordLink.IsEmpty());
    end;

    var
        EmailQueuedMarkerUrlLbl: Label 'bc://i2i/posted-sales-invoice/queued';
        UnexpectedStatusMsgLbl: Label 'Invoice processing returned unexpected status "%1". Counted as error.';
        GeneratedPdfEmptyErrLbl: Label 'Generated PDF is empty for invoice %1.';
        GeneratedPdfInvalidSizeErrLbl: Label 'Generated PDF has invalid size for invoice %1.';
        InvoiceNoBlankErrLbl: Label 'Cannot generate posted sales invoice PDF because invoice No. is blank.';
        InvoiceNotFoundErrLbl: Label 'Posted sales invoice %1 was not found while preparing the selected invoice report.';
        InvoiceFilterBlankErrLbl: Label 'Cannot run the selected invoice report for invoice %1 because header filters are blank before Report.SaveAs.';
        InvoiceReportSelectionMissingErrLbl: Label 'No report is configured for invoice email in Report Selections (Rental Invoice or S.Invoice).';
        InvoiceEmailSubjectLbl: Label 'Your posted sales invoice %1';
        InvoiceEmailBodyLbl: Label 'Geachte mevrouw, heer,<br/><br/>U heeft net een factuur ontvangen, deze is helaas niet correct.<br/><br/>Hierbij ontvangt u de juiste factuur.<br/>We verzoeken u de eerder verzonden factuur als niet verzonden te beschouwen.<br/><br/>Als u vragen heeft, dan hoor ik het graag.<br/><br/>Met vriendelijke groet,<br/><br/><strong>Sabine den Besten</strong><br/>Roldo Rent BV<br/><br/>📧 Sabine.denbesten@roldorent.nl<br/>📍 Middelerf 10, 3851 SP Ermelo<br/>📞 +31 (0) 341-56 43 40<br/>🌐 <a href="https://www.roldorent.com">www.roldorent.com</a><br/><br/>Werkdagen maandag, dinsdag, woensdag- en donderdagochtend.<br/><br/><a href="https://roldorent.nl/vestigingen/">Vestigingen - Roldo Rent</a><br/>Hier vindt u alle hoofdkantoren en depots van Roldo Rent binnen Europa.';
        InvoiceAttachmentNameLbl: Label 'PostedSalesInvoice_%1.pdf';
        InvoiceQueuedMarkerDescriptionLbl: Label 'Invoice %1 emailed by Job Queue at %2';
        NoErrorTextFallbackLbl: Label 'No error text was returned by GetLastErrorText().';
        StatusSentLbl: Label 'Sent';
        StatusSkippedLbl: Label 'Skipped';
        StatusErrorLbl: Label 'Error';
        SuccessReasonLbl: Label 'Invoice email queued successfully.';
        MissingEmailReasonLbl: Label 'Customer email is blank.';
        AlreadySentReasonLbl: Label 'Invoice is already marked as sent.';
        LastProcessStatusTxt: Text;
        LastProcessReasonTxt: Text;
        SalesInvoice: Report "Standard Sales - Invoice";
}
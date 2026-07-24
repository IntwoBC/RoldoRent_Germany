codeunit 60002 "I2I Rental Doc. Email Mgt"
{
    procedure SendRentalContractByEmail(var RentalHeader: Record "EQM Rental Header")
    var
        DocumentRef: RecordRef;
        DocumentNo: Code[20];
        BillToContactNo: Text;
        CustomerName: Text[100];
    begin
        RentalHeader.SetRecFilter();
        DocumentRef.GetTable(RentalHeader);

        DocumentNo := RentalHeader."Contract No.";
        BillToContactNo := ResolveContactNoFromDocument(DocumentRef);
        CustomerName := ResolveCustomerNameFromDocument(DocumentRef);

        SendByEmail(DocumentRef, Enum::"I2I Rental Email Doc. Type"::"Rental Contract", DocumentNo, CopyStr(BillToContactNo, 1, 20), CustomerName);
    end;

    procedure DownloadRentalContractReports(var RentalHeader: Record "EQM Rental Header")
    var
        DocumentRef: RecordRef;
        DocumentNo: Code[20];
        CustomerName: Text[100];
        SelectedReports: Record "I2I Rental Email Report Buffer" temporary;
    begin
        RentalHeader.SetRecFilter();
        DocumentRef.GetTable(RentalHeader);

        DocumentNo := RentalHeader."Contract No.";
        CustomerName := ResolveCustomerNameFromDocument(DocumentRef);

        LoadAndSelectReports(Enum::"I2I Rental Email Doc. Type"::"Rental Contract", SelectedReports, true);
        if SelectedReports.IsEmpty() then
            exit;
        ValidateSelectedReports(SelectedReports);
        DownloadSelectedReports(SelectedReports, DocumentRef, DocumentNo, CustomerName);
    end;

    procedure DownloadRentalCollectionReports(var RentalCollection: Record "EQM Rental Dispatch Header")
    var
        DocumentRef: RecordRef;
        DocumentNo: Code[20];
        CustomerName: Text[100];
        SelectedReports: Record "I2I Rental Email Report Buffer" temporary;
    begin
        RentalCollection.SetRecFilter();
        DocumentRef.GetTable(RentalCollection);

        DocumentNo := RentalCollection."No.";
        CustomerName := ResolveCustomerNameFromDocument(DocumentRef);

        LoadAndSelectReports(Enum::"I2I Rental Email Doc. Type"::"Rental Collection Order", SelectedReports, true);
        if SelectedReports.IsEmpty() then
            exit;
        ValidateSelectedReports(SelectedReports);
        DownloadSelectedReports(SelectedReports, DocumentRef, DocumentNo, CustomerName);
    end;

    procedure SendRentalCollectionOrderByEmail(var RentalDispatchHeader: Record "EQM Rental Dispatch Header")
    var
        DocumentRef: RecordRef;
        DocumentNo: Code[20];
        BillToContactNo: Text;
        CustomerName: Text[100];
    begin
        RentalDispatchHeader.SetRecFilter();
        DocumentRef.GetTable(RentalDispatchHeader);

        DocumentNo := RentalDispatchHeader."No.";
        BillToContactNo := ResolveContactNoFromDocument(DocumentRef);
        CustomerName := ResolveCustomerNameFromDocument(DocumentRef);

        SendByEmail(DocumentRef, Enum::"I2I Rental Email Doc. Type"::"Rental Collection Order", DocumentNo, CopyStr(BillToContactNo, 1, 20), CustomerName);
    end;

    local procedure SendByEmail(DocumentRef: RecordRef; DocumentType: Enum "I2I Rental Email Doc. Type"; DocumentNo: Code[20]; BillToContactNo: Code[20]; CustomerName: Text[100])
    var
        SelectedReports: Record "I2I Rental Email Report Buffer" temporary;
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        SalesSetup: Record "Sales & Receivables Setup";
        EmailBodyFormatter: Codeunit "I2I Email Body Sig. Inserter";
        ToRecipients: List of [Text];
        RecipientEmail: Text[250];
        SubjectText: Text;
        BodyText: Text;
    begin
        if DocumentNo = '' then
            Error(DocumentNoRequiredErrLbl);

        LoadAndSelectReports(DocumentType, SelectedReports, false);
        ValidateSelectedReports(SelectedReports);

        SalesSetup.Get();
        RecipientEmail := ResolveRecipientEmail(BillToContactNo);
        BodyText := GetConfiguredEmailBody(SelectedReports);
        BodyText := EmailBodyFormatter.BuildEmailBodyWithSignature(BodyText, SalesSetup."I2I Rental Email Sig. Tmpl");
        SubjectText := BuildSubject(DocumentType, DocumentNo);

        ToRecipients.Add(RecipientEmail);
        EmailMessage.Create(ToRecipients, SubjectText, BodyText, true);

        AddSelectedReportAttachments(EmailMessage, SelectedReports, DocumentRef, DocumentNo, CustomerName);

        if GuiAllowed() then
            Email.OpenInEditorModally(EmailMessage, Enum::"Email Scenario"::Default)
        else
            Email.Enqueue(EmailMessage, Enum::"Email Scenario"::Default);
    end;

    local procedure LoadAndSelectReports(DocumentType: Enum "I2I Rental Email Doc. Type"; var SelectedReports: Record "I2I Rental Email Report Buffer" temporary; IsDownloadMode: Boolean)
    var
        SelectionPage: Page "I2I Rental Email Report Select";
        AvailableReports: Record "I2I Rental Email Report Buffer" temporary;
        TempBuffer: Record "I2I Rental Email Report Buffer" temporary;
        ActionResult: Action;
    begin
        GetAvailableReportsForDocumentType(DocumentType, AvailableReports);
        if AvailableReports.IsEmpty() then
            Error(NoReportsAvailableErrLbl, Format(DocumentType));

        SelectionPage.SetDownloadMode(IsDownloadMode);
        SelectionPage.SetDocumentTypeContext(DocumentType = DocumentType::"Rental Collection Order");
        SelectionPage.SetReportBuffer(TempBuffer);
        SelectionPage.LookupMode(true);
        ActionResult := SelectionPage.RunModal();
        if SelectionPage.WasDownloadRequested() then begin
            SelectionPage.GetReportBuffer(SelectedReports);
            exit;
        end;

        if IsDownloadMode then begin
            SelectedReports.Reset();
            SelectedReports.DeleteAll();
            exit;
        end;

        if not (ActionResult in [Action::OK, Action::LookupOK]) then
            Error(SendCancelledErrLbl);

        SelectionPage.GetReportBuffer(SelectedReports);
    end;

    procedure GetAvailableReportsForDocumentType(DocumentType: Enum "I2I Rental Email Doc. Type"; var TempBuffer: Record "I2I Rental Email Report Buffer" temporary)
    begin
        TempBuffer.Reset();
        TempBuffer.DeleteAll();

        case DocumentType of
            DocumentType::"Rental Contract":
                begin
                    AddSelectableReport(TempBuffer, DocumentType, Report::"Order Confirmation", RentalContractOrderWithTransportLbl);
                    AddSelectableReport(TempBuffer, DocumentType, Report::"Order Conf. W/O Transport", RentalContractOrderWithoutTransportLbl);
                    AddSelectableReport(TempBuffer, DocumentType, Report::"Transport Order Rental", RentalContractTransportOrderLbl);
                    AddSelectableReport(TempBuffer, DocumentType, Report::"Rental Order For depot", RentalContractDepotDocumentLbl);
                end;
            DocumentType::"Rental Collection Order":
                begin
                    AddSelectableReport(TempBuffer, DocumentType, Report::"Order Conf. for Ret. Transport", RentalCollectionOrderConfirmationReturnLbl);
                    AddSelectableReport(TempBuffer, DocumentType, Report::"Transport Order Return", RentalCollectionTransportOrderLbl);
                    AddSelectableReport(TempBuffer, DocumentType, Report::"Return Slip for Depot", RentalCollectionReturnSlipLbl);
                end;
        end;
    end;

    local procedure AddSelectableReport(var TempBuffer: Record "I2I Rental Email Report Buffer" temporary; DocumentType: Enum "I2I Rental Email Doc. Type"; ReportId: Integer; ReportName: Text)
    begin
        TempBuffer.Init();
        TempBuffer."Entry No." := TempBuffer.Count() + 1;
        TempBuffer."Document Type" := DocumentType;
        TempBuffer."Report ID" := ReportId;
        TempBuffer."Report Name" := CopyStr(ReportName, 1, MaxStrLen(TempBuffer."Report Name"));
        TempBuffer.Selected := false;
        TempBuffer.Insert();
    end;

    local procedure ValidateSelectedReports(var SelectedReports: Record "I2I Rental Email Report Buffer" temporary)
    begin
        SelectedReports.SetRange(Selected, true);
        if SelectedReports.IsEmpty() then
            Error(NoReportsSelectedErrLbl);

        SelectedReports.SetRange(Selected);
    end;

    local procedure ResolveRecipientEmail(BillToContactNo: Code[20]): Text[250]
    var
        Contact: Record Contact;
        EmailAccount: Codeunit "Email Account";
        RecipientEmail: Text[250];
    begin
        if BillToContactNo = '' then
            Error(BillToContactNoRequiredErrLbl);

        if not Contact.Get(BillToContactNo) then
            Error(ContactNotFoundErrLbl, BillToContactNo);

        RecipientEmail := Contact."E-Mail";
        if RecipientEmail = '' then
            Error(ContactEmailRequiredErrLbl, BillToContactNo);

        EmailAccount.ValidateEmailAddress(RecipientEmail, false);
        exit(RecipientEmail);
    end;

    local procedure ResolveContactNoFromDocument(DocumentRef: RecordRef): Text
    var
        BillToContactNo: Text;
    begin
        BillToContactNo := GetTextFieldValue(DocumentRef, BillToContactNoFieldNameLbl);
        if BillToContactNo <> '' then
            exit(BillToContactNo);

        BillToContactNo := GetTextFieldValue(DocumentRef, FallbackContactNoFieldNameLbl);
        if BillToContactNo <> '' then
            exit(BillToContactNo);

        exit('');
    end;

    local procedure ResolveCustomerNameFromDocument(DocumentRef: RecordRef): Text
    var
        CustomerName: Text[100];
    begin
        CustomerName := GetTextFieldValue(DocumentRef, BillToCustomerNameLbl);
        if CustomerName <> '' then
            exit(CustomerName);

        CustomerName := GetTextFieldValue(DocumentRef, FallbackCustomerNameLbl);
        if CustomerName <> '' then
            exit(CustomerName);

        exit('');
    end;

    local procedure GetTextFieldValue(DocumentRef: RecordRef; FieldName: Text): Text
    var
        FieldRef: FieldRef;
        FieldIndex: Integer;
    begin
        for FieldIndex := 1 to DocumentRef.FieldCount() do begin
            FieldRef := DocumentRef.FieldIndex(FieldIndex);
            if FieldRef.Name() = FieldName then
                exit(Format(FieldRef.Value()));
        end;

        exit('');
    end;

    local procedure GetConfiguredEmailBody(var SelectedReports: Record "I2I Rental Email Report Buffer" temporary): Text
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        SalesSetup.Get();

        if IsDepotDocumentSelected(SelectedReports) then
            exit(SalesSetup."I2I Rental Depot Email body");

        exit(SalesSetup."I2I Rental Email Body");
    end;

    local procedure BuildSubject(DocumentType: Enum "I2I Rental Email Doc. Type"; DocumentNo: Code[20]): Text
    begin
        case DocumentType of
            DocumentType::"Rental Contract":
                exit(StrSubstNo(RentalContractSubjectLbl, DocumentNo));
            DocumentType::"Rental Collection Order":
                exit(StrSubstNo(RentalCollectionOrderSubjectLbl, DocumentNo));
        end;
    end;

    local procedure IsDepotDocumentSelected(var SelectedReports: Record "I2I Rental Email Report Buffer" temporary): Boolean
    var
        SelectedReportCheck: Record "I2I Rental Email Report Buffer" temporary;
    begin
        SelectedReportCheck.Copy(SelectedReports, true);
        SelectedReportCheck.SetRange(Selected, true);
        SelectedReportCheck.SetFilter("Report ID", '%1|%2', Report::"Rental Order For depot", Report::"Return Slip for Depot");
        exit(not SelectedReportCheck.IsEmpty());
    end;

    local procedure AddSelectedReportAttachments(var EmailMessage: Codeunit "Email Message"; var SelectedReports: Record "I2I Rental Email Report Buffer" temporary; DocumentRef: RecordRef; DocumentNo: Code[20]; CustomerName: Text[100])
    var
        PdfTempBlob: Codeunit "Temp Blob";
        PdfInStream: InStream;
        AttachmentName: Text[250];
    begin
        SelectedReports.SetRange(Selected, true);
        if SelectedReports.FindSet() then
            repeat
                GenerateReportPdf(SelectedReports."Report ID", DocumentRef, PdfTempBlob);

                if not PdfTempBlob.HasValue() then
                    Error(ReportGenerationFailedErrLbl, SelectedReports."Report Name");

                PdfTempBlob.CreateInStream(PdfInStream);
                AttachmentName := BuildAttachmentName(SelectedReports."Report Name", DocumentNo, CustomerName);
                EmailMessage.AddAttachment(AttachmentName, 'application/pdf', PdfInStream);
            until SelectedReports.Next() = 0;
    end;

    local procedure GenerateReportPdf(ReportId: Integer; DocumentRef: RecordRef; var PdfTempBlob: Codeunit "Temp Blob")
    var
        PdfOutStream: OutStream;
    begin
        PdfTempBlob.CreateOutStream(PdfOutStream);
        Report.SaveAs(ReportId, '', ReportFormat::Pdf, PdfOutStream, DocumentRef);
    end;

    local procedure BuildAttachmentName(ReportName: Text; DocumentNo: Code[20]; CustomerName: Text[100]): Text[250]
    var
        FileName: Text;
    begin
        ReportName := SanitizeFileNamePart(ReportName);
        if ReportName = '' then
            ReportName := DefaultReportNameLbl;

        FileName := StrSubstNo('%1_%2.pdf', CustomerName, DocumentNo);
        exit(CopyStr(FileName, 1, 250));
    end;

    local procedure SanitizeFileNamePart(Value: Text): Text
    begin
        Value := DelChr(Value, '=', '<>:"/\\|?*');
        exit(TrimTrailingDotsAndSpaces(Value.Trim()));
    end;

    local procedure TrimTrailingDotsAndSpaces(Value: Text): Text
    begin
        while StrLen(Value) > 0 do
            if (CopyStr(Value, StrLen(Value), 1) = '.') or (CopyStr(Value, StrLen(Value), 1) = ' ') then
                Value := DelStr(Value, StrLen(Value), 1)
            else
                exit(Value);

        exit(Value);
    end;

    procedure DownloadSelectedReports(var SelectedReports: Record "I2I Rental Email Report Buffer" temporary; DocumentRef: RecordRef; DocumentNo: Code[20]; CustomerName: Text[100])
    var
        PdfTempBlob: Codeunit "Temp Blob";
        PdfInStream: InStream;
        ZipTempBlob: Codeunit "Temp Blob";
        ZipOutStream: OutStream;
        ZipInStream: InStream;
        DataCompression: Codeunit "Data Compression";
        FileName: Text[250];
        ZipFileName: Text[250];
        SequenceNo: Integer;
        SelectedCount: Integer;
    begin
        SelectedReports.SetRange(Selected, true);
        SelectedCount := SelectedReports.Count;
        if SelectedCount = 0 then
            exit;

        if SelectedCount = 1 then begin
            SelectedReports.FindFirst();
            GenerateReportPdf(SelectedReports."Report ID", DocumentRef, PdfTempBlob);
            if not PdfTempBlob.HasValue() then
                Error(ReportGenerationFailedErrLbl, SelectedReports."Report Name");

            FileName := BuildDownloadFileName(DocumentNo, CustomerName, 1);
            PdfTempBlob.CreateInStream(PdfInStream);
            DownloadFromStream(PdfInStream, '', '', '', FileName);
            exit;
        end;

        DataCompression.CreateZipArchive();
        if SelectedReports.FindSet() then
            repeat
                GenerateReportPdf(SelectedReports."Report ID", DocumentRef, PdfTempBlob);
                if not PdfTempBlob.HasValue() then
                    Error(ReportGenerationFailedErrLbl, SelectedReports."Report Name");

                SequenceNo += 1;
                FileName := BuildDownloadFileName(DocumentNo, CustomerName, SequenceNo);
                PdfTempBlob.CreateInStream(PdfInStream);
                DataCompression.AddEntry(PdfInStream, FileName);
            until SelectedReports.Next() = 0;

        ZipTempBlob.CreateOutStream(ZipOutStream);
        DataCompression.SaveZipArchive(ZipOutStream);
        DataCompression.CloseZipArchive();

        ZipTempBlob.CreateInStream(ZipInStream);
        ZipFileName := BuildDownloadArchiveFileName(DocumentNo, CustomerName);
        DownloadFromStream(ZipInStream, '', '', '', ZipFileName);
    end;

    local procedure BuildDownloadFileName(DocumentNo: Code[20]; CustomerName: Text[100]; SequenceNo: Integer): Text[250]
    var
        BaseFileName: Text[250];
        BaseNameWithoutExt: Text[250];
    begin
        BaseFileName := BuildAttachmentName('', DocumentNo, CustomerName);
        if SequenceNo <= 1 then
            exit(BaseFileName);

        if StrLen(BaseFileName) > 4 then
            BaseNameWithoutExt := CopyStr(BaseFileName, 1, StrLen(BaseFileName) - 4)
        else
            BaseNameWithoutExt := DefaultReportNameLbl;

        exit(CopyStr(StrSubstNo('%1_%2.pdf', BaseNameWithoutExt, SequenceNo), 1, 250));
    end;

    local procedure BuildDownloadArchiveFileName(DocumentNo: Code[20]; CustomerName: Text[100]): Text[250]
    var
        BaseFileName: Text[250];
        BaseNameWithoutExt: Text[250];
    begin
        BaseFileName := BuildAttachmentName('', DocumentNo, CustomerName);
        if StrLen(BaseFileName) > 4 then
            BaseNameWithoutExt := CopyStr(BaseFileName, 1, StrLen(BaseFileName) - 4)
        else
            BaseNameWithoutExt := DefaultReportNameLbl;

        exit(CopyStr(StrSubstNo('%1.zip', BaseNameWithoutExt), 1, 250));
    end;

    var
        BillToContactNoRequiredErrLbl: Label 'Bill-to Contact No. must be populated before sending email.';
        ContactNotFoundErrLbl: Label 'Contact %1 was not found.';
        ContactEmailRequiredErrLbl: Label 'Contact %1 does not have an email address.';
        DocumentNoRequiredErrLbl: Label 'Document number is required to send email.';
        NoReportsAvailableErrLbl: Label 'No reports are available for %1.';
        NoReportsSelectedErrLbl: Label 'Select at least one report to send by email.';
        ReportGenerationFailedErrLbl: Label 'Failed to generate PDF for report %1.';
        RentalContractSubjectLbl: Label 'Rental Contract %1';
        RentalCollectionOrderSubjectLbl: Label 'Rental Collection Order %1';
        RentalContractOrderWithTransportLbl: Label 'Order with Transport', Locked = true;
        RentalContractOrderWithoutTransportLbl: Label 'Order without Transport', Locked = true;
        RentalContractTransportOrderLbl: Label 'Transport Order Rental', Locked = true;
        RentalContractDepotDocumentLbl: Label 'Depot Document', Locked = true;
        RentalCollectionOrderConfirmationReturnLbl: Label 'Order Confirmation Return', Locked = true;
        RentalCollectionTransportOrderLbl: Label 'Transport Order Return', Locked = true;
        RentalCollectionReturnSlipLbl: Label 'Return Slip for Depot', Locked = true;
        DefaultReportNameLbl: Label 'Report', Locked = true;
        SendCancelledErrLbl: Label 'Operation was cancelled.';
        BillToContactNoFieldNameLbl: Label 'Bill-to Contact No.', Locked = true;
        FallbackContactNoFieldNameLbl: Label 'I2I Contact No.', Locked = true;
        BillToCustomerNameLbl: Label 'Customer Name', Locked = true;
        FallbackCustomerNameLbl: Label 'Name', Locked = true;
}

pageextension 60018 "I2I Email Editor" extends "Email Editor"
{

    actions
    {
        modify(Send)
        {
            trigger OnAfterAction()
            begin
                if not ShouldMarkManualEmailAsQueued() then
                    exit;

                MarkManualEmailAsQueued();
            end;
        }
    }

    trigger OnAfterGetRecord()
    var
        EmailMessage: Codeunit "Email Message";
    begin
        EmailMessage := GetEmailMessage();
        if not IsSupportedPostedSalesDocumentEmail(EmailMessage.GetSubject()) then
            exit;

        SetDefaultToRecipientFromPostedDocumentEmail();
        SetDefaultEmailBodyTemplate();
        SetPostedDocumentAttachmentName();
    end;

    local procedure IsSupportedPostedSalesDocumentEmail(EmailSubject: Text): Boolean
    var
        PostedDocumentType: Enum "I2I Rental Email Doc. Type";
        PostedDocumentNo: Code[20];
        CustomerNo: Code[20];
        CustomerName: Text;
    begin
        exit(TryGetPostedDocumentContextFromSubject(EmailSubject, PostedDocumentType, PostedDocumentNo, CustomerNo, CustomerName));
    end;

    local procedure MarkManualEmailAsQueued()
    var
        EmailMessage: Codeunit "Email Message";
        ManualEmailMarkerSub: Codeunit "I2I Manual Email Marker Sub";
    begin
        EmailMessage := GetEmailMessage();
        ManualEmailMarkerSub.MarkInvoiceAsQueuedFromEmailMessage(EmailMessage);
    end;

    local procedure ShouldMarkManualEmailAsQueued(): Boolean
    var
        EmailMessage: Codeunit "Email Message";
        PostedDocumentType: Enum "I2I Rental Email Doc. Type";
        PostedDocumentNo: Code[20];
        CustomerNo: Code[20];
        CustomerName: Text;
    begin
        EmailMessage := GetEmailMessage();

        if not TryGetPostedDocumentContextFromSubject(EmailMessage.GetSubject(), PostedDocumentType, PostedDocumentNo, CustomerNo, CustomerName) then
            exit(false);

        exit((PostedDocumentType = Enum::"I2I Rental Email Doc. Type"::Invoice) or
            (PostedDocumentType = Enum::"I2I Rental Email Doc. Type"::"Credit Memo"));
    end;

    local procedure SetDefaultToRecipientFromPostedDocumentEmail()
    var
        EmailMessage: Codeunit "Email Message";
        CustomerDocumentEmail: Text[100];
    begin
        EmailMessage := GetEmailMessage();

        // if ToRecipient <> '' then
        //     exit;

        if not TryResolveCustomerDocumentEmailFromSubject(EmailMessage.GetSubject(), CustomerDocumentEmail) then
            exit;

        ToRecipient := CustomerDocumentEmail;
        EmailMessage.SetRecipients(Enum::"Email Recipient Type"::"To", ToRecipient);
    end;

    [TryFunction]
    local procedure TryResolveCustomerDocumentEmailFromSubject(EmailSubject: Text; var CustomerDocumentEmail: Text[100])
    begin
        if not TryGetCustomerDocumentEmailFromSubject(EmailSubject, CustomerDocumentEmail) then
            Error(CustomerEmailNotResolvedErrLbl);
    end;

    local procedure TryGetCustomerDocumentEmailFromSubject(EmailSubject: Text; var CustomerDocumentEmail: Text[100]): Boolean
    var
        PostedDocumentType: Enum "I2I Rental Email Doc. Type";
        PostedDocumentNo: Code[20];
        CustomerName: Text;
        Customer: Record Customer;
        CustomerNo: Code[20];
    begin
        if not TryGetPostedDocumentContextFromSubject(EmailSubject, PostedDocumentType, PostedDocumentNo, CustomerNo, CustomerName) then
            exit(false);

        if (CustomerNo = '') or (not Customer.Get(CustomerNo)) then
            exit(false);

        CustomerDocumentEmail := GetPostedDocumentCustomerEmail(PostedDocumentType, Customer);

        exit(CustomerDocumentEmail <> '');
    end;

    local procedure ExtractDocNoFromSubject(EmailSubject: Text): Code[20]
    var
        StartPos: Integer;
        EndPos: Integer;
        SubjectLength: Integer;
        CandidateInvoiceNo: Text;
    begin
        SubjectLength := StrLen(EmailSubject);
        if SubjectLength = 0 then
            exit('');

        EndPos := SubjectLength;
        while EndPos > 0 do begin
            if CopyStr(EmailSubject, EndPos, 1) <> ' ' then
                break;
            EndPos -= 1;
        end;

        if EndPos = 0 then
            exit('');

        StartPos := EndPos;
        while StartPos > 1 do begin
            if CopyStr(EmailSubject, StartPos - 1, 1) = ' ' then
                break;
            StartPos -= 1;
        end;

        CandidateInvoiceNo := CopyStr(EmailSubject, StartPos, EndPos - StartPos + 1);
        exit(CopyStr(CandidateInvoiceNo, 1, 20));
    end;

    local procedure SetDefaultEmailBodyTemplate()
    var
        EmailMessage: Codeunit "Email Message";
        SalesSetup: Record "Sales & Receivables Setup";
        EmailBodyFormatter: Codeunit "I2I Email Body Sig. Inserter";
        PostedDocumentType: Enum "I2I Rental Email Doc. Type";
        PostedDocumentNo: Code[20];
        CustomerNo: Code[20];
        CustomerName: Text;
        EmailBody: Text;
        CurrentBody: Text;
        NewBody: Text;
    begin
        EmailMessage := GetEmailMessage();

        SalesSetup.Get();
        if not TryGetPostedDocumentContextFromSubject(EmailMessage.GetSubject(), PostedDocumentType, PostedDocumentNo, CustomerNo, CustomerName) then
            EmailBody := SalesSetup."I2I Email Body"
        else
            if PostedDocumentType = PostedDocumentType::Reminder then
                EmailBody := SalesSetup."I2I Reminder Email Body"
            else
                EmailBody := SalesSetup."I2I Email Body";

        CurrentBody := EmailMessage.GetBody();
        NewBody := EmailBodyFormatter.BuildEmailBodyWithSignature(
            EmailBody,
            SalesSetup."I2I Rental Email Sig. Tmpl");

        if CurrentBody = NewBody then
            exit;

        EmailMessage.SetBody('');
        EmailMessage.SetBody(NewBody);
        CurrPage.Update(true);
    end;

    local procedure SetPostedDocumentAttachmentName()
    var
        EmailMessage: Codeunit "Email Message";
        PostedDocumentType: Enum "I2I Rental Email Doc. Type";
        PostedDocumentNo: Code[20];
        CustomerNo: Code[20];
        CustomerName: Text;
        Customer: Record Customer;
        TempBlob: Codeunit "Temp Blob";
        ExistingAttachmentInStream: InStream;
        AttachmentOutStream: OutStream;
        AttachmentInStream: InStream;
        ExistingAttachmentName: Text[250];
        ExistingContentType: Text[250];
        ExistingContentId: Text[40];
        AttachmentExtension: Text;
        NewAttachmentName: Text[250];
        IsInline: Boolean;
    begin
        EmailMessage := GetEmailMessage();

        if not TryGetPostedDocumentContextFromSubject(EmailMessage.GetSubject(), PostedDocumentType, PostedDocumentNo, CustomerNo, CustomerName) then
            exit;

        if not EmailMessage.Attachments_First() then
            exit;

        ExistingAttachmentName := EmailMessage.Attachments_GetName();
        ExistingContentType := EmailMessage.Attachments_GetContentType();
        ExistingContentId := EmailMessage.Attachments_GetContentId();
        IsInline := EmailMessage.Attachments_IsInline();

        AttachmentExtension := GetAttachmentExtension(ExistingAttachmentName);
        if AttachmentExtension = '' then
            AttachmentExtension := PdfExtensionTok;

        if CustomerName = '' then
            if (CustomerNo <> '') and Customer.Get(CustomerNo) then
                CustomerName := Customer.Name;

        NewAttachmentName := BuildPostedDocumentAttachmentName(CustomerName, PostedDocumentNo, AttachmentExtension);

        if ExistingAttachmentName = NewAttachmentName then
            exit;

        EmailMessage.Attachments_GetContent(ExistingAttachmentInStream);
        TempBlob.CreateOutStream(AttachmentOutStream);
        CopyStream(AttachmentOutStream, ExistingAttachmentInStream);
        TempBlob.CreateInStream(AttachmentInStream);

        if not EmailMessage.Attachments_Delete() then
            exit;

        EmailMessage.AddAttachment(NewAttachmentName, ExistingContentType, IsInline, ExistingContentId, AttachmentInStream);
    end;

    local procedure BuildPostedDocumentAttachmentName(CustomerName: Text; DocumentNo: Code[20]; AttachmentExtension: Text): Text[250]
    var
        FileName: Text;
    begin
        CustomerName := SanitizeFileNamePart(CustomerName);
        if CustomerName = '' then
            CustomerName := UnknownCustomerTok;

        FileName := StrSubstNo('%1_%2%3', CustomerName, DocumentNo, AttachmentExtension);
        exit(CopyStr(FileName, 1, 250));
    end;

    local procedure GetPostedDocumentCustomerEmail(PostedDocumentType: Enum "I2I Rental Email Doc. Type"; Customer: Record Customer): Text[100]
    begin
        case PostedDocumentType of
            PostedDocumentType::Reminder:
                exit(Customer."I2I Reminder Email");
            else
                exit(Customer."I2I Invoice Email");
        end;
    end;

    local procedure TryGetPostedDocumentContextFromSubject(EmailSubject: Text; var PostedDocumentType: Enum "I2I Rental Email Doc. Type"; var PostedDocumentNo: Code[20]; var CustomerNo: Code[20]; var CustomerName: Text): Boolean
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        IssuedReminder: Record "Issued Reminder Header";
        Customer: Record Customer;
    begin
        if TryGetSalesInvoiceHeaderFromSubject(EmailSubject, SalesInvoiceHeader) then begin
            PostedDocumentType := Enum::"I2I Rental Email Doc. Type"::Invoice;
            PostedDocumentNo := SalesInvoiceHeader."No.";
            CustomerNo := SalesInvoiceHeader."Bill-to Customer No.";
            if CustomerNo = '' then
                CustomerNo := SalesInvoiceHeader."Sell-to Customer No.";

            CustomerName := SalesInvoiceHeader."Bill-to Name";
            if CustomerName = '' then
                CustomerName := SalesInvoiceHeader."Sell-to Customer Name";

            exit(true);
        end;

        if TryGetSalesCrMemoHeaderFromSubject(EmailSubject, SalesCrMemoHeader) then begin
            PostedDocumentType := Enum::"I2I Rental Email Doc. Type"::"Credit Memo";
            PostedDocumentNo := SalesCrMemoHeader."No.";
            CustomerNo := SalesCrMemoHeader."Bill-to Customer No.";
            if CustomerNo = '' then
                CustomerNo := SalesCrMemoHeader."Sell-to Customer No.";

            CustomerName := SalesCrMemoHeader."Bill-to Name";
            if CustomerName = '' then
                CustomerName := SalesCrMemoHeader."Sell-to Customer Name";

            exit(true);
        end;

        if TryGetIssuedReminderHeaderFromSubject(EmailSubject, IssuedReminder) then begin
            PostedDocumentType := Enum::"I2I Rental Email Doc. Type"::Reminder;
            PostedDocumentNo := IssuedReminder."No.";
            CustomerNo := IssuedReminder."Customer No.";

            if (CustomerNo <> '') and Customer.Get(CustomerNo) then
                CustomerName := Customer.Name;

            exit(true);
        end;

        exit(false);
    end;

    local procedure TryGetSalesInvoiceHeaderFromSubject(EmailSubject: Text; var SalesInvoiceHeader: Record "Sales Invoice Header"): Boolean
    var
        SalesInvoiceNo: Code[20];
    begin
        SalesInvoiceNo := ExtractDocNoFromSubject(EmailSubject);
        if SalesInvoiceNo = '' then
            exit(false);

        exit(SalesInvoiceHeader.Get(SalesInvoiceNo));
    end;

    local procedure TryGetSalesCrMemoHeaderFromSubject(EmailSubject: Text; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"): Boolean
    var
        SalesCrMemoNo: Code[20];
    begin
        SalesCrMemoNo := ExtractDocNoFromSubject(EmailSubject);
        if SalesCrMemoNo = '' then
            exit(false);

        exit(SalesCrMemoHeader.Get(SalesCrMemoNo));
    end;

    local procedure TryGetIssuedReminderHeaderFromSubject(EmailSubject: Text; var IssuedReminder: Record "Issued Reminder Header"): Boolean
    var
        IssuedDocNo: Code[20];
    begin
        IssuedDocNo := ExtractDocNoFromSubject(EmailSubject);
        if IssuedDocNo = '' then
            exit(false);
        exit(IssuedReminder.Get(IssuedDocNo));
    end;

    local procedure BuildInvoiceAttachmentName(SalesInvoiceHeader: Record "Sales Invoice Header"; AttachmentExtension: Text): Text[250]
    var
        CustomerName: Text;
        FileName: Text;
    begin
        CustomerName := SalesInvoiceHeader."Bill-to Name";
        if CustomerName = '' then
            CustomerName := SalesInvoiceHeader."Sell-to Customer Name";

        CustomerName := SanitizeFileNamePart(CustomerName);
        if CustomerName = '' then
            CustomerName := UnknownCustomerTok;

        FileName := StrSubstNo('%1_%2%3', CustomerName, SalesInvoiceHeader."No.", AttachmentExtension);
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

    local procedure GetAttachmentExtension(AttachmentName: Text): Text
    var
        Position: Integer;
        DotPosition: Integer;
    begin
        DotPosition := 0;
        for Position := 1 to StrLen(AttachmentName) do
            if CopyStr(AttachmentName, Position, 1) = '.' then
                DotPosition := Position;

        if DotPosition = 0 then
            exit('');

        exit(CopyStr(AttachmentName, DotPosition));
    end;

    var
        CustomerEmailNotResolvedErrLbl: Label 'Customer invoice email could not be resolved from email subject.';
        InvoiceMailBodyTemplateLbl: Label 'Geachte mevrouw, heer,<br/><br/>U heeft net een factuur ontvangen, deze is helaas niet correct.<br/><br/>Hierbij ontvangt u de juiste factuur.<br/>We verzoeken u de eerder verzonden factuur als niet verzonden te beschouwen.<br/><br/>Als u vragen heeft, dan hoor ik het graag.<br/><br/>Met vriendelijke groet,<br/><br/><strong>Sabine den Besten</strong><br/>Roldo Rent BV<br/><br/>📧 Sabine.denbesten@roldorent.nl<br/>📍 Middelerf 10, 3851 SP Ermelo<br/>📞 +31 (0) 341-56 43 40<br/>🌐 <a href="https://www.roldorent.com">www.roldorent.com</a><br/><br/>Werkdagen maandag, dinsdag, woensdag- en donderdagochtend.<br/><br/><a href="https://roldorent.nl/vestigingen/">Vestigingen - Roldo Rent</a><br/>Hier vindt u alle hoofdkantoren en depots van Roldo Rent binnen Europa.';
        UnknownCustomerTok: Label 'Customer', Locked = true;
        PdfExtensionTok: Label '.pdf', Locked = true;
}
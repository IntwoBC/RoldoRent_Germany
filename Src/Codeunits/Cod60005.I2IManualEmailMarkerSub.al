codeunit 60005 "I2I Manual Email Marker Sub"
{
    Permissions = tabledata "Sales Invoice Header" = R,
                  tabledata "Record Link" = RIMD;

    procedure BackfillMissingInvoiceMarkersFromSentEmails(var CheckedCount: Integer; var AddedCount: Integer)
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        TempSentEmail: Record "Sent Email" temporary;
        Email: Codeunit Email;
    begin
        if not SalesInvoiceHeader.FindSet() then
            exit;

        repeat
            CheckedCount += 1;

            if not IsInvoiceAlreadyMarkedAsQueued(SalesInvoiceHeader) then begin
                TempSentEmail.Reset();
                TempSentEmail.DeleteAll();

                Email.GetSentEmailsForRecord(Database::"Sales Invoice Header", SalesInvoiceHeader.SystemId, TempSentEmail);
                if not TempSentEmail.IsEmpty() then begin
                    MarkInvoiceAsQueued(SalesInvoiceHeader);
                    AddedCount += 1;
                end;
            end;
        until SalesInvoiceHeader.Next() = 0;
    end;

    procedure MarkInvoiceAsQueuedFromEmailMessage(EmailMessage: Codeunit "Email Message")
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceNo: Code[20];
    begin
        SalesInvoiceNo := ExtractInvoiceNoFromSubject(EmailMessage.GetSubject());
        if SalesInvoiceNo = '' then
            exit;

        if not SalesInvoiceHeader.Get(SalesInvoiceNo) then
            exit;

        MarkInvoiceAsQueued(SalesInvoiceHeader);
    end;

    local procedure MarkInvoiceAsQueued(SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        RecordLink: Record "Record Link";
    begin
        if IsInvoiceAlreadyMarkedAsQueued(SalesInvoiceHeader) then
            exit;

        RecordLink.Init();
        RecordLink."Record ID" := SalesInvoiceHeader.RecordId;
        RecordLink.Type := RecordLink.Type::Link;
        RecordLink.URL1 := EmailQueuedMarkerUrlLbl;
        RecordLink.Description := CopyStr(StrSubstNo(InvoiceQueuedMarkerDescriptionLbl, SalesInvoiceHeader."No.", CurrentDateTime()), 1, MaxStrLen(RecordLink.Description));
        RecordLink.Notify := false;
        RecordLink.Insert(true);
    end;

    local procedure IsInvoiceAlreadyMarkedAsQueued(SalesInvoiceHeader: Record "Sales Invoice Header"): Boolean
    var
        RecordLink: Record "Record Link";
    begin
        RecordLink.SetRange("Record ID", SalesInvoiceHeader.RecordId);
        RecordLink.SetRange(Type, RecordLink.Type::Link);
        RecordLink.SetRange(URL1, EmailQueuedMarkerUrlLbl);
        exit(not RecordLink.IsEmpty());
    end;

    local procedure ExtractInvoiceNoFromSubject(EmailSubject: Text): Code[20]
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

    var
        EmailQueuedMarkerUrlLbl: Label 'bc://i2i/posted-sales-invoice/queued';
        InvoiceQueuedMarkerDescriptionLbl: Label 'Invoice %1 emailed manually at %2';
}

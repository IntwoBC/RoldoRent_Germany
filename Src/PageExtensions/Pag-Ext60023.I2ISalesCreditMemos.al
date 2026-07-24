namespace RoldoRent.RoldoRent;

using Microsoft.Foundation.Reporting;
using Microsoft.Sales.Document;
using System.Utilities;

pageextension 60023 "I2I Sales Credit Memos" extends "Sales Credit Memos"
{
    actions
    {
        addlast(Reporting)
        {
            action(DownloadSalesCrMemo)
            {
                Caption = 'Download Credit Memo';
                Image = Download;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                trigger OnAction()
                var
                    ReportSelection: Record "Report Selections";
                    ReportId: Integer;
                    SalesHeader: Record "Sales Header";
                    SalesCrMemoRef: RecordRef;
                    PdfOutStream: OutStream;
                    PdfInstream: InStream;
                    PdfTempBlob: Codeunit "Temp Blob";
                    FileName: Text[100];
                begin
                    if Rec."No." = '' then
                        Error('Select a credit memo to download.');

                    ReportSelection.SetRange(Usage, ReportSelection.Usage::"S.Cr.Memo");
                    if ReportSelection.FindFirst() then
                        ReportId := ReportSelection."Report ID";

                    if ReportId = 0 then
                        Error('No report is configured for usage %1 in Report Selections.', ReportSelection.Usage::"S.Cr.Memo");

                    SalesHeader.Reset();
                    SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::"Credit Memo");
                    SalesHeader.SetRange("No.", Rec."No.");
                    SalesCrMemoRef.GetTable(SalesHeader);
                    PdfTempBlob.CreateOutStream(PdfOutStream);
                    Report.SaveAs(ReportId, '', ReportFormat::Pdf, PdfOutStream, SalesCrMemoRef);

                    if not PdfTempBlob.HasValue() then
                        Error('Failed to generate PDF for sales credit memo %1.', Rec."No.");

                    FileName := CopyStr(StrSubstNo('%1_%2.pdf', Rec."Bill-to Name", Rec."No."), 1, MaxStrLen(FileName));
                    PdfTempBlob.CreateInStream(PdfInstream);
                    DownloadFromStream(PdfInstream, '', '', '', FileName);
                end;
            }
        }
    }
}

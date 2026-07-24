namespace RoldoRent.RoldoRent;

using Microsoft.Foundation.Reporting;
using Microsoft.Sales.History;
using System.Utilities;

pageextension 60024 "I2I Posted Sales Credit Memos" extends "Posted Sales Credit Memos"
{
    actions
    {
        addlast(Reporting)
        {
            action(DownloadPostedSalesCrMemo)
            {
                Caption = 'Download Posted Credit Memo';
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
                    SalesCrMemoHeader: Record "Sales Cr.Memo Header";
                    SalesCrMemoRef: RecordRef;
                    PdfOutStream: OutStream;
                    PdfInstream: InStream;
                    PdfTempBlob: Codeunit "Temp Blob";
                    FileName: Text[100];
                begin
                    if Rec."No." = '' then
                        Error('Select a posted credit memo to download.');

                    ReportSelection.SetRange(Usage, ReportSelection.Usage::"S.Cr.Memo");
                    if ReportSelection.FindFirst() then
                        ReportId := ReportSelection."Report ID";

                    if ReportId = 0 then
                        Error('No report is configured for usage %1 in Report Selections.', ReportSelection.Usage::"S.Cr.Memo");

                    SalesCrMemoHeader.Reset();
                    SalesCrMemoHeader.SetRange("No.", Rec."No.");
                    SalesCrMemoRef.GetTable(SalesCrMemoHeader);
                    PdfTempBlob.CreateOutStream(PdfOutStream);
                    Report.SaveAs(ReportId, '', ReportFormat::Pdf, PdfOutStream, SalesCrMemoRef);

                    if not PdfTempBlob.HasValue() then
                        Error('Failed to generate PDF for posted sales credit memo %1.', Rec."No.");

                    FileName := CopyStr(StrSubstNo('%1_%2.pdf', Rec."Bill-to Name", Rec."No."), 1, MaxStrLen(FileName));
                    PdfTempBlob.CreateInStream(PdfInstream);
                    DownloadFromStream(PdfInstream, '', '', '', FileName);
                end;
            }
        }
    }
}

namespace RoldoRent.RoldoRent;

using Microsoft.Foundation.Reporting;
using Microsoft.Purchases.History;
using System.Utilities;

pageextension 60022 "I2I Posted Purchase Invoices" extends "Posted Purchase Invoices"
{
    actions
    {
        addlast(Reporting)
        {
            action(DownloadPurchInv)
            {
                Caption = 'Download Purchase Invoice';
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
                    PurchInvHeader: Record "Purch. Inv. Header";
                    PurchInvRef: RecordRef;
                    PdfOutStream: OutStream;
                    PdfInstream: InStream;
                    PdfTempBlob: Codeunit "Temp Blob";
                    FileName: Text[100];
                begin
                    if Rec."No." = '' then
                        Error('Select a posted purchase invoice to download.');

                    ReportSelection.SetRange(Usage, ReportSelection.Usage::"P.Invoice");
                    if ReportSelection.FindFirst() then
                        ReportId := ReportSelection."Report ID";

                    if ReportId = 0 then
                        Error('No report is configured for usage %1 in Report Selections.', ReportSelection.Usage::"P.Invoice");

                    PurchInvHeader.Reset();
                    PurchInvHeader.SetRange("No.", Rec."No.");
                    PurchInvRef.GetTable(PurchInvHeader);
                    PdfTempBlob.CreateOutStream(PdfOutStream);
                    Report.SaveAs(ReportId, '', ReportFormat::Pdf, PdfOutStream, PurchInvRef);

                    if not PdfTempBlob.HasValue() then
                        Error('Failed to generate PDF for posted purchase invoice %1.', Rec."No.");

                    FileName := CopyStr(StrSubstNo('%1_%2.pdf', Rec."Buy-from Vendor Name", Rec."No."), 1, MaxStrLen(FileName));
                    PdfTempBlob.CreateInStream(PdfInstream);
                    DownloadFromStream(PdfInstream, '', '', '', FileName);
                end;
            }
        }
    }
}

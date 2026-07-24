namespace RoldoRent.RoldoRent;
using Microsoft.Foundation.Reporting;
using System.Utilities;
using Microsoft.Sales.History;

pageextension 60025 "I2I Posted Rental Invoices" extends "EQM Posted Rental Invoices"
{
    actions
    {
        addlast(Reporting)
        {
            action(DownloadSalesInv)
            {
                Caption = 'Download Rental Invoice';
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
                    SalesInvHeader: Record "Sales Invoice Header";
                    SalesInvRef: RecordRef;
                    PdfOutStream: OutStream;
                    PdfInstream: InStream;
                    PdfTempBlob: Codeunit "Temp Blob";
                    FileName: Text[100];
                begin
                    if Rec."No." = '' then
                        Error('Select a posted sales invoice to download.');

                    ReportSelection.SetRange(Usage, ReportSelection.Usage::"EQM Rental Invoice");
                    if ReportSelection.FindFirst() then
                        ReportId := ReportSelection."Report ID";

                    if ReportId = 0 then
                        Error('No report is configured for usage %1 in Report Selections.', ReportSelection.Usage::"EQM Rental Invoice");

                    SalesInvHeader.Reset();
                    SalesInvHeader.SetRange("No.", Rec."No.");
                    SalesInvRef.GetTable(SalesInvHeader);
                    PdfTempBlob.CreateOutStream(PdfOutStream);
                    Report.SaveAs(ReportId, '', ReportFormat::Pdf, PdfOutStream, SalesInvRef);

                    if not PdfTempBlob.HasValue() then
                        Error('Failed to generate PDF for posted sales invoice %1.', Rec."No.");

                    FileName := CopyStr(StrSubstNo('%1_%2.pdf', Rec."Bill-to Name", Rec."No."), 1, MaxStrLen(FileName));
                    PdfTempBlob.CreateInStream(PdfInstream);
                    DownloadFromStream(PdfInstream, '', '', '', FileName);
                end;
            }
            action(CombineInvoice)
            {
                Caption = 'Combine Invoice';
                Image = Report;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Report.Run(Report::"I2I Combine Invoice", true);
                end;
            }
        }
    }
}

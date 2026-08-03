pageextension 60002 "I2I Rental Collection Order" extends "EQM Rental Collection Order"
{
    layout
    {
        modify(ReceivingLocationCode)
        {
            ShowMandatory = true;
        }
        addafter(SwitchLinkNo)
        {
            field("External Document No."; Rec."I2I External Document No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the External Document No. field.', Comment = '%';
                ShowMandatory = true;
                trigger OnValidate()
                var
                    DispatchLines: Record "EQM Rental Dispatch Line";
                begin
                    if Rec."I2I External Document No." = '' then
                        exit;

                    DispatchLines.SetRange("Document No.", Rec."No.");
                    if not DispatchLines.FindFirst() then
                        exit;

                    Rec.Validate("I2I External Document No.");
                    if Confirm('You have updated the External Document No. on the header. Do you want to update it for the lines as well?', true) then begin
                        UpdateLines();
                        CurrPage.Update();
                    end;
                end;
            }
            field("Handling Fee"; Rec."I2I Handling Fee")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Handling Fee(Applicable). field.', Comment = '%';
            }
            field("Contact No."; Rec."I2I Contact No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Contact No. field.', Comment = '%';
                Lookup = true;
                LookupPageId = "Contact List";
            }
            field("Contact Name"; Rec."I2I Contact Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Contact Name field.', Comment = '%';
            }
            field("Contact E-Mail"; Rec."I2I Contact E-Mail")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Contact E-Mail field.', Comment = '%';
            }
            field("Collection Date"; Rec."I2I Collection Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Collection Date field.', Comment = '%';
            }
        }
        addafter("Package Tracking No.")
        {
            field("I2I Transportation Charges"; Rec."I2I Transportation Charges")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Transportation Charges field.', Comment = '%';
            }
            field("I2I Transportation Cost"; Rec."I2I Transportation Cost")
            {
                Editable = Rec."I2I Transportation Charges";
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Transportation Cost field.', Comment = '%';
            }
        }
        addlast(Content)
        {
            group(MemoTextGrp)
            {
                Caption = 'Inbound Memo';
                field("Inbound Memo Text"; InboundMemoTxtVar)
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Inbound Memo Text field.';
                    trigger OnValidate()
                    begin
                        Rec.SetMemoText(2, InboundMemoTxtVar);
                    end;
                }
            }
        }
    }
    actions
    {
        addlast(Reporting)
        {
            action("Order Confirmation Return")
            {
                Caption = 'Order Confirmation for Return Transport';
                Image = Print;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                var
                    RentalDispHeader: Record "EQM Rental Dispatch Header";
                    OrderConfirmationReturn: Report "I2I Order Conf. for Ret. Tran.";
                begin
                    RentalDispHeader.SetRange("No.", Rec."No.");
                    OrderConfirmationReturn.SetTableView(RentalDispHeader);
                    OrderConfirmationReturn.Run();
                end;
            }
            action("Transport Order Return")
            {
                Caption = 'Transport Order Return';
                Image = Print;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                var
                    RentalDispHeader: Record "EQM Rental Dispatch Header";
                    TransportOrdReturn: Report "Transport Order Return";
                begin
                    RentalDispHeader.SetRange("No.", Rec."No.");
                    TransportOrdReturn.SetTableView(RentalDispHeader);
                    TransportOrdReturn.Run();
                end;
            }
            action("Return Slip for Depot")
            {
                Caption = 'Return Slip for Depot';
                Image = Print;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                var
                    RentalDispHeader: Record "EQM Rental Dispatch Header";
                    ReturnSlip: Report "Return Slip for Depot";
                begin
                    RentalDispHeader.SetRange("No.", Rec."No.");
                    ReturnSlip.SetTableView(RentalDispHeader);
                    ReturnSlip.Run();
                end;
            }
            action("Send by Email")
            {
                Caption = 'Send by Email';
                Image = Email;
                ApplicationArea = All;
                ToolTip = 'Select one or more configured reports and send them as PDF attachments by email.';
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                var
                    RentalDocEmailMgt: Codeunit "I2I Rental Doc. Email Mgt";
                begin
                    CurrPage.SaveRecord();
                    RentalDocEmailMgt.SendRentalCollectionOrderByEmail(Rec);
                end;
            }
            action(DownloadReport)
            {
                Caption = 'Download Reports';
                Image = ExportFile;
                ApplicationArea = All;
                ToolTip = 'Download the rental collection reports as PDF files.';
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                var
                    RentalDocEmailMgt: Codeunit "I2I Rental Doc. Email Mgt";
                begin
                    CurrPage.SaveRecord();
                    RentalDocEmailMgt.DownloadRentalCollectionReports(Rec);
                end;
            }
        }
    }
    var
        InboundMemoTxtVar: Text;

    trigger OnAfterGetRecord()
    begin
        InboundMemoTxtVar := Rec.GetInBoundMemoText();
    end;

    procedure UpdateLines()
    var
        CheckLine: Record "EQM Rental Dispatch Line";
    begin
        CheckLine.SetRange("Document Type", Rec."Document Type");
        CheckLine.SetRange("Document No.", Rec."No.");

        CheckLine.ModifyAll("I2I External Document No.", Rec."I2I External Document No.");
    end;
}

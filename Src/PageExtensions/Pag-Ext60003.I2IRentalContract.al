pageextension 60003 "I2I Rental Contract" extends "EQM Rental Contract"
{
    layout
    {
        modify("External Document No.")
        {
            trigger OnAfterValidate()
            var
                RentalLine: Record "EQM Rental Line";
            begin
                if Rec."External Document No." = '' then
                    exit;

                if not Confirm('Do you want to update Rental Lines with the same External Document No.?', true) then
                    exit;

                RentalLine.SetRange("Contract Type", Rec."Contract Type");
                RentalLine.SetRange("Contract No.", Rec."Contract No.");
                RentalLine.SetRange(Type, RentalLine.Type::Item);
                if RentalLine.FindSet() then
                    repeat
                        RentalLine."I2I External Document No." := Rec."External Document No.";
                        RentalLine.Modify(true);
                    until RentalLine.Next() = 0;
            end;
        }
        modify(LocationCode)
        {
            ShowMandatory = true;
        }
        addafter(PackageTrackingNo)
        {

            field("Transport Charges"; Rec."I2I Transport Charges")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Transport Charges field.', Comment = '%';
            }
        }
        addafter(ShipmentDate)
        {
            field("I2I Delivery Date"; Rec."I2I Delivery Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Delivery Date field.', Comment = '%';
            }
        }
    }

    actions
    {
        addlast(Reporting)
        {
            action("Order with Transport")
            {
                Caption = 'Order with Transport';
                Image = Print;
                ApplicationArea = All;
                ToolTip = 'Print or preview external document details linked to this contract.';
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                var
                    RentalHeader: Record "EQM Rental Header";
                    OrderwithTran: Report "Order Confirmation";
                begin
                    RentalHeader.SetRange("Contract Type", Rec."Contract Type");
                    RentalHeader.SetRange("Contract No.", Rec."Contract No.");
                    OrderwithTran.SetTableView(RentalHeader);
                    OrderwithTran.Run();
                end;
            }
            action("Order without Transport")
            {
                Caption = 'Order without Transport';
                Image = Calendar;
                ApplicationArea = All;
                ToolTip = 'View or print collection schedule based on rental contract dates.';
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                var
                    RentalHeader: Record "EQM Rental Header";
                    OrderwithoutTran: Report "Order Conf. W/O Transport";
                begin
                    RentalHeader.SetRange("Contract Type", Rec."Contract Type");
                    RentalHeader.SetRange("Contract No.", Rec."Contract No.");
                    OrderwithoutTran.SetTableView(RentalHeader);
                    OrderwithoutTran.Run();
                end;
            }
            action("Transport Order Rental")
            {
                Caption = 'Transport Order Rental';
                Image = Print;
                ApplicationArea = All;
                // ToolTip = 'View or print collection schedule based on rental contract dates.';
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                var
                    RentalHeader: Record "EQM Rental Header";
                    TransportOrdRental: Report "Transport Order Rental";
                begin
                    RentalHeader.SetRange("Contract Type", Rec."Contract Type");
                    RentalHeader.SetRange("Contract No.", Rec."Contract No.");
                    TransportOrdRental.SetTableView(RentalHeader);
                    TransportOrdRental.Run();
                end;
            }
            action("Depot Document")
            {
                Caption = 'Depot Document';
                Image = Print;
                ApplicationArea = All;
                // ToolTip = 'View or print collection schedule based on rental contract dates.';
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                var
                    RentalHeader: Record "EQM Rental Header";
                    RentalOrdDepot: Report "Rental Order For depot";
                begin
                    RentalHeader.SetRange("Contract Type", Rec."Contract Type");
                    RentalHeader.SetRange("Contract No.", Rec."Contract No.");
                    RentalOrdDepot.SetTableView(RentalHeader);
                    RentalOrdDepot.Run();
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
                    RentalDocEmailMgt.SendRentalContractByEmail(Rec);
                end;
            }
            action(DownloadReport)
            {
                Caption = 'Download Reports';
                Image = ExportFile;
                ApplicationArea = All;
                ToolTip = 'Download the rental contract reports as PDF files.';
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                var
                    RentalDocEmailMgt: Codeunit "I2I Rental Doc. Email Mgt";
                begin
                    CurrPage.SaveRecord();
                    RentalDocEmailMgt.DownloadRentalContractReports(Rec);
                end;
            }
        }
    }
}

page 60003 "Temp Rental Return Entries"
{
    ApplicationArea = All;
    Caption = 'Temporary Rental Return Entries';
    PageType = List;
    SourceTable = "EQM Rental Return Entry";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field';
                }
                field("Return No."; Rec."Return No.")
                {
                    ToolTip = 'Specifies the value of the Return No. field';
                }
                field("Contract No."; Rec."Contract No.")
                {
                    ToolTip = 'Specifies the value of the Contract no field';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the value of the Customer No. field';
                }
                field("Customer Project"; Rec."Customer Project")
                {
                    ToolTip = 'Specifies the value of the Customer Project field';
                }
                field("Ext. Rental Line No."; Rec."Ext. Rental Line No.")
                {
                    ToolTip = 'Specifies the value of the Ext. Line No. field';
                }
                field("Customer Sub Project"; Rec."Customer Sub Project")
                {
                    ToolTip = 'Specifies the value of the Customer Sub Project field';
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ToolTip = 'Specifies the value of the Entry Type field';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the value of the Document Type field.', Comment = '%';
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Specifies the value of the Document Date field';
                }
                field("Posted in Document"; Rec."Posted in Document")
                {
                    ToolTip = 'Specifies the value of the Posted in Document field';
                }
                field("Posting Time"; Rec."Posting Time")
                {
                    ToolTip = 'Specifies the value of the Posting Time field';
                }
                field("Transferred to Order"; Rec."Transferred to Order")
                {
                    ToolTip = 'Specifies the value of the Transferred to Order field';
                }
                field("Accessory Posted in Document"; Rec."Accessory Posted in Document")
                {
                    ToolTip = 'Specifies the value of the Accessory Posted in Document field.', Comment = '%';
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field';
                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field';
                }
                field("Start Rental Period"; Rec."Start Rental Period")
                {
                    ToolTip = 'Specifies the value of the Start Rental Period field';
                }
                field("On-Rent Date"; Rec."On-Rent Date")
                {
                    ToolTip = 'Specifies the value of the On-Rent Date field';
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    ToolTip = 'Specifies the value of the Shipment Date field';
                }
                field("Invoiced To Date"; Rec."Invoiced To Date")
                {
                    ToolTip = 'Specifies the value of the Invoiced to Date field';
                }
                field("Off-Rent Date"; Rec."Off-Rent Date")
                {
                    ToolTip = 'Specifies the value of the Off-Rent Date field';
                }
                field("Off-Rent Time"; Rec."Off-Rent Time")
                {
                    ToolTip = 'Specifies the value of the Off-Rent Time field';
                }
                field("Return Date"; Rec."Return Date")
                {
                    ToolTip = 'Specifies the value of the Return Date field';
                }
                field("Return Time"; Rec."Return Time")
                {
                    ToolTip = 'Specifies the value of the Return Time field';
                }
                field("Debit on Return Date"; Rec."Debit on Return Date")
                {
                    ToolTip = 'Specifies the value of the Debit on Return Date field.', Comment = '%';
                }
                field("Re-Rent Object"; Rec."Re-Rent Object")
                {
                    ToolTip = 'Specifies the value of the Re-Rent Object field';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field';
                }
                field("Remaining Quantity"; Rec."Remaining Quantity")
                {
                    ToolTip = 'Specifies the value of the Remaining Quantity field';
                }
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the value of the User ID field';
                }
                field("Source Code"; Rec."Source Code")
                {
                    ToolTip = 'Specifies the value of the Source Code field';
                }
                field("Transaction No."; Rec."Transaction No.")
                {
                    ToolTip = 'Specifies the value of the Transaction No. field';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ToolTip = 'Specifies the value of the Location Code field';
                }
            }
        }
    }
}

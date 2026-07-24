pageextension 60015 "I2I Posted Collect Order Lines" extends "EQM Posted Collect Order Lines"
{
    layout
    {
        addbefore(No)
        {
            field("External Document No."; Rec."I2I External Document No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the External Document No. field.', Comment = '%';
            }
        }
        addafter(DocumentNo)
        {
            field("Shipment Date"; Rec."Shipment Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shipment Date field.', Comment = '%';
            }
            field("Return Date"; Rec."Return Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Return Date field', Comment = '%';
            }
        }
        addafter(LocationCode)
        {
            field("Receiving Location Code"; Rec."Receiving Location Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Receiving Location Code field';
            }
        }
    }
}
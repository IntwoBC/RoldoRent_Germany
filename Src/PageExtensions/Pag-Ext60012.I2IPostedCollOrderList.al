pageextension 60012 "I2I Posted Coll. Order List" extends "EQM Posted Coll. Order List"
{

    layout
    {
        addafter(PostingDate)
        {
            field("I2I External Document No."; Rec."I2I External Document No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the External Document No. field.', Comment = '%';
            }
        }
        addafter(CustomerProject)
        {
            field("Receiving Location Code"; Rec."Receiving Location Code")
            {
                ApplicationArea = All;
                Caption = 'Receiving Location Code';
                ToolTip = 'Specifies the value of the Receiving Location Code field.', Comment = '%';
            }
        }
    }
}

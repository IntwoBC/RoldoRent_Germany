pageextension 60011 "I2I Dispatch Coll. Order List" extends "EQM Dispatch Coll. Order List"
{
    layout
    {
        addafter(PostingDate)
        {
            field("External Document No."; Rec."I2I External Document No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the External Document No. field.', Comment = '%';
            }
        }
    }
}

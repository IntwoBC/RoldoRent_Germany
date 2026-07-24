pageextension 60014 "I2I Posted Coll. Order Subform" extends "EQM Posted Coll. Order Subform"
{
    layout
    {
        addafter(ObjectNo)
        {
            field("External Document No."; Rec."I2I External Document No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the External Document No. field.', Comment = '%';
            }
        }
    }
}

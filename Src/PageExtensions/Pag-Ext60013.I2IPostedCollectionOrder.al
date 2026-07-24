pageextension 60013 "I2I Posted Collection Order" extends "EQM Posted Collection Order"
{
    layout
    {
        addafter(SwitchLinkNo)
        {
            field("I2I External Document No."; Rec."I2I External Document No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the External Document No. field.', Comment = '%';
            }
        }
    }
}

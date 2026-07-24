pageextension 60004 "I2I EQM Rental Inv. Sub." extends "EQM Rental Invoice Subform"
{
    layout
    {
        addafter(EQMObjectNo)
        {
            field("External Document No."; Rec."I2I External Document No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the External Document No. field.', Comment = '%';
                ShowMandatory = true;
            }
        }
    }
}

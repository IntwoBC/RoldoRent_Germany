pageextension 60005 "I2I Posted Rntl. Inv. Sub." extends "EQM Posted Rental Inv Subform"
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

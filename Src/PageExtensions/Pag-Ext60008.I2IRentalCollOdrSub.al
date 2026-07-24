pageextension 60008 "I2I Rental Coll. Odr Sub." extends "EQM Rental Coll. Order Subform"
{
    layout
    {
        addafter(ObjectNo)
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

pageextension 60000 "I2I Rental Contract Subform" extends "EQM Rental Contract Subform"
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
        addafter(LineAmountPeriod)
        {
            field("Net Weight"; Rec."Net Weight")
            {
                ApplicationArea = All;

                Visible = true;
            }
        }
        addafter(LocationCode)
        {
            field("Customer Project"; Rec."Customer Project")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Customer Project field.';
            }
        }
        modify(LocationCode)
        {
            ShowMandatory = true;
        }
    }
}
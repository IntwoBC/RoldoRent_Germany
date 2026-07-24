pageextension 60016 "I2I Customer Card" extends "Customer Card"
{
    layout
    {
        addafter("E-Mail")
        {
            field("Invoice Email"; Rec."I2I Invoice Email")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Invoice Email field.', Comment = '%';
            }
            field("Reminder Email"; Rec."I2I Reminder Email")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Remainder Email field.', Comment = '%';
            }
        }
    }
}

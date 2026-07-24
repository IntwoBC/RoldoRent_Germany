pageextension 60001 "I2I General Ledger Setup" extends "General Ledger Setup"
{
    layout
    {
        addlast(content)
        {
            group("Rental Contracts")
            {
                field("Rental Revenue G/L Account"; Rec."I2I Rental Revenue G/L Account")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the G/L Account for Rentrals field.', Comment = '%';
                }
                field("I2I Rental Quantity Threshold"; Rec."I2I Rental Quantity Threshold")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Rental Quantity Threshold field.', Comment = '%';
                }
                field("Rental Price Below Threshold"; Rec."I2I Rental Price Bel. Thres.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the rental price below the defined threshold.', Comment = '%';
                }
                field("Rental Price Above Threshold"; Rec."I2I Rental Price Abv. Thres.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the rental price above the defined threshold.', Comment = '%';
                }
                field("I2I Transp. Rev. G/L Acc"; Rec."I2I Transp. Rev. G/L Acc")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transport Revenue G/L Account field.', Comment = '%';
                }
                field("I2I Rental Col. Rev. G/L Acc"; Rec."I2I Rental Col. Rev. G/L Acc")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Rental Col. Revenue G/L Account field.', Comment = '%';
                }
            }
        }
    }
}

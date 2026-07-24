tableextension 60012 "I2I Rental Return Entry" extends "EQM Rental Return Entry"
{
    fields
    {
        field(60000; "I2I External Document No."; Code[35])
        {
            Caption = 'External Document No.';
            DataClassification = ToBeClassified;
        }
    }
}

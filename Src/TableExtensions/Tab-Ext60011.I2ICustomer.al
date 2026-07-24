tableextension 60011 "I2I Customer" extends Customer
{
    fields
    {
        field(60000; "I2I Invoice Email"; Text[100])
        {
            Caption = 'Invoice Email';
            DataClassification = ToBeClassified;
        }
        field(60001; "I2I Reminder Email"; Text[100])
        {
            Caption = 'Reminder Email';
            DataClassification = ToBeClassified;
        }
    }
}

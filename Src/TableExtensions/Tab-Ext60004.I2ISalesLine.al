tableextension 60004 "I2I Sales Line" extends "Sales Line"
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

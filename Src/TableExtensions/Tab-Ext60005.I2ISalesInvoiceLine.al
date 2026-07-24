tableextension 60005 "I2I Sales Invoice Line" extends "Sales Invoice Line"
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

tableextension 60008 "I2I Rental Posted Coll. Header" extends "EQM Rental Posted Coll. Header"
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
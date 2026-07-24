tableextension 60010 "I2I Purchase Header" extends "Purchase Header"
{
    fields
    {
        field(60000; "I2I Inbound Memo Text"; Blob)
        {
            Caption = 'Inbound Memo Text';
            DataClassification = ToBeClassified;
        }
    }
}

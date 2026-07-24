table 60101 "I2I Rental Email Report Buffer"
{
    Caption = 'Rental Email Report Buffer';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(2; "Document Type"; Enum "I2I Rental Email Doc. Type")
        {
            Caption = 'Document Type';
            DataClassification = CustomerContent;
        }
        field(3; "Report ID"; Integer)
        {
            Caption = 'Report ID';
            DataClassification = CustomerContent;
        }
        field(4; "Report Name"; Text[100])
        {
            Caption = 'Report Name';
            DataClassification = CustomerContent;
        }
        field(5; Selected; Boolean)
        {
            Caption = 'Selected';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}

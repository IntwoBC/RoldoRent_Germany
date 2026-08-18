table 60001 "I2I Rental Movement Line"
{
    Caption = 'Rental Movement Line';
    TableType = Temporary;
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(10; BonnrHuur; Code[35])
        {
            Caption = 'Bonnr. Huur';
        }
        field(11; BonnrRetour; Code[35])
        {
            Caption = 'Bonnr. Retour';
        }
        field(12; DatumHuur; Text[20])
        {
            Caption = 'Datum Huur';
        }
        field(13; DatumRetour; Text[20])
        {
            Caption = 'Datum Retour';
        }
        field(20; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(30; Mutatie; Decimal)
        {
            Caption = 'Mutatie';
        }
        field(31; AantalInHuur; Decimal)
        {
            Caption = 'Aantal in huur';
        }
        field(32; HuurDagen; Decimal)
        {
            Caption = 'Huur-dagen';
        }
        field(33; PrijsPerDag; Decimal)
        {
            Caption = 'Prijs/dag';
        }
        field(34; Bedrag; Decimal)
        {
            Caption = 'Bedrag';
        }
        field(40; IsReturnLine; Boolean)
        {
            Caption = 'Is Return Line';
        }
        field(50; RentalNo; Code[20])
        {
            Caption = 'Rental No.';
        }
        field(51; SortOrder; Integer)
        {
            Caption = 'Sort Order';
        }
        field(52; SortDate; Date)
        {
            Caption = 'Sort Date';
        }
        field(53; ExtLineNo; Integer)
        {
            Caption = 'Ext. Line No.';
        }
        field(54; KortingPct; Decimal)
        {
            Caption = 'Korting %';
        }
    }

    keys
    {
        key(PK; RentalNo, SortOrder, SortDate, ExtLineNo, "Line No.")
        {
            Clustered = true;
        }
    }
}

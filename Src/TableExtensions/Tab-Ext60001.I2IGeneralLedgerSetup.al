tableextension 60001 "I2I General Ledger Setup" extends "General Ledger Setup"
{
    fields
    {
        field(60000; "I2I Rental Revenue G/L Account"; Code[20])
        {
            Caption = 'Rental Revenue G/L Account';
            TableRelation = "G/L Account"."No.";
        }
        field(60001; "I2I Rental Quantity Threshold"; Decimal)
        {
            Caption = 'Rental Quantity Threshold';
            DataClassification = ToBeClassified;
        }
        field(60002; "I2I Rental Price Bel. Thres."; Decimal)
        {
            Caption = 'Rental Price Below Threshold';
            DataClassification = ToBeClassified;
        }
        field(60003; "I2I Rental Price Abv. Thres."; Decimal)
        {
            Caption = 'Rental Price Above Threshold';
            DataClassification = ToBeClassified;
        }
        field(60004; "I2I Transp. Rev. G/L Acc"; Code[20])
        {
            Caption = 'Transport Revenue G/L Account';
            TableRelation = "G/L Account"."No.";
        }
        field(60005; "I2I Rental Col. Rev. G/L Acc"; Code[20])
        {
            Caption = 'Rental Col. Revenue G/L Account';
            TableRelation = "G/L Account"."No.";
        }
    }
}

namespace RoldoRentGermany.RoldoRentGermany;

using Microsoft.Foundation.Company;

tableextension 60014 "I2I Company Information" extends "Company Information"
{
    fields
    {
        field(60000; "I2I Phone No. AT"; Text[100])
        {
            Caption = 'Phone No. AT';
            DataClassification = ToBeClassified;
        }
        field(60001; "I2I Email AT"; Text[100])
        {
            Caption = 'Email AT';
            DataClassification = ToBeClassified;
        }
        field(60002; "I2I Home Page AT"; Text[100])
        {
            Caption = 'Home Page AT';
            DataClassification = ToBeClassified;
        }
        field(60003; "I2I Phone No. CH"; Text[100])
        {
            Caption = 'Phone No. Swiss';
            DataClassification = ToBeClassified;
        }
        field(60004; "I2I Email CH"; Text[100])
        {
            Caption = 'Email Swiss';
            DataClassification = ToBeClassified;
        }
        field(60005; "I2I Home Page CH"; Text[100])
        {
            Caption = 'Home Page Swiss';
            DataClassification = ToBeClassified;
        }
    }
}

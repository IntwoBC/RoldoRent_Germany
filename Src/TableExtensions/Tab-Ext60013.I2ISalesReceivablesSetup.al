namespace RoldoRent.RoldoRent;

using Microsoft.Sales.Setup;

tableextension 60013 "I2I Sales & Receivables Setup" extends "Sales & Receivables Setup"
{
    fields
    {
        field(60000; "I2I Email Body"; Text[2048])
        {
            Caption = 'Email Body';
            DataClassification = ToBeClassified;
        }
        field(60001; "I2I Rental Email Body"; Text[2048])
        {
            Caption = 'Rental Documents Email Body';
            DataClassification = ToBeClassified;
        }
        field(60002; "I2I Rental Depot Email body"; Text[2048])
        {
            Caption = 'Rental Depot Documents Email Body';
            DataClassification = ToBeClassified;
        }
        field(60003; "I2I Rental Email Sig. Tmpl"; Text[2048])
        {
            Caption = 'Rental Email Signature Template';
            DataClassification = ToBeClassified;
        }
        field(60004; "I2I Reminder Email Body"; Text[2048])
        {
            Caption = 'Reminder Email Body';
            DataClassification = ToBeClassified;
        }
    }
}

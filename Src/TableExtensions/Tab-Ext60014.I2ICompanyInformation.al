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
        field(60003; "I2I Bank Acc. No. AT"; Text[30])
        {
            Caption = 'Bank Account No. AT';
            DataClassification = ToBeClassified;
        }
        field(60004; "I2I IBAN AT"; Code[50])
        {
            Caption = 'IBAN AT';
            DataClassification = ToBeClassified;
        }
        field(60005; "I2I Swift AT"; Code[20])
        {
            Caption = 'Swift AT';
            DataClassification = ToBeClassified;
        }
        field(60006; "I2I Bank Name AT"; Text[100])
        {
            Caption = 'Bank Name AT';
            DataClassification = ToBeClassified;
        }
        field(60007; "I2I Contact Person AT"; Text[100])
        {
            Caption = 'Contact Person AT';
            DataClassification = ToBeClassified;
        }
        field(60008; "I2I Company Reg No. AT"; Text[20])
        {
            Caption = 'Company Registration No. AT';
            DataClassification = ToBeClassified;
        }
        field(60009; "I2I Phone No. CH"; Text[100])
        {
            Caption = 'Phone No. CH';
            DataClassification = ToBeClassified;
        }
        field(60010; "I2I Email CH"; Text[100])
        {
            Caption = 'Email CH';
            DataClassification = ToBeClassified;
        }
        field(60011; "I2I Home Page CH"; Text[100])
        {
            Caption = 'Home Page Swiss';
            DataClassification = ToBeClassified;
        }
        field(60012; "I2I Bank Acc. No. CH"; Text[30])
        {
            Caption = 'Bank Account No. Swiss';
            DataClassification = ToBeClassified;
        }
        field(60013; "I2I IBAN CH"; Code[50])
        {
            Caption = 'IBAN Swiss';
            DataClassification = ToBeClassified;
        }
        field(60014; "I2I Swift CH"; Code[20])
        {
            Caption = 'Swift Swiss';
            DataClassification = ToBeClassified;
        }
        field(60015; "I2I Bank Name CH"; Text[100])
        {
            Caption = 'Bank Name Swiss';
            DataClassification = ToBeClassified;
        }
        field(60016; "I2I Contact Person CH"; Text[100])
        {
            Caption = 'Contact Person Swiss';
            DataClassification = ToBeClassified;
        }
        field(60017; "I2I Company Reg No. CH"; Text[20])
        {
            Caption = 'Company Registration No. Swiss';
            DataClassification = ToBeClassified;
        }
        field(60018; "I2I DOC. Text"; Text[50])
        {
            Caption = 'DOC. Text';
            DataClassification = ToBeClassified;
        }
    }
}

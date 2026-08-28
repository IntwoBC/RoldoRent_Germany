namespace RoldoRentGermany.RoldoRentGermany;

using Microsoft.Foundation.Company;

pageextension 60027 "I2I Company Information" extends "Company Information"
{
    layout
    {
        addlast(content)
        {
            group(DocText)
            {
                Caption = 'DOC. Text';
                field("DOC. Text"; Rec."I2I DOC. Text")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the DOC. Text field.', Comment = '%';
                }
            }
            group(ContactDetailsAT)
            {
                Caption = 'Contact Detials Austria';

                field("Phone No. AT"; Rec."I2I Phone No. AT")
                {
                    Caption = 'Phone No. Austria';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the I2I Phone No. AT field.', Comment = '%';
                }
                field("Email AT"; Rec."I2I Email AT")
                {
                    Caption = 'Email Austria';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the I2I Email AT field.', Comment = '%';
                }
                field("Home Page AT"; Rec."I2I Home Page AT")
                {
                    Caption = 'Home Page Austria';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the I2I Home Page AT field.', Comment = '%';
                }
                field("Bank Acc. No. AT"; Rec."I2I Bank Acc. No. AT")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Account No. AT field.', Comment = '%';
                }
                field("Bank Name AT"; Rec."I2I Bank Name AT")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Name AT field.', Comment = '%';
                }
                field("IBAN AT"; Rec."I2I IBAN AT")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the IBAN AT field.', Comment = '%';
                }
                field("Swift AT"; Rec."I2I Swift AT")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Swift AT field.', Comment = '%';
                }
                field("Company Reg No. AT"; Rec."I2I Company Reg No. AT")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Company Registration No. AT field.', Comment = '%';
                }
                field("Contact Person AT"; Rec."I2I Contact Person AT")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Contact Person AT field.', Comment = '%';
                }
            }

            group(ContactDetailsCH)
            {
                Caption = 'Contact Details Swiss';

                field("Phone No. CH"; Rec."I2I Phone No. CH")
                {
                    Caption = 'Phone No. Swiss';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the I2I Phone No. CH field.', Comment = '%';
                }
                field("Email CH"; Rec."I2I Email CH")
                {
                    Caption = 'Email Swiss';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the I2I Email CH field.', Comment = '%';
                }
                field("Home Page CH"; Rec."I2I Home Page CH")
                {
                    Caption = 'Home Page Swiss';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the I2I Home Page CH field.', Comment = '%';
                }
                field("Bank Acc. No. CH"; Rec."I2I Bank Acc. No. CH")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Account No. Swiss field.', Comment = '%';
                }
                field("Bank Name CH"; Rec."I2I Bank Name CH")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Name Swiss field.', Comment = '%';
                }
                field("IBAN CH"; Rec."I2I IBAN CH")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the IBAN Swiss field.', Comment = '%';
                }
                field("Swift CH"; Rec."I2I Swift CH")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Swift Swiss field.', Comment = '%';
                }
                field("Company Reg No. CH"; Rec."I2I Company Reg No. CH")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Company Registration No. Swiss field.', Comment = '%';
                }
                field("Contact Person CH"; Rec."I2I Contact Person CH")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Contact Person Swiss field.', Comment = '%';
                }
            }
        }
    }
}

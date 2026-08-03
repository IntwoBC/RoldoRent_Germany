namespace RoldoRentGermany.RoldoRentGermany;

using Microsoft.Foundation.Company;

pageextension 60027 "I2I Company Information" extends "Company Information"
{
    layout
    {
        addlast(content)
        {
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
            }
        }
    }
}

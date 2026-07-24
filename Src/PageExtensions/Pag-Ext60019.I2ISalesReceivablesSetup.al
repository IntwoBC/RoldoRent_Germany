namespace RoldoRent.RoldoRent;

using Microsoft.Sales.Setup;

pageextension 60019 "I2I Sales & Receivables Setup" extends "Sales & Receivables Setup"
{
    layout
    {
        addlast(content)
        {
            group("Ema&il Body")
            {
                Caption = 'Email Body';
                field("I2I Rental Email Body"; Rec."I2I Rental Email Body")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Rental Documents Email Body field.', Comment = '%';
                }
                field("I2I Rental Depot Email body"; Rec."I2I Rental Depot Email body")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Rental Depot Documents Email Body field.', Comment = '%';
                }
                field("I2I Rental Email Signature Template"; Rec."I2I Rental Email Sig. Tmpl")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    ToolTip = 'Specifies the Rental Email Signature Template for Rental Contract and Rental Collection Order emails. Supported placeholders: %1=Sender Name, %2=Company Name, %3=Email Address, %4=Company Address, %5=Phone Number, %6=Website, %7=Additional Text/Working Days, %8=Footer Text. Sample template: %1 %2 📧 %3 📍 %4 📞 %5 🌐 %6 %7 %8', Comment = '%';
                }
                field("Email Body"; Rec."I2I Email Body")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Email Body field.', Comment = '%';
                }
                field("Reminder Email Body"; Rec."I2I Reminder Email Body")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Reminder Email Body field.', Comment = '%';
                }
            }
        }
    }
}

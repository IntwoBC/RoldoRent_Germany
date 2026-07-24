namespace RoldoRent.RoldoRent;

using Microsoft.Sales.Customer;

pageextension 60020 "I2I Customer List" extends "Customer List"
{
    layout
    {
        addafter(Contact)
        {
            field(PostCode; Rec."Post Code")
            {
                Caption = 'Post Code';
                ApplicationArea = All;
            }
            field(City; Rec.City)
            {
                ApplicationArea = All;
                Caption = 'City';
                ToolTip = 'Specifies the value of the City field.', Comment = '%';
            }
            field("Payment Method Code"; Rec."Payment Method Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Payment Method Code field.', Comment = '%';
            }
        }
    }
}

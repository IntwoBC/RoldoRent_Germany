namespace RoldoRentGermany.RoldoRentGermany;

pageextension 60028 "I2I Rental Contract List" extends "EQM Rental Contract List"
{
    layout
    {
        addafter(CustomerProject)
        {
            field(AllLinesShipped; I2IAllLinesShipped)
            {
                ApplicationArea = All;
                Caption = 'All Shipped';
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        RentalLines: Record "EQM Rental Line";
    begin
        I2IAllLinesShipped := true;

        RentalLines.SetRange("Contract Type", Rec."Contract Type");
        RentalLines.SetRange("Contract No.", Rec."Contract No.");
        RentalLines.SetRange(Type, RentalLines.Type::Item);
        RentalLines.SetFilter("Entry Status", '%1|%2', RentalLines."Entry Status"::" ", RentalLines."Entry Status"::Reserved);

        if not RentalLines.IsEmpty() then
            I2IAllLinesShipped := false;
    end;

    var
        I2IAllLinesShipped: Boolean;
}
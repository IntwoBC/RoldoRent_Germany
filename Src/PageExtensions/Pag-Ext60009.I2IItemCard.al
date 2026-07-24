pageextension 60009 "I2I Item Card" extends "Item Card"
{
    actions
    {
        addafter(ItemsByLocation)
        {
            action("Items By Location 2")
            {
                Caption = 'Items By Available';
                Image = ItemAvailbyLoc;
                ApplicationArea = All;
                trigger OnAction()
                var
                    ItemMatrix: Page "Items Availability by Location";
                begin
                    PAGE.Run(PAGE::"Items Availability by Location", Rec);
                end;
            }
        }
    }
}

pageextension 60006 "I2I Posted Sales Inv. - Upd." extends "Posted Sales Inv. - Update"
{
    layout
    {
        addafter("Shipping Agent Service Code")
        {
            field("EQMCombine Customer Proj"; Rec."EQMCombine Customer Proj")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the EQMCombine Customer Proj field';
                Editable = true;
            }
        }
    }
}

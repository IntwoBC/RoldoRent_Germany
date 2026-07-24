namespace RoldoRent.RoldoRent;

reportextension 60000 "I2I Create Rental Invoice Ext" extends "EQM Create Rental Invoice"
{
    dataset
    {
        modify(RentalHeader)
        {
            RequestFilterFields = "Invoice Sequence";
        }
    }
}

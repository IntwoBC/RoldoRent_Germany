namespace RoldoRent;

using RoldoRent.RoldoRent;

permissionset 60000 GeneratedPermission
{
    Assignable = true;
    Permissions = report "Credit Note" = X,
        report "Order Conf. for Ret. Transport" = X,
        report "Order Conf. W/O Transport" = X,
        report "Order Confirmation" = X,
        report "Posted Rental Invoice" = X,
        report "Purchase Order" = X,
        report "Rental Order For depot" = X,
        report "Return Slip for Depot" = X,
        report "Transport Order Rental" = X,
        report "Transport Order Return" = X,
        codeunit "I2I Field Transfer Handler" = X,
        codeunit "I2I Rental Contr. Sub Mgt." = X,
        codeunit "I2I Rental Disp. Sub Mgt" = X,
        page "I2I Items by Available Matrix" = X,
        page "Items Availability by Location" = X,
        page "Temp Rental Return Entries" = X,
        codeunit "I2I Posted Sales Inv. Email JQ" = X,
        tabledata "I2I Rental Email Report Buffer" = RIMD,
        table "I2I Rental Email Report Buffer" = X,
        codeunit "I2I Manual Email Marker Sub" = X,
        codeunit "I2I Rental Doc. Email Mgt" = X,
        page "I2I Invoice Email Markers" = X,
        page "I2I Rental Email Report Select" = X,
        report "I2I Combine Invoice" = X,
        codeunit "I2I Email Body Sig. Inserter" = X;
}
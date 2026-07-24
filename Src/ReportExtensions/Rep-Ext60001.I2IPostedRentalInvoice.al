// namespace RoldoRent.RoldoRent;
// using Microsoft.Sales.History;

// reportextension 60001 "I2I Posted Rental Invoice" extends "ADA Posted Rental Invoice"
// {
//     dataset
//     {
//         modify(SalesInvoiceHeader)
//         {
//             trigger OnAfterAfterGetRecord()
//             begin
//                 Codeunit.Run(Codeunit::"Sales Inv.-Printed", SalesInvoiceHeader);
//             end;
//         }
//     }
// }

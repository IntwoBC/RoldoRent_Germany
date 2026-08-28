report 60006 "Transport Order Return"
{
    ApplicationArea = All;
    Caption = 'Transport Order Return';
    UsageCategory = ReportsAndAnalysis;
    //RDLCLayout = 'Src/ReportLayouts/TransportOrderReturn.rdlc';
    RDLCLayout = 'Src/Reports/TransportOrderReturn/TransportOrderReturn.rdlc';
    dataset
    {
        dataitem(EQMRentalDispatchHeader; "EQM Rental Dispatch Header")
        {
            RequestFilterFields = "No.";
            column(No_; "No.") { }
            column(Contract_No_; ContractNo) { }
            column(CustomerNo; "Customer No.") { }
            column(Customer_Name; "Customer Name") { }
            column(Posting_Date; Format("Posting Date", 0, '<Day,2>-<Month>-<Year4>')) { }
            column(Off_Rent_Date; Format("Off-Rent Date", 0, '<Day,2>-<Month>-<Year4>')) { }
            column(Ship_to_Contact; "Ship-to Contact") { }
            column(I2I_Contact_No_; "I2I Contact No.") { }
            column(Customer_Project; "Customer Project") { }
            column(OutBoundText; OutBoundText) { }
            column(CustContactNo; CustContactNo) { }
            column(Shipment_Date; Format("Shipment Date", 0, '<Day,2>-<Month>-<Year4>')) { }
            column(Return_Date; Format("Return Date", 0, '<Day,2>-<Month>-<Year4>')) { }
            column(ShipAgentName; ShipAgentName) { }
            column(CompanyPicture; CompanyInfo.Picture) { }
            column(CompanyAddr1; CompanyAddr[1]) { }
            column(CompanyAddr2; CompanyAddr[2]) { }
            column(CompanyAddr3; CompanyAddr[3]) { }
            column(CompanyAddr4; CompanyAddr[4]) { }
            column(CompanyAddr5; CompanyAddr[5]) { }
            column(CompanyAddr6; CompanyAddr[6]) { }
            column(CompanyAddr7; CompanyAddr[7]) { }
            column(CompanyAddr8; CompanyAddr[8]) { }
            column(CustAddr1; CustAddr[1]) { }
            column(CustAddr2; CustAddr[2]) { }
            column(CustAddr3; CustAddr[3]) { }
            column(CustAddr4; CustAddr[4]) { }
            column(CustAddr5; CustAddr[5]) { }
            column(CustAddr6; CustAddr[6]) { }
            column(CustAddr7; CustAddr[7]) { }
            column(CustAddr8; CustAddr[8]) { }
            column(ShipToAddr1; ShipToAddr[1]) { }
            column(ShipToAddr2; ShipToAddr[2]) { }
            column(ShipToAddr3; ShipToAddr[3]) { }
            column(ShipToAddr4; ShipToAddr[4]) { }
            column(ShipToAddr5; ShipToAddr[5]) { }
            column(ShipToAddr6; ShipToAddr[6]) { }
            column(ShipToAddr7; ShipToAddr[7]) { }
            column(ShipToAddr8; ShipToAddr[8]) { }
            column(ContactEmail; "I2I Contact E-Mail") { }
            column(ContactName; "I2I Contact Name") { }
            //Footer Fields
            column(CompanyNameTxt; CompanyNameTxt) { }
            column(CompanyAddressTxt; CompanyAddressTxt) { }
            column(CompanyCityTxt; CompanyCityTxt) { }
            column(CompanyPhoneNo; CompanyPhoneNo) { }
            column(CompanyEmail; CompanyEmail) { }
            column(CompanyHomePage; CompanyHomePage) { }
            column(CompanyRegNo; CompanyRegNo) { }
            column(CompanyContactPerson; CompanyContactPerson) { }
            column(CompanyBankName; CompanyBankName) { }
            column(CompanyBankAccNo; CompanyBankAccNo) { }
            column(CompanyVATRegNo; CompanyInfo."VAT Registration No.") { }
            column(CompanySwiftCode; CompanySwiftCode) { }
            column(CompanyDOC; CompanyInfo."I2I DOC. Text") { }
            column(OpeningHours; OpeningHours) { }
            column(OpeningHoursLbl; OpeningHoursLbl) { }
            column(DeliveryAddressLbl; DeliveryAddressLbl) { }
            column(CustomerPickupAddressLbl; CustomerPickupAddressLbl) { }
            column(ContractNumberLbl; ContractNumberLbl) { }
            column(CustomerNameLbl; CustomerNameLbl) { }
            column(ReferenceLbl; ReferenceLbl) { }
            column(CarrierLbl; CarrierLbl) { }
            column(PickupDateLbl; PickupDateLbl) { }
            column(TransportDeliveryDateLbl; TransportDeliveryDateLbl) { }
            column(MaterialsLbl; MaterialsLbl) { }
            column(TransportOrderReturnLbl; TransportOrderReturnLbl) { }
            column(ItemNumberLbl; ItemNumberLbl) { }
            column(DescriptionLbl; DescriptionLbl) { }
            column(QuantityLbl; QuantityLbl) { }
            column(TotalWeightKgLbl; TotalWeightKgLbl) { }
            column(NoHeaderLbl; NoHeaderLbl) { }
            column(RemarksLbl; RemarksLbl) { }
            column(DeliveryConfirmationLbl; DeliveryConfirmationLbl) { }
            column(ContactInfoTxt; ContactInfoTxt) { }
            column(TermsAndConditionsTxt; TermsAndConditionsTxt) { }
            dataitem("EQM Rental Dispatch Line"; "EQM Rental Dispatch Line")
            {
                DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                DataItemTableView = where(Type = const(Item));
                column(No_EQMRentalLine; "No.") { }
                column(Description_EQMRentalLine; Description) { }
                column(Quantity_EQMRentalLine; Quantity) { }
                column(Qty__to_Collect; "Qty. to Collect") { }
                column(UnitPrice_EQMRentalLine; "Unit Price") { }
                column(LineDiscount_EQMRentalLine; "Line Discount %") { }
                column(PriceTermCode_EQMRentalLine; "Price Term Code") { }
                column(UnitofMeasure_EQMRentalLine; "Unit of Measure") { }
                column(LineDiscountAmount_EQMRentalLine; "Line Discount Amount") { }
                column(ItemWeight; ItemWeight) { }
                trigger OnPreDataItem()
                begin
                    SetRange("Line Type", "Line Type"::" ");
                    SetFilter(Quantity, '>0');
                end;

                trigger OnAfterGetRecord()
                var
                    Item: Record Item;
                begin
                    Clear(ItemWeight);
                    if Item.Get("No.") then
                        ItemWeight += Item."Net Weight" * "Qty. to Collect";
                end;
            }
            trigger OnAfterGetRecord()
            var
                Customer: Record Customer;
                ShippingAgent: Record "Shipping Agent";
                SalesPerson: Record "Salesperson/Purchaser";
                ReportHelper: Codeunit "I2I Report Helper";
                RecRefL: RecordRef;
            begin
                CurrReport.Language := ReportHelper.GetReportLanguageId(EQMRentalDispatchHeader."Language Code", EQMRentalDispatchHeader."Customer No.", DefaultLanguageCodeLbl);
                RecRefL.GetTable(EQMRentalDispatchHeader);

                OutBoundText := ReportHelper.GetMemoTextFromBlob(RecRefL, EQMRentalDispatchHeader.FieldNo("Inbound Memo Text"));
                ReportHelper.GetShipAddressData(RecRefL, ShipToAddr);
                ReportHelper.GetShipToAddressFromLocation(EQMRentalDispatchHeader."Receiving Location Code", CustAddr);
                ReportHelper.UpdateCompanyReportData(
                    EQMRentalDispatchHeader."Customer No.",
                    EQMRentalDispatchHeader."Location Code",
                    CompanyAddr,
                    CompanyNameTxt,
                    CompanyAddressTxt,
                    CompanyCityTxt,
                    CompanyPhoneNo,
                    CompanyEmail,
                    CompanyHomePage,
                    CompanyRegNo,
                    CompanyContactPerson,
                    CompanyBankName,
                    CompanyBankAccNo,
                    CompanySwiftCode,
                    OpeningHours);
                ReportHelper.BuildTransportFooterTexts(
                    DeliveryConfirmationDateLineLbl,
                    DeliveryConfirmationNameLineLbl,
                    DeliveryConfirmationSignatureLineLbl,
                    ContactInfoLbl,
                    TermsAndConditionsLbl,
                    CompanyPhoneNo,
                    CompanyEmail,
                    CompanyHomePage,
                    DeliveryConfirmationLbl,
                    ContactInfoTxt,
                    TermsAndConditionsTxt);

                if Customer.Get("Customer No.") then begin
                    CustContactNo := Customer.Contact;
                end;
                if ShippingAgent.Get(EQMRentalDispatchHeader."Shipping Agent Code") then
                    ShipAgentName := ShippingAgent.Name;
                if SalesPerson.Get("Salesperson Code") then begin
                    ContactName := SalesPerson.Name;
                    ContactEmail := SalesPerson."E-Mail";
                end;

                ContractNo := ReportHelper.GetFirstDispatchContractNo(EQMRentalDispatchHeader."No.");
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    trigger OnInitReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        CustAddr: array[8] of Text[100];
        ShipToAddr: array[8] of Text[100];
        CompanyAddr: array[8] of Text[100];
        ContactEmail: Text[100];
        ContactName: Text[100];
        CompanyNameTxt: Text[100];
        CompanyAddressTxt: Text[100];
        CompanyCityTxt: Text[100];
        CompanyPhoneNo: Text[100];
        CompanyEmail: Text[100];
        CompanyHomePage: Text[100];
        CompanyRegNo: Text[100];
        CompanyContactPerson: Text[100];
        CompanyBankAccNo: Text[100];
        CompanyBankName: Text[100];
        CompanySwiftCode: Text[100];
        CustContactNo: Text[100];
        ShipAgentName: Text[100];
        OutBoundText: Text[2048];
        ContractNo: Text[100];
        ItemWeight: Decimal;
        OpeningHours: Text[100];
        OpeningHoursLbl: Label 'Opening Hours';
        DeliveryAddressLbl: Label 'Delivery Address';
        CustomerPickupAddressLbl: Label 'Customer Pickup Address';
        ContractNumberLbl: Label 'Contract Number';
        CustomerNameLbl: Label 'Customer Name:';
        ReferenceLbl: Label 'Reference:';
        CarrierLbl: Label 'Carrier:';
        PickupDateLbl: Label 'Pickup Date:';
        TransportDeliveryDateLbl: Label 'Transport Delivery Date:';
        MaterialsLbl: Label 'Materials:';
        TransportOrderReturnLbl: Label 'Transport Order Return';
        ItemNumberLbl: Label 'Item No.';
        DescriptionLbl: Label 'Description';
        QuantityLbl: Label 'Quantity';
        TotalWeightKgLbl: Label 'Total Weight (kg)';
        NoHeaderLbl: Label 'No ';
        RemarksLbl: Label 'Remarks:';
        DeliveryConfirmationLbl: Text[512];
        ContactInfoTxt: Text[512];
        TermsAndConditionsTxt: Text[250];
        DeliveryConfirmationDateLineLbl: Label 'Date:                        ..............................';
        DeliveryConfirmationNameLineLbl: Label 'Name (full):                 ..............................';
        DeliveryConfirmationSignatureLineLbl: Label 'Customer signature:          ..............................';
        ContactInfoLbl: Label 'If you have any questions, please contact me at Tel. %1, or by email %2 ';
        TermsAndConditionsLbl: Label 'Our general terms and conditions apply to this order, see %1/downloads ';
        DefaultLanguageCodeLbl: Label 'DE', Locked = true;
}
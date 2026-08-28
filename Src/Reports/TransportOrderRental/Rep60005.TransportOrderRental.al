report 60005 "Transport Order Rental"
{
    ApplicationArea = All;
    Caption = 'Transport Order Rental';
    UsageCategory = ReportsAndAnalysis;
    //RDLCLayout = 'Src/ReportLayouts/TransportOrderRental.rdlc';
    RDLCLayout = 'Src/Reports/TransportOrderRental/TransportOrderRental.rdlc';
    dataset
    {
        dataitem(EQMRentalHeader; "EQM Rental Header")
        {
            RequestFilterFields = "Contract No.";
            column(ContractNo; "Contract No.") { }
            column(ContractType; "Contract Type") { }
            column(CustomerNo; "Customer No.") { }
            column(ContactName; ContactName) { }
            column(ContactEmail; ContactEmail) { }
            column(YourReference; "Customer Project") { }
            column(OutBoundText; OutBoundText) { }
            column(Contract_Date; Format("Contract Date", 0, '<Day,2>-<Month>-<Year4>')) { }
            column(Bill_to_Contact; "Bill-to Contact") { }
            column(Ship_to_Contact; "Ship-to Contact") { }
            column(Shipment_Date; Format("Shipment Date", 0, '<Day,2>-<Month>-<Year4>')) { }
            column(OnRent_Date; Format("Start Rental Period Date", 0, '<Day,2>-<Month>-<Year4>')) { }
            column(Salesperson_Code; "Salesperson Code") { }
            column(CustContactNo; CustContactNo) { }
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
            column(PickupAddressRoldoRentLbl; PickupAddressRoldoRentLbl) { }
            column(DeliveryAddressCustomerLbl; DeliveryAddressCustomerLbl) { }
            column(ContractNumberLbl; ContractNumberLbl) { }
            column(ContactPersonLbl; ContactPersonLbl) { }
            column(ContactEmailLbl; ContactEmailLbl) { }
            column(ReferenceLbl; ReferenceLbl) { }
            column(DateLbl; DateLbl) { }
            column(CarrierLbl; CarrierLbl) { }
            column(PickupDateLbl; PickupDateLbl) { }
            column(TransportDeliveryDateLbl; TransportDeliveryDateLbl) { }
            column(MaterialsLbl; MaterialsLbl) { }
            column(TransportOrderRentalLbl; TransportOrderRentalLbl) { }
            column(ItemNumberLbl; ItemNumberLbl) { }
            column(DescriptionLbl; DescriptionLbl) { }
            column(QuantityLbl; QuantityLbl) { }
            column(TotalWeightKgLbl; TotalWeightKgLbl) { }
            column(ContractNoHeaderLbl; ContractNoHeaderLbl) { }
            column(RemarksLbl; RemarksLbl) { }
            column(LoadingMetersLbl; LoadingMetersLbl) { }
            column(DeliveryConfirmationLbl; DeliveryConfirmationLbl) { }
            column(ContactInfoTxt; ContactInfoTxt) { }
            column(TermsAndConditionsTxt; TermsAndConditionsTxt) { }
            dataitem("EQM Rental Line"; "EQM Rental Line")
            {
                DataItemLink = "Contract Type" = field("Contract Type"), "Contract No." = field("Contract No.");
                DataItemTableView = where(Type = const(Item));
                column(No_EQMRentalLine; "No.") { }
                column(Description_EQMRentalLine; Description) { }
                column(Quantity_EQMRentalLine; Quantity) { }
                column(UnitPrice_EQMRentalLine; "Unit Price") { }
                column(LineDiscount_EQMRentalLine; "Line Discount %") { }
                column(PriceTermCode_EQMRentalLine; "Price Term Code") { }
                column(UnitofMeasure_EQMRentalLine; "Unit of Measure") { }
                column(Net_Weight; "Net Weight") { }
                column(LineDiscountAmount_EQMRentalLine; "Line Discount Amount") { }
            }
            trigger OnAfterGetRecord()
            var
                Customer: Record Customer;
                ShippingAgent: Record "Shipping Agent";
                SalesPerson: Record "Salesperson/Purchaser";
                ReportHelper: Codeunit "I2I Report Helper";
                RecRefL: RecordRef;
            begin
                CurrReport.Language := ReportHelper.GetReportLanguageId(EQMRentalHeader."Language Code", EQMRentalHeader."Customer No.", DefaultLanguageCodeLbl);
                RecRefL.GetTable(EQMRentalHeader);

                OutBoundText := ReportHelper.GetMemoTextFromBlob(RecRefL, EQMRentalHeader.FieldNo("Outbound Memo Text"));
                ReportHelper.GetShipAddressData(RecRefL, ShipToAddr);
                ReportHelper.GetShipToAddressFromLocation(EQMRentalHeader."Location Code", CustAddr);
                ReportHelper.UpdateCompanyReportData(
                    EQMRentalHeader."Customer No.",
                    EQMRentalHeader."Location Code",
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

                if Customer.Get("Bill-to Customer No.") then begin
                    CustContactNo := Customer.Contact;
                end;
                if ShippingAgent.Get(EQMRentalHeader."Shipping Agent Code") then
                    ShipAgentName := ShippingAgent.Name;
                if SalesPerson.Get("Salesperson Code") then begin
                    ContactName := SalesPerson.Name;
                    ContactEmail := SalesPerson."E-Mail";
                end;
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
        OutBoundText: Text;
        OpeningHours: Text[100];
        OpeningHoursLbl: Label 'Opening Hours';
        PickupAddressRoldoRentLbl: Label 'Pickup Address Roldo Rent:';
        DeliveryAddressCustomerLbl: Label 'Delivery Address Customer:';
        ContractNumberLbl: Label 'Contract Number';
        ContactPersonLbl: Label 'Contact Person:';
        ContactEmailLbl: Label 'Contact Email:';
        ReferenceLbl: Label 'Reference:';
        DateLbl: Label 'Date';
        CarrierLbl: Label 'Carrier:';
        PickupDateLbl: Label 'Pickup Date:';
        TransportDeliveryDateLbl: Label 'Transport Delivery Date:';
        MaterialsLbl: Label 'Materials:';
        TransportOrderRentalLbl: Label 'Transport Order Rental';
        ItemNumberLbl: Label 'Item No.';
        DescriptionLbl: Label 'Description';
        QuantityLbl: Label 'Quantity';
        TotalWeightKgLbl: Label 'Total Weight (kg)';
        ContractNoHeaderLbl: Label 'Contract No';
        RemarksLbl: Label 'Remarks: ';
        LoadingMetersLbl: Label 'Loading Meters:';
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
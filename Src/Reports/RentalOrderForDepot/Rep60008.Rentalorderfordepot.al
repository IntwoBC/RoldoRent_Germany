report 60008 "Rental Order For depot"
{
    ApplicationArea = All;
    Caption = 'Rental Order For depot';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'Src/Reports/RentalOrderForDepot/RentalOrderForDepot.rdlc';
    dataset
    {
        dataitem(EQMRentalHeader; "EQM Rental Header")
        {
            RequestFilterFields = "Contract No.";
            column(ContractNo; "Contract No.") { }
            column(ContractType; "Contract Type") { }
            column(CustomerNo; "Customer No.") { }
            column(Bill_to_Name; "Bill-to Name") { }
            column(ContactName; "Contact Name") { }
            column(YourReference; "Your Reference") { }
            column(Delivery_Date; "I2I Delivery Date") { }
            column(OutBoundText; OutBoundText) { }
            column(Contract_Date; Format("Contract Date", 0, '<Day,2>-<Month>-<Year4>')) { }
            column(Bill_to_Contact; "Bill-to Contact") { }
            column(Ship_to_Contact; "Ship-to Contact") { }
            column(Shipment_Date; Format("Shipment Date", 0, '<Day,2>-<Month>-<Year4>')) { }
            column(Customer_Project; "Customer Project") { }
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
            column(ContactEmail; ContactEmail) { }
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
            column(RentalOrderLbl; RentalOrderLbl) { }
            column(ContractNoLbl; ContractNoLbl) { }
            column(CustomerNameLbl; CustomerNameLbl) { }
            column(ReferenceLbl; ReferenceLbl) { }
            column(PickupDateLbl; PickupDateLbl) { }
            column(DateLbl; DateLbl) { }
            column(CustomerDetailsLbl; CustomerDetailsLbl) { }
            column(PaymentDetailsLbl; PaymentDetailsLbl) { }
            column(MaterialsLbl; MaterialsLbl) { }
            column(ItemNoLbl; ItemNoLbl) { }
            column(DescriptionLbl; DescriptionLbl) { }
            column(QuantityLbl; QuantityLbl) { }
            column(RemarksLbl; RemarksLbl) { }

            dataitem("EQM Rental Line"; "EQM Rental Line")
            {
                DataItemLink = "Contract Type" = field("Contract Type"), "Contract No." = field("Contract No.");
                column(No_EQMRentalLine; "No.") { }
                column(Description_EQMRentalLine; Description) { }
                column(Quantity_EQMRentalLine; Quantity) { }
                column(UnitPrice_EQMRentalLine; "Unit Price") { }
                column(LineDiscount_EQMRentalLine; "Line Discount %") { }
                column(PriceTermCode_EQMRentalLine; "Price Term Code") { }
                column(UnitofMeasure_EQMRentalLine; "Unit of Measure") { }
                column(LineDiscountAmount_EQMRentalLine; "Line Discount Amount") { }
                trigger OnPreDataItem()
                begin
                    "EQM Rental Line".SetRange("Additional Charge", false);
                end;
            }
            trigger OnAfterGetRecord()
            var
                Contact: Record Contact;
                ReportHelper: Codeunit "I2I Report Helper";
                RecRefL: RecordRef;
            begin
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

                if Contact.Get(EQMRentalHeader."Contact No.") then
                    ContactEmail := Contact."E-Mail";
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
        FormatAddr: Codeunit "Format Address";
        CustAddr: array[8] of Text[100];
        ShipToAddr: array[8] of Text[100];
        CompanyAddr: array[8] of Text[100];
        ContactEmail: Text[100];
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
        OutBoundText: Text;
        OpeningHours: Text[100];
        OpeningHoursLbl: Label 'Öffnungszeiten';
        RentalOrderLbl: Label 'Rental Order';
        ContractNoLbl: Label 'Contract No.';
        CustomerNameLbl: Label 'Customer Name';
        ReferenceLbl: Label 'Reference';
        PickupDateLbl: Label 'Pickup Date';
        DateLbl: Label 'Date';
        CustomerDetailsLbl: Label 'Customer Details:';
        PaymentDetailsLbl: Label 'Payment Details:';
        MaterialsLbl: Label 'Materials:';
        ItemNoLbl: Label 'Item No.';
        DescriptionLbl: Label 'Description';
        QuantityLbl: Label 'Quantity';
        RemarksLbl: Label 'Remarks:';
}
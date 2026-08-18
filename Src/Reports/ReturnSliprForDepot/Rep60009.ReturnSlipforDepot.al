report 60009 "Return Slip for Depot"
{
    ApplicationArea = All;
    Caption = 'Return Slip for Depot';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'Src/Reports/ReturnSliprForDepot/ReturnSlipForDepot.rdlc';
    dataset
    {
        dataitem("EQM Rental Dispatch Header"; "EQM Rental Dispatch Header")
        {
            RequestFilterFields = "No.";
            column(Contract_No_; ContractNo) { }
            column(No_; "No.") { }
            column(CustomerNo; "Customer No.") { }
            column(OutBoundText; OutBoundText) { }
            column(ShipmentAgentName; ShipmentAgentName) { }
            column(Return_Date; "Return Date") { }
            column(Posting_Date; "Posting Date") { }
            column(Ship_to_Contact; "Ship-to Contact") { }
            column(ContactName; "I2I Contact Name") { }
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
            column(ContactEmail; "I2I Contact E-Mail") { }
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
            column(ReturnOrderLbl; ReturnOrderLbl) { }
            column(ContractNoLbl; ContractNoLbl) { }
            column(ContactPersonLbl; ContactPersonLbl) { }
            column(ContactEmailLbl; ContactEmailLbl) { }
            column(ReferenceLbl; ReferenceLbl) { }
            column(DateLbl; DateLbl) { }
            column(ReturnDateLbl; ReturnDateLbl) { }
            column(CarrierLbl; CarrierLbl) { }
            column(CustomerDetailsLbl; CustomerDetailsLbl) { }
            column(PaymentDetailsLbl; PaymentDetailsLbl) { }
            column(MaterialsLbl; MaterialsLbl) { }
            column(ItemNoLbl; ItemNoLbl) { }
            column(DescriptionLbl; DescriptionLbl) { }
            column(QuantityLbl; QuantityLbl) { }
            column(RemarksLbl; RemarksLbl) { }
            column(ContactInfoTxt; ContactInfoTxt) { }

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
                trigger OnPreDataItem()
                begin
                    SetRange("Line Type", "Line Type"::" ");
                    SetFilter(Quantity, '>0');
                end;
            }
            trigger OnAfterGetRecord()
            var
                ShipmentAgent: Record "Shipping Agent";
                ReportHelper: Codeunit "I2I Report Helper";
                RecRefL: RecordRef;
            begin
                RecRefL.GetTable("EQM Rental Dispatch Header");

                OutBoundText := ReportHelper.GetMemoTextFromBlob(RecRefL, "EQM Rental Dispatch Header".FieldNo("Inbound Memo Text"));
                ReportHelper.GetShipAddressData(RecRefL, ShipToAddr);
                ReportHelper.GetShipToAddressFromLocation("EQM Rental Dispatch Header"."Receiving Location Code", CustAddr);
                ReportHelper.UpdateCompanyReportData(
                    "EQM Rental Dispatch Header"."Customer No.",
                    "EQM Rental Dispatch Header"."Location Code",
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

                if ShipmentAgent.Get("EQM Rental Dispatch Header"."Shipping Agent Code") then
                    ShipmentAgentName := ShipmentAgent.Name;

                ContactInfoTxt := StrSubstNo(ContactInfoLbl, CompanyPhoneNo, CompanyEmail);

                ContractNo := ReportHelper.GetFirstDispatchContractNo("EQM Rental Dispatch Header"."No.");
            end;
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
        OutBoundText: Text;
        ShipmentAgentName: Text[100];
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
        ContractNo: Text[100];
        OpeningHours: Text[100];
        OpeningHoursLbl: Label 'Öffnungszeiten';
        ReturnOrderLbl: Label 'Return Order';
        ContractNoLbl: Label 'Contract No.';
        ContactPersonLbl: Label 'Contact Person:';
        ContactEmailLbl: Label 'Contact Email:';
        ReferenceLbl: Label 'Reference:';
        DateLbl: Label 'Date';
        ReturnDateLbl: Label 'Return Date:';
        CarrierLbl: Label 'Shipping Agent:';
        CustomerDetailsLbl: Label 'Customer Details:';
        PaymentDetailsLbl: Label 'Payment Details:';
        MaterialsLbl: Label 'Materials:';
        ItemNoLbl: Label 'Item No.';
        DescriptionLbl: Label 'Description';
        QuantityLbl: Label 'Quantity';
        RemarksLbl: Label 'Remarks:';
        ContactInfoLbl: Label 'If you have any questions, please feel free to contact me at Tel. %1 or by email at %2.';
        ContactInfoTxt: Text;
}
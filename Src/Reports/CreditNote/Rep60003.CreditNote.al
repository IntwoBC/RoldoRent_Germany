report 60003 "Credit Note"
{
    ApplicationArea = All;
    Caption = 'Credit Note';
    UsageCategory = ReportsAndAnalysis;
    //RDLCLayout = 'Src/ReportLayouts/CreditNote.rdlc';
    RDLCLayout = 'Src/Reports/CreditNote/CreditNote.rdlc';

    dataset
    {
        dataitem(SalesCrMemoHeader; "Sales Cr.Memo Header")
        {
            RequestFilterFields = "No.";
            column(No_; "No.") { }
            column(Bill_to_Customer_No_; "Bill-to Customer No.") { }
            column(Bill_to_Name; "Bill-to Name") { }
            column(Posting_Date; Format("Posting Date", 0, '<Day,2>-<Month>-<Year4>')) { }
            column(Your_Reference; "Your Reference") { }
            column(VAT_Registration_No_; "VAT Registration No.") { }
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
            column(ContactName; ContactName) { }
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
            column(CustContactNo; CustContactNo) { }
            column(Amount_Including_VAT; "Amount Including VAT") { }
            column(Amount; Amount) { }
            column(VATAmount; VATAmount) { }
            column(OpeningHours; OpeningHours) { }
            column(OpeningHoursLbl; OpeningHoursLbl) { }
            column(DocumentLbl; DocumentLbl) { }
            column(ReferenceLbl; ReferenceLbl) { }
            column(DateLbl; DateLbl) { }
            column(ProjectCodeLbl; ProjectCodeLbl) { }
            column(VATNoLbl; VATNoLbl) { }
            column(CustomerDetailsLbl; CustomerDetailsLbl) { }
            column(CustomerNoLbl; CustomerNoLbl) { }
            column(ItemNoLbl; ItemNoLbl) { }
            column(DescriptionLbl; DescriptionLbl) { }
            column(QuantityLbl; QuantityLbl) { }
            column(UOMLbl; UOMLbl) { }
            column(UnitPriceLbl; UnitPriceLbl) { }
            column(LineAmountLbl; LineAmountLbl) { }
            column(TotalExclVAT; TotalExclVAT) { }
            column(TotalInclVAT; TotalInclVAT) { }
            column(TotalVAT; TotalVAT) { }

            dataitem("Sales Cr.Memo Line"; "Sales Cr.Memo Line")
            {
                DataItemLink = "Document No." = field("No.");
                column(No_SalesCrMemoLine; "No.") { }
                column(Description_SalesCrMemoLine; Description) { }
                column(Quantity_SalesCrMemoLine; Quantity) { }
                column(UnitofMeasure_SalesCrMemoLine; "Unit of Measure") { }
                column(UnitPrice_SalesCrMemoLine; "Unit Price") { }
                column(LineAmount_SalesCrMemoLine; "Line Amount") { }
                column(VAT__; VATPercent) { }
            }
            trigger OnAfterGetRecord()
            var
                Contact: Record Contact;
                Customer: Record Customer;
                ShippingAgent: Record "Shipping Agent";
                SalesCrMLine: Record "Sales Cr.Memo Line";
                ReportHelper: Codeunit "I2I Report Helper";
                RecRefL: RecordRef;
            begin
                RecRefL.GetTable(SalesCrMemoHeader);

                CalcFields("Amount Including VAT", Amount);

                ReportHelper.GetShipAndCustomerAddressData(RecRefL, ShipToAddr, CustAddr);
                ReportHelper.UpdateCompanyReportData(
                    SalesCrMemoHeader."Bill-to Customer No.",
                    SalesCrMemoHeader."Location Code",
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

                if Contact.Get(SalesCrMemoHeader."Bill-to Contact No.") then begin
                    ContactEmail := Contact."E-Mail";
                    ContactName := Contact.Name;
                end;
                if Customer.Get("Bill-to Customer No.") then begin
                    CustContactNo := Customer.Contact;
                end;
                if ShippingAgent.Get(SalesCrMemoHeader."Shipping Agent Code") then
                    ShipAgentName := ShippingAgent.Name;

                VATAmount := "Amount Including VAT" - Amount;

                SalesCrMLine.SetRange("Document No.", "No.");
                SalesCrMLine.SetFilter(Type, '%1|%2', SalesCrMLine.Type::Item, SalesCrMLine.Type::"G/L Account");
                if SalesCrMLine.FindFirst() then
                    VATPercent := SalesCrMLine."VAT %";

                ReportHelper.AssignCurrencyCode(SalesCrMemoHeader."Currency Code", VATPercent,
                    TotalExclVATLbl, TotalInclVATLbl, TotalVATLbl, TotalExclVAT, TotalInclVAT, TotalVAT);
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
        VATAmount: Decimal;
        VATPercent: Decimal;
        OpeningHours: Text[100];
        OpeningHoursLbl: Label 'Openingstijden';
        DocumentLbl: Label 'Credit Note';
        ReferenceLbl: Label 'Reference:';
        DateLbl: Label 'Date :';
        ProjectCodeLbl: Label 'Project Code :';
        VATNoLbl: Label 'VAT No. :';
        CustomerDetailsLbl: Label 'Customer Details';
        CustomerNoLbl: Label 'Customer No.';
        ItemNoLbl: Label 'Item No.';
        DescriptionLbl: Label 'Description';
        QuantityLbl: Label 'Quantity';
        UOMLbl: Label 'Unit of Measure';
        UnitPriceLbl: Label 'Unit Price';
        LineAmountLbl: Label 'Line Amount';
        TotalExclVATLbl: Label 'Total %1 Excl. VAT';
        TotalInclVATLbl: Label 'Total %1 Incl. VAT';
        TotalVATLbl: Label '%1% VAT';
        TotalExclVAT: Text[100];
        TotalInclVAT: Text[100];
        TotalVAT: Text[100];
}
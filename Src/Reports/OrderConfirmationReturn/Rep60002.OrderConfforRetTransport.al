report 60002 "I2I Order Conf. for Ret. Tran."
{
    ApplicationArea = All;
    Caption = 'Order Confirmation Return';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'Src/Reports/OrderConfirmationReturn/OrderConfirmationReturn.rdlc';
    dataset
    {
        dataitem(EQMRentalDispatchHeader; "EQM Rental Dispatch Header")
        {
            RequestFilterFields = "No.";
            column(No_; "No.") { }
            column(Contract_No_; ContractNo) { }
            column(CustomerNo; "Customer No.") { }
            column(CustomerName; "Customer Name") { }
            column(Posting_Date; Format("Posting Date", 0, '<Day,2>-<Month>-<Year4>')) { }
            column(Ship_to_Contact; "Ship-to Contact") { }
            column(I2I_Contact_No_; "I2I Contact No.") { }
            column(Contact_Name; "I2I Contact Name") { }
            column(Contact_E_Mail; "I2I Contact E-Mail") { }
            column(OutBoundText; OutBoundText) { }
            column(CustContactNo; CustContactNo) { }
            column(Customer_Project; "Customer Project") { }
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
            column(I2I_Transportation_Charges; "I2I Transportation Charges") { }
            //TransportLines
            column(TranspGLAcc; TranspGLAcc) { }
            column(TranspGLACCName; TranspGLACCName) { }
            column(TranspQuantity; TranspQuantity) { }
            column(TranspCost; TranspCost) { }
            column(CreatedName; CreatedName) { }
            column(DocumentLbl; DocumentLbl) { }
            column(ContractNoLbl; ContractNoLbl) { }
            column(CustomerNameLbl; CustomerNameLbl) { }
            column(ReferenceLbL; ReferenceLbL) { }
            column(PickupDateLbl; PickupDateLbl) { }
            column(DateLbl; DateLbl) { }
            column(ShippingAgentLbl; ShippingAgentLbl) { }
            column(CustomerDetailsLbl; CustomerDetailsLbl) { }
            column(OrderConfirmationTextLbl; OrderConfirmationTextLbl) { }
            column(MaterialsLbl; MaterialsLbl) { }
            column(ItemNoLbl; ItemNoLbl) { }
            column(DescriptionLbl; DescriptionLbl) { }
            column(QuantityLbl; QuantityLbl) { }
            column(UnitPriceExclLbl; UnitPriceExclLbl) { }
            column(RemarksLbl; RemarksLbl) { }
            column(FooterNoteTxt; FooterNoteTxt) { }
            dataitem("EQM Rental Dispatch Line"; "EQM Rental Dispatch Line")
            {
                DataItemLink = "Document No." = field("No.");
                column(No_EQMRentalLine; "No.") { }
                column(Description_EQMRentalLine; Description) { }
                column(Quantity_EQMRentalLine; Quantity) { }
                column(UnitPrice_EQMRentalLine; "Unit Price") { }
                column(LineDiscount_EQMRentalLine; "Line Discount %") { }
                column(Qty__to_Collect; "Qty. to Collect") { }
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
                Contact: Record Contact;
                Customer: Record Customer;
                ShippingAgent: Record "Shipping Agent";
                SalesPerson: Record "Salesperson/Purchaser";
                User: Record User;
                ReportHelper: Codeunit "I2I Report Helper";
                RecRefL: RecordRef;
            begin
                RecRefL.GetTable(EQMRentalDispatchHeader);

                OutBoundText := GetOutboundMemoL(EQMRentalDispatchHeader);

                ReportHelper.GetShipAndCustomerAddressData(RecRefL, ShipToAddr, CustAddr);
                ReportHelper.UpdateCompanyReportData(
                    EQMRentalDispatchHeader."Customer No.",
                    EQMRentalDispatchHeader."Receiving Location Code",
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

                if SalesPerson.Get(EQMRentalDispatchHeader."Salesperson Code") then begin
                    ContactEmail := SalesPerson."E-Mail";
                    ContactName := SalesPerson.Name;
                end;
                if Customer.Get("Customer No.") then begin
                    CustContactNo := Customer.Contact;
                end;
                if ShippingAgent.Get(EQMRentalDispatchHeader."Shipping Agent Code") then
                    ShipAgentName := ShippingAgent.Name;

                if EQMRentalDispatchHeader."I2I Transportation Charges" then
                    TransportLine(EQMRentalDispatchHeader."I2I Transportation Cost");

                if User.Get(EQMRentalDispatchHeader.SystemCreatedBy) then
                    CreatedName := User."Full Name";

                FooterNoteTxt := BuildFooterNote(CompanyPhoneNo, CompanyEmail, CompanyHomePage, CreatedName);

                ContractNo := ReportHelper.GetFirstDispatchContractNo(EQMRentalDispatchHeader."No.");

                CurrReport.Language := ReportHelper.GetReportLanguageId(EQMRentalDispatchHeader."Language Code", EQMRentalDispatchHeader."Customer No.", DefaultLanguageCodeLbl);
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
        OutBoundText: Text[2048];
        ContractNo: Text[100];
        TranspGLAcc: Code[20];
        TranspGLACCName: Text[100];
        TranspQuantity: Decimal;
        TranspCost: Decimal;
        CreatedName: Text[100];
        OpeningHours: Text[100];
        FooterNoteTxt: Text;
        OpeningHoursLbl: Label 'Öffnungszeiten';
        DocumentLbl: Label 'Order Confirmation Return Transport';
        ContractNoLbl: Label 'Contract No.';
        CustomerNameLbl: Label 'Customer Name';
        ReferenceLbL: Label 'Reference';
        PickupDateLbl: Label 'Pickup Date';
        DateLbl: Label 'Date';
        ShippingAgentLbl: Label 'Shipping Agent';
        CustomerDetailsLbl: Label 'Customer Details';
        OrderConfirmationTextLbl: Label 'Thank you for your order. You have booked a return in accordance with the specifications outlined below.';
        MaterialsLbl: Label 'Materials :';
        ItemNoLbl: Label 'Item No.';
        DescriptionLbl: Label 'Description';
        QuantityLbl: Label 'Quantity';
        UnitPriceExclLbl: Label 'Unit Price Excl. VAT';
        RemarksLbl: Label 'Remarks :';
        ContactQuestionsLbl: Label 'If you have any questions, please feel free to contact me at Tel. %1 or by email %2.';
        ReturnConditionLbl: Label 'If the materials are not returned clean or in accordance with our return instructions, costs will be charged; the rate for this is €47.50 per working hour.';
        TermsConditionsLbl: Label 'Our general terms and conditions apply to this order, see %1/downloads.';
        KindRegardsLbl: Label 'Kind regards,';
        DefaultLanguageCodeLbl: Label 'DE', Locked = true;

    local procedure GetOutboundMemoL(var RentalDispHeader: Record "EQM Rental Dispatch Header"): Text
    var
        InS: InStream;
        TempText: Text;
        LineText: Text;
        NewLine: Text[4];
    begin
        //NewLine := '\r\n';

        RentalDispHeader.CalcFields("Inbound Memo Text");

        if RentalDispHeader."Inbound Memo Text".HasValue then begin
            RentalDispHeader."Inbound Memo Text".CreateInStream(InS);

            while not InS.EOS do begin
                InS.ReadText(LineText);
                TempText += LineText;
            end;
        end;

        exit(TempText);
    end;

    procedure TransportLine(Price: Decimal)
    var
        GLSetup: Record "General Ledger Setup";
        GLAccount: Record "G/L Account";
    begin
        GLSetup.Get();
        GLSetup.TestField("I2I Transp. Rev. G/L Acc");
        TranspGLAcc := GLSetup."I2I Transp. Rev. G/L Acc";
        if GLAccount.get(GLSetup."I2I Transp. Rev. G/L Acc") then
            TranspGLACCName := GLAccount.Name;
        TranspQuantity := 1;
        TranspCost := Price;
    end;

    procedure BuildFooterNote(CompanyPhoneNo: Text[100]; CompanyEmail: Text[100]; CompanyHomePage: Text[100]; CreatedName: Text[100]): Text
    var
        TextBuilder: TextBuilder;
    begin
        TextBuilder.AppendLine(StrSubstNo(ContactQuestionsLbl, CompanyPhoneNo, CompanyEmail));
        TextBuilder.AppendLine();
        TextBuilder.AppendLine(ReturnConditionLbl);
        TextBuilder.AppendLine();
        TextBuilder.AppendLine(StrSubstNo(TermsConditionsLbl, CompanyHomePage));
        TextBuilder.AppendLine();
        TextBuilder.AppendLine(KindRegardsLbl);
        TextBuilder.Append(CreatedName);

        exit(TextBuilder.ToText());
    end;
}
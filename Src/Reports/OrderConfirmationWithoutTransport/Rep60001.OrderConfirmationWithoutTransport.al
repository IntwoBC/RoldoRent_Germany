report 60001 "Order Conf. W/O Transport"
{
    ApplicationArea = All;
    Caption = 'Order Confirmation Without Transport';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'Src/Reports/OrderConfirmationWithoutTransport/OrderConfirmationWithoutTransport.rdlc';
    dataset
    {
        dataitem(EQMRentalHeader; "EQM Rental Header")
        {
            RequestFilterFields = "Contract No.";
            column(ContractNo; "Contract No.") { }
            column(ContractType; "Contract Type") { }
            column(CustomerNo; "Customer No.") { }
            column(ContactName; "Contact Name") { }
            column(YourReference; "Customer Project") { }
            column(OutBoundText; OutBoundText) { }
            column(Contract_Date; Format("Contract Date", 0, '<Day,2>-<Month>-<Year4>')) { }
            column(Bill_to_Contact; "Bill-to Contact") { }
            column(Ship_to_Contact; SalepersonName) { }
            column(Shipment_Date; Format("Shipment Date", 0, '<Day,2>-<Month>-<Year4>')) { }
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
            column(UserName; UserName) { }
            //Threshold Columns
            column(AboveThreshold; AboveThreshold) { }
            column(BelowThreshold; BelowThreshold) { }
            column(OpeningHours; OpeningHours) { }
            column(OpeningHoursLbl; OpeningHoursLbl) { }
            column(DocumentLbl; DocumentLbl) { }
            column(ContractNumberLbl; ContractNumberLbl) { }
            column(ContactPersonLbl; ContactPersonLbl) { }
            column(ContactEmailLbl; ContactEmailLbl) { }
            column(ReferenceLbL; ReferenceLbL) { }
            column(PickupDateLbl; PickupDateLbl) { }
            column(DateLbl; DateLbl) { }
            column(CustomerDetailsLbl; CustomerDetailsLbl) { }
            column(PickupAddressLbl; PickupAddressLbl) { }
            column(OrderConfirmationTextLbl; OrderConfirmationTextLbl) { }
            column(MaterialsLbl; MaterialsLbl) { }
            column(ItemNoLbl; ItemNoLbl) { }
            column(DescriptionLbl; DescriptionLbl) { }
            column(QuantityLbl; QuantityLbl) { }
            column(UnitPriceExclLbl; UnitPriceExclLbl) { }
            column(UOMLbl; UOMLbl) { }
            column(DiscountPercentLbl; DiscountPercentLbl) { }
            column(FooterNoteTxt; FooterNoteTxt) { }
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
                column(Line_Discount__; "Line Discount %") { }
                trigger OnAfterGetRecord()
                begin
                    if "Non-Billable" then
                        CurrReport.Skip();
                end;
            }
            trigger OnPreDataItem()
            var
                GLSetup: Record "General Ledger Setup";
            begin
                GLSetup.Get();
                AboveThreshold := Format(GLSetup."I2I Rental Price Abv. Thres.", 0, '<Precision,2:2><Standard Format,1>');
                AboveThreshold := AboveThreshold.Replace(',', '|').Replace('.', ',').Replace('|', '.');
                BelowThreshold := Format(GLSetup."I2I Rental Price Bel. Thres.", 0, '<Precision,2:2><Standard Format,1>');
                BelowThreshold := BelowThreshold.Replace(',', '|').Replace('.', ',').Replace('|', '.');
            end;

            trigger OnAfterGetRecord()
            var
                Contact: Record Contact;
                User: Record User;
                Salesperson: Record "Salesperson/Purchaser";
                ReportHelper: Codeunit "I2I Report Helper";
            begin
                OutBoundText := GetOutboundMemoL(EQMRentalHeader);

                ReportHelper.GetShipToAddressFromLocation(EQMRentalHeader."Location Code", ShipToAddr);
                ReportHelper.CustomerAddress(CustAddr, EQMRentalHeader."Customer No.");
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
                if User.Get(SystemCreatedBy) then
                    UserName := User."Full Name";

                if EQMRentalHeader."Salesperson Code" <> '' then begin
                    Salesperson.Get(EQMRentalHeader."Salesperson Code");
                    SalepersonName := Salesperson.Name;
                end;

                FooterNoteTxt := BuildFooterNote(BelowThreshold, AboveThreshold, OutBoundText,
                    CompanyPhoneNo, CompanyEmail, CompanyHomePage, UserName);
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
        OutBoundText: Text[2048];
        UserName: Text[100];
        SalepersonName: Text[100];
        AboveThreshold: Text[20];
        BelowThreshold: Text[20];
        OpeningHours: Text[100];
        OpeningHoursLbl: Label 'Öffnungszeiten';
        DocumentLbl: Label 'Order Confirmation';
        ContractNumberLbl: Label 'Contract Number';
        ContactPersonLbl: Label 'Contact Person';
        ContactEmailLbl: Label 'Contact Email';
        ReferenceLbL: Label 'Reference';
        PickupDateLbl: Label 'Pickup Date';
        DateLbl: Label 'Date';
        CustomerDetailsLbl: Label 'Customer Details';
        PickupAddressLbl: Label 'Pickup Address';
        OrderConfirmationTextLbl: Label 'Thank you for your order. You have made a rental reservation according to the specifications below:';
        MaterialsLbl: Label 'Materials :';
        ItemNoLbl: Label 'Item No.';
        DescriptionLbl: Label 'Description';
        QuantityLbl: Label 'Quantity';
        UnitPriceExclLbl: Label 'Unit Price Excl. VAT';
        UOMLbl: Label 'Unit of Measure';
        DiscountPercentLbl: Label 'Discount %';
        HandlingCostLbl: Label 'The costs for incoming and outgoing handling are €%1 for <500 items and €%2 for >500 items.';
        RemarksLbl: Label 'Remark :';
        ContactQuestionsLbl: Label 'If you have any questions, please feel free to contact me at Tel. %1 or by email %2.';
        ReturnConditionLbl: Label 'If the materials are not returned clean or in accordance with our return instructions, costs will be charged; the rate for this is €47.50 per working hour.';
        TermsConditionsLbl: Label 'Our general terms and conditions apply to this order, see %1/downloads.';
        KindRegardsLbl: Label 'Kind regards,';
        FooterNoteTxt: Text;

    local procedure GetOutboundMemoL(var RentalHeader: Record "EQM Rental Header"): Text
    var
        InS: InStream;
        TempText: Text;
        LineText: Text;
        NewLine: Text[4];
    begin
        RentalHeader.CalcFields("Outbound Memo Text");
        if RentalHeader."Outbound Memo Text".HasValue then begin
            RentalHeader."Outbound Memo Text".CreateInStream(InS);
            while not InS.EOS do begin
                InS.ReadText(LineText);
                TempText += LineText;
            end;
        end;
        exit(TempText);
    end;

    procedure BuildFooterNote(BelowThresholdCost: Text; AboveThresholdCost: Text; OutBoundText: Text;
    CompanyPhoneNo: Text[100]; CompanyEmail: Text[100]; CompanyHomePage: Text[100]; CreatedName: Text[100]): Text
    var
        TextBuilder: TextBuilder;
    begin
        TextBuilder.AppendLine(StrSubstNo(HandlingCostLbl, BelowThresholdCost, AboveThresholdCost));
        TextBuilder.AppendLine();

        if OutBoundText <> '' then begin
            TextBuilder.AppendLine(RemarksLbl);
            TextBuilder.AppendLine(OutBoundText);
            TextBuilder.AppendLine();
        end;

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
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
                RentalDispLines: Record "EQM Rental Dispatch Line";
                User: Record User;
            begin

                OutBoundText := GetOutboundMemoL(EQMRentalDispatchHeader);
                ShipAddress(EQMRentalDispatchHeader);
                CustomerAddress(EQMRentalDispatchHeader);
                CompanyAddress();
                UpdateFooterData(EQMRentalDispatchHeader);
                GetHomePageFromLocation(EQMRentalDispatchHeader."Receiving Location Code");
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

                RentalDispLines.SetRange("Document No.", EQMRentalDispatchHeader."No.");
                if RentalDispLines.FindSet() then begin
                    repeat
                        if RentalDispLines."Contract No." <> '' then begin
                            ContractNo := RentalDispLines."Contract No.";
                            exit;
                        end;
                    until RentalDispLines.Next() = 0;
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
        OpeningHoursLbl: Label 'Öffnungszeiten';

    procedure ShipAddress(RentalDispHdr: Record "EQM Rental Dispatch Header")
    var
        LineNo: Integer;
        Country: Record "Country/Region";
    begin
        LineNo := 1;

        // Name
        if RentalDispHdr."Ship-to Name" <> '' then begin
            ShipToAddr[LineNo] := RentalDispHdr."Ship-to Name";
            LineNo += 1;
        end;

        // Name 2
        if RentalDispHdr."Ship-to Name 2" <> '' then begin
            ShipToAddr[LineNo] := RentalDispHdr."Ship-to Name 2";
            LineNo += 1;
        end;

        // Address 1
        if RentalDispHdr."Ship-to Address" <> '' then begin
            ShipToAddr[LineNo] := RentalDispHdr."Ship-to Address";
            LineNo += 1;
        end;

        // Address 2
        if RentalDispHdr."Ship-to Address 2" <> '' then begin
            ShipToAddr[LineNo] := RentalDispHdr."Ship-to Address 2";
            LineNo += 1;
        end;

        // Post Code + City (combined)
        if (RentalDispHdr."Ship-to Post Code" <> '') or (RentalDispHdr."Ship-to-City" <> '') then begin
            ShipToAddr[LineNo] := RentalDispHdr."Ship-to Post Code" + ' ' + RentalDispHdr."Ship-to-City";
            LineNo += 1;
        end;

        // County
        if RentalDispHdr."Ship-to County" <> '' then begin
            ShipToAddr[LineNo] := RentalDispHdr."Ship-to County";
            LineNo += 1;
        end;

        // Country
        if RentalDispHdr."Ship-to Country/Region Code" <> '' then begin
            Country.Get(RentalDispHdr."Ship-to Country/Region Code");
            ShipToAddr[LineNo] := Country.Name;
        end;
    end;

    procedure CustomerAddress(RentalDispHdr: Record "EQM Rental Dispatch Header")
    var
        LineNo: Integer;
        Customer: Record Customer;
        Country: Record "Country/Region";
    begin
        LineNo := 1;

        if not Customer.Get(RentalDispHdr."Customer No.") then
            exit;

        // Name
        if Customer.Name <> '' then begin
            CustAddr[LineNo] := Customer.Name;
            LineNo += 1;
        end;

        // Name 2
        if Customer."Name 2" <> '' then begin
            CustAddr[LineNo] := Customer."Name 2";
            LineNo += 1;
        end;

        // Address 1
        if Customer.Address <> '' then begin
            CustAddr[LineNo] := Customer.Address;
            LineNo += 1;
        end;

        // Address 2
        if Customer."Address 2" <> '' then begin
            CustAddr[LineNo] := Customer."Address 2";
            LineNo += 1;
        end;

        // Post Code + City
        if (Customer."Post Code" <> '') or (Customer.City <> '') then begin
            CustAddr[LineNo] := Customer."Post Code" + ' ' + Customer.City;
            LineNo += 1;
        end;

        // County
        if Customer.County <> '' then begin
            CustAddr[LineNo] := Customer.County;
            LineNo += 1;
        end;

        // Country
        if Customer."Country/Region Code" <> '' then begin
            Country.Get(RentalDispHdr."Ship-to Country/Region Code");
            CustAddr[LineNo] := Country.Name;
        end;
    end;

    procedure CompanyAddress()
    var
        LineNo: Integer;
        CompanyInfoL: Record "Company Information";
        Country: Record "Country/Region";
    begin
        LineNo := 1;

        CompanyInfoL.Get();

        // Name
        if CompanyInfoL.Name <> '' then begin
            CompanyAddr[LineNo] := CompanyInfoL.Name;
            LineNo += 1;
        end;

        // Name 2
        if CompanyInfoL."Name 2" <> '' then begin
            CompanyAddr[LineNo] := CompanyInfoL."Name 2";
            LineNo += 1;
        end;

        // Address 1
        if CompanyInfoL.Address <> '' then begin
            CompanyAddr[LineNo] := CompanyInfoL.Address;
            LineNo += 1;
        end;

        // Address 2
        if CompanyInfoL."Address 2" <> '' then begin
            CompanyAddr[LineNo] := CompanyInfoL."Address 2";
            LineNo += 1;
        end;

        // Post Code + City
        if (CompanyInfoL."Post Code" <> '') or (CompanyInfoL.City <> '') then begin
            CompanyAddr[LineNo] := CompanyInfoL."Post Code" + ' ' + CompanyInfoL.City;
            LineNo += 1;
        end;

        // County
        if CompanyInfoL.County <> '' then begin
            CompanyAddr[LineNo] := CompanyInfoL.County;
            LineNo += 1;
        end;

        // Country
        if CompanyInfoL."Country/Region Code" <> '' then begin
            Country.Get(CompanyInfoL."Country/Region Code");
            CompanyAddr[LineNo] := Country.Name;
        end;
    end;

    procedure UpdateFooterData(RentalCollectionOrder: Record "EQM Rental Dispatch Header")
    var
        Customer: Record Customer;
        CustomerPosting: Record "Customer Posting Group";
        CompanyInfoL: Record "Company Information";
    begin
        CompanyInfoL.Get();

        CompanyNameTxt := CompanyInfoL.Name;
        CompanyAddressTxt := CompanyInfoL.Address;
        if CompanyInfoL."Address 2" <> '' then
            CompanyAddressTxt += ', ' + CompanyInfoL."Address 2";

        if (CompanyInfoL."Post Code" <> '') or (CompanyInfoL.City <> '') then begin
            CompanyCityTxt := CompanyInfoL."Post Code" + ' ' + CompanyInfoL.City;
        end;


        CompanyPhoneNo := CompanyInfoL."Phone No.";
        CompanyEmail := CompanyInfoL."E-Mail";
        CompanyHomePage := CompanyInfoL."Home Page";
        CompanyRegNo := CompanyInfoL."Registration No.";
        CompanyContactPerson := CompanyInfoL."Contact Person";
        CompanyBankName := CompanyInfoL."Bank Name";
        CompanyBankAccNo := CompanyInfoL."Bank Account No.";
        CompanySwiftCode := CompanyInfoL."SWIFT Code";

        if not Customer.Get(RentalCollectionOrder."Customer No.") then
            exit;

        if not CustomerPosting.Get(Customer."Customer Posting Group") then
            exit;

        if (CustomerPosting.Code = 'AUSTRIA') or (CustomerPosting.Description = 'AUSTRIA') then begin
            CompanyPhoneNo := CompanyInfoL."I2I Phone No. AT";
            CompanyEmail := CompanyInfoL."I2I Email AT";
            CompanyHomePage := CompanyInfoL."I2I Home Page AT";
            CompanyRegNo := CompanyInfoL."I2I Company Reg No. AT";
            CompanyContactPerson := CompanyInfoL."I2I Contact Person AT";
            CompanyBankName := CompanyInfoL."I2I Bank Name AT";
            CompanyBankAccNo := CompanyInfoL."I2I Bank Acc. No. AT";
            CompanySwiftCode := CompanyInfoL."I2I Swift AT";
        end else
            if (CustomerPosting.Code = 'SCHWEIZ') or (CustomerPosting.Description = 'SCHWEIZ') then begin
                CompanyPhoneNo := CompanyInfoL."I2I Phone No. CH";
                CompanyEmail := CompanyInfoL."I2I Email CH";
                CompanyHomePage := CompanyInfoL."I2I Home Page CH";
                CompanyRegNo := CompanyInfoL."I2I Company Reg No. CH";
                CompanyContactPerson := CompanyInfoL."I2I Contact Person CH";
                CompanyBankName := CompanyInfoL."I2I Bank Name CH";
                CompanyBankAccNo := CompanyInfoL."I2I Bank Acc. No. CH";
                CompanySwiftCode := CompanyInfoL."I2I Swift CH";
            end;
    end;

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

    procedure GetHomePageFromLocation(LocationCode: Code[20])
    var
        LocationL: Record Location;
    begin
        Clear(LocationL);
        if not LocationL.Get(LocationCode) then begin
            OpeningHours := '';
            exit;
        end;
        OpeningHours := LocationL."Home Page";
    end;
}
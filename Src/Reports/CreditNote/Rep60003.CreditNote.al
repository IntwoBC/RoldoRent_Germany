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
            begin
                CalcFields("Amount Including VAT", Amount);
                ShipAddress(SalesCrMemoHeader);
                CustomerAddress(SalesCrMemoHeader);
                CompanyAddress();
                UpdateFooterData(SalesCrMemoHeader);
                GetHomePageFromLocation(SalesCrMemoHeader."Location Code");
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
                if SalesCrMLine.FindSet() then
                    repeat
                        if (SalesCrMLine.Type = SalesCrMLine.Type::Item) OR
                           (SalesCrMLine.Type = SalesCrMLine.Type::"G/L Account") then begin

                            VATPercent := SalesCrMLine."VAT %";
                            exit;
                        end;
                    until SalesCrMLine.Next() = 0;
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

    procedure ShipAddress(SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    var
        LineNo: Integer;
        Country: Record "Country/Region";
    begin
        LineNo := 1;

        // Name
        if SalesCrMemoHeader."Ship-to Name" <> '' then begin
            ShipToAddr[LineNo] := SalesCrMemoHeader."Ship-to Name";
            LineNo += 1;
        end;

        // Name 2
        if SalesCrMemoHeader."Ship-to Name 2" <> '' then begin
            ShipToAddr[LineNo] := SalesCrMemoHeader."Ship-to Name 2";
            LineNo += 1;
        end;

        // Address 1
        if SalesCrMemoHeader."Ship-to Address" <> '' then begin
            ShipToAddr[LineNo] := SalesCrMemoHeader."Ship-to Address";
            LineNo += 1;
        end;

        // Address 2
        if SalesCrMemoHeader."Ship-to Address 2" <> '' then begin
            ShipToAddr[LineNo] := SalesCrMemoHeader."Ship-to Address 2";
            LineNo += 1;
        end;

        // Post Code + City (combined)
        if (SalesCrMemoHeader."Ship-to Post Code" <> '') or (SalesCrMemoHeader."Ship-to City" <> '') then begin
            ShipToAddr[LineNo] := SalesCrMemoHeader."Ship-to Post Code" + ' ' + SalesCrMemoHeader."Ship-to City";
            LineNo += 1;
        end;

        // County
        if SalesCrMemoHeader."Ship-to County" <> '' then begin
            ShipToAddr[LineNo] := SalesCrMemoHeader."Ship-to County";
            LineNo += 1;
        end;

        // Country
        if SalesCrMemoHeader."Ship-to Country/Region Code" <> '' then begin
            Country.Get(SalesCrMemoHeader."Ship-to Country/Region Code");
            ShipToAddr[LineNo] := Country.Name;
        end;
    end;

    procedure CustomerAddress(SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    var
        LineNo: Integer;
        Customer: Record Customer;
        Country: Record "Country/Region";
    begin
        LineNo := 1;

        if not Customer.Get(SalesCrMemoHeader."Bill-to Customer No.") then
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
            Country.Get(SalesCrMemoHeader."Ship-to Country/Region Code");
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

        // // County
        // if CompanyInfoL.County <> '' then begin
        //     CompanyAddr[LineNo] := CompanyInfoL.County;
        //     LineNo += 1;
        // end;

        // Country
        if CompanyInfoL."Country/Region Code" <> '' then begin
            Country.Get(CompanyInfoL."Country/Region Code");
            CompanyAddr[LineNo] := Country.Name;
        end;
    end;

    procedure UpdateFooterData(SalesCrMemoHeader: Record "Sales Cr.Memo Header")
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

        if not Customer.Get(SalesCrMemoHeader."Bill-to Customer No.") then
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
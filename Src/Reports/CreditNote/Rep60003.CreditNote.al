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
            column(CompanyPhoneNo; CompanyInfo."Phone No.") { }
            column(CompanyEmail; CompanyInfo."E-Mail") { }
            column(CompanyHomePage; CompanyInfo."Home Page") { }
            column(CompanyBankName; CompanyInfo."Bank Name") { }
            column(CompanyBankAccNo; CompanyInfo."Bank Account No.") { }
            column(CompanyVATRegNo; CompanyInfo."VAT Registration No.") { }
            column(CompanyRegNo; CompanyInfo."Registration No.") { }
            column(CompanySwiftCode; CompanyInfo."SWIFT Code") { }
            column(CustContactNo; CustContactNo) { }
            column(Amount_Including_VAT; "Amount Including VAT") { }
            column(Amount; Amount) { }
            column(VATAmount; VATAmount) { }
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
        CustContactNo: Text[100];
        ShipAgentName: Text[100];
        VATAmount: Decimal;
        VATPercent: Decimal;

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
}
report 60004 "Posted Rental Invoice"
{
    ApplicationArea = All;
    Caption = 'Posted Rental Invoice';
    UsageCategory = ReportsAndAnalysis;
    //RDLCLayout = 'Src/ReportLayouts/PostedRentalInvoice.rdlc';
    RDLCLayout = 'Src/Reports/PostedRentalInvoice/PostedRentalInvoice.rdlc';
    dataset
    {
        dataitem(SalesInvoiceHeader; "Sales Invoice Header")
        {
            RequestFilterFields = "No.";
            column(No_SalesInvoiceHeader; "No.") { }
            column(EQM_Contract_No_; "EQM Contract No.") { }
            column(Posting_Date; Format("Posting Date", 0, '<Day,2>-<Month>-<Year4>')) { }
            column(Due_Date; Format("Due Date", 0, '<Day,2>-<Month>-<Year4>')) { }
            column(VAT_Registration_No_; "VAT Registration No.") { }
            column(External_Document_No_; "External Document No.") { }
            column(Your_Reference; "Your Reference") { }
            column(Bill_to_Customer_No_; "Bill-to Customer No.") { }
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
            column(InVerhuurhdrText; InVerhuurHdrText) { }
            column(InVerhuurText; InVerhuurText) { }
            column(RentalFromDate_H; RentalFromDate) { }
            column(RentalToDate_H; RentalToDate) { }
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = where(Type = filter(Item | "G/L Account"));
                column(No_; "No.") { }
                column(Description; Description) { }
                column(EQM_Rental_Days; "EQM Rental Days") { }
                column(Unit_Price; "Unit Price") { }
                column(Line_Discount__; "Line Discount %") { }
                column(Line_Amount; "Line Amount") { }
                column(RentalFromDate; "EQM Rental From Date") { }
                column(RentalToDate; "EQM Rental To Date") { }
                column(VAT__; VATPercent) { }
                column(VAT_1; "VAT %") { }
                column(EQM_Rental_Quantity; "EQM Rental Quantity") { }
                column(EQM_Rental_From_Date; Format("EQM Rental From Date", 0, '<Day,2>-<Month>-<Year4>')) { }
                column(EQM_Rental_To_Date; Format("EQM Rental To Date", 0, '<Day,2>-<Month>-<Year4>')) { }
                column(I2I_External_Document_No_; "I2I External Document No.") { }
            }
            dataitem("EQM Rental Return Entry"; "EQM Rental Return Entry")
            {
                DataItemLink = "Contract No." = field("EQM Contract No.");
                DataItemTableView = sorting("Entry No.") where("Entry Type" = filter(Return | Shipment), Type = filter(Item));
                column(Contract_No_; "Contract No.") { }
                column(No_Return; "No.") { }
                column(Entry_Type; "Entry Type") { }
                column(Description_Return; Description) { }
                column(Quantity_Return; Quantity) { }
                column(I2I_External_Document_No_Return; "I2I External Document No.") { }
                column(Shipment_Date; Format("Shipment Date", 0, '<Day,2>-<Month>-<Year4>')) { }
                column(Return_Date; Format("Return Date", 0, '<Day,2>-<Month>-<Year4>')) { }
            }
            trigger OnAfterGetRecord()
            var
                Contact: Record Contact;
                Customer: Record Customer;
                ShippingAgent: Record "Shipping Agent";
                SalesInvLine: Record "Sales Invoice Line";
            begin
                Clear(RentalFromDate);
                Clear(RentalToDate);
                CalcFields("Amount Including VAT", Amount);
                ShipAddress(SalesInvoiceHeader);
                CustomerAddress(SalesInvoiceHeader);

                CompanyAddress();
                if Contact.Get(SalesInvoiceHeader."Bill-to Contact No.") then begin
                    ContactEmail := Contact."E-Mail";
                    ContactName := Contact.Name;
                end;
                if Customer.Get("Bill-to Customer No.") then begin
                    CustContactNo := Customer.Contact;
                end;
                if ShippingAgent.Get(SalesInvoiceHeader."Shipping Agent Code") then
                    ShipAgentName := ShippingAgent.Name;

                VATAmount := "Amount Including VAT" - Amount;


                SalesInvLine.SetRange("Document No.", "No.");
                SalesInvLine.SetFilter(Type, '%1 | %2', SalesInvLine.Type::Item, SalesInvLine.Type::"G/L Account");
                if SalesInvLine.FindSet() then
                    repeat
                        if (SalesInvLine."EQM Rental" = true) then begin
                            if (SalesInvLine."EQM Rental From Date" <> 0D) then
                                RentalFromDate := SalesInvLine."EQM Rental From Date";
                            if (SalesInvLine."EQM Rental To Date" <> 0D) then
                                RentalToDate := SalesInvLine."EQM Rental To Date";
                        end;
                    until SalesInvLine.Next() = 0;

                GetInVerhuurText(SalesInvoiceHeader);

                SalesInvLine.Reset();
                SalesInvLine.SetRange("Document No.", "No.");
                if SalesInvLine.FindSet() then
                    repeat
                        if (SalesInvLine.Type = SalesInvLine.Type::Item) OR
                           (SalesInvLine.Type = SalesInvLine.Type::"G/L Account") then begin
                            VATPercent := SalesInvLine."VAT %";
                            exit;
                        end;
                    until SalesInvLine.Next() = 0;
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
        TempReturnEntry: Record "EQM Rental Return Entry" temporary;
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
        RentalFromDate: Date;
        RentalToDate: Date;
        ItemDescription: Text[100];
        NetQuantity: Decimal;
        InVerhuurText: Text;
        InVerhuurHdrText: Text;

    procedure ShipAddress(SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        LineNo: Integer;
        Country: Record "Country/Region";
    begin
        LineNo := 1;

        // Name
        if SalesInvoiceHeader."Ship-to Name" <> '' then begin
            ShipToAddr[LineNo] := SalesInvoiceHeader."Ship-to Name";
            LineNo += 1;
        end;

        // Name 2
        if SalesInvoiceHeader."Ship-to Name 2" <> '' then begin
            ShipToAddr[LineNo] := SalesInvoiceHeader."Ship-to Name 2";
            LineNo += 1;
        end;

        // Address 1
        if SalesInvoiceHeader."Ship-to Address" <> '' then begin
            ShipToAddr[LineNo] := SalesInvoiceHeader."Ship-to Address";
            LineNo += 1;
        end;

        // Address 2
        if SalesInvoiceHeader."Ship-to Address 2" <> '' then begin
            ShipToAddr[LineNo] := SalesInvoiceHeader."Ship-to Address 2";
            LineNo += 1;
        end;

        // Post Code + City (combined)
        if (SalesInvoiceHeader."Ship-to Post Code" <> '') or (SalesInvoiceHeader."Ship-to City" <> '') then begin
            ShipToAddr[LineNo] := SalesInvoiceHeader."Ship-to Post Code" + ' ' + SalesInvoiceHeader."Ship-to City";
            LineNo += 1;
        end;

        // County
        if SalesInvoiceHeader."Ship-to County" <> '' then begin
            ShipToAddr[LineNo] := SalesInvoiceHeader."Ship-to County";
            LineNo += 1;
        end;

        // Country
        if SalesInvoiceHeader."Ship-to Country/Region Code" <> '' then begin
            Country.Get(SalesInvoiceHeader."Ship-to Country/Region Code");
            ShipToAddr[LineNo] := Country.Name;
        end;
    end;

    procedure CustomerAddress(SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        LineNo: Integer;
        Customer: Record Customer;
        Country: Record "Country/Region";
    begin
        LineNo := 1;

        if not Customer.Get(SalesInvoiceHeader."Bill-to Customer No.") then
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
            Country.Get(SalesInvoiceHeader."Ship-to Country/Region Code");
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

    procedure GetInVerhuurText(PostRentalInvoice: Record "Sales Invoice Header")
    var
        RentalLine: Record "EQM Rental Line";
    begin
        Clear(InVerhuurText);
        Clear(InVerhuurHdrText);
        RentalLine.SetRange("Contract Type", RentalLine."Contract Type"::Contract);
        RentalLine.SetRange("Contract No.", PostRentalInvoice."EQM Contract No.");
        RentalLine.SetRange(Type, RentalLine.Type::Item);
        if RentalLine.FindSet() then begin
            repeat
                RentalLine.CalcFields("Quantity Return Net (Flow)");
                NetQuantity := RentalLine."Quantity Return Net (Flow)";
                if NetQuantity > 0 then begin
                    InVerhuurText += Format(NetQuantity) + ' ' + RentalLine.Description + '\';
                end;
            until RentalLine.Next() = 0;
        end;

        if InVerhuurText <> '' then
            InVerhuurHdrText := 'In verhuur per ' + Format(RentalToDate) + ' :';
    end;
}
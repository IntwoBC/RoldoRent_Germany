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
            column(CompanyPhoneNo; CompanyInfo."Phone No.") { }
            column(CompanyEmail; CompanyInfo."E-Mail") { }
            column(CompanyHomePage; CompanyInfo."Home Page") { }
            column(CompanyBankName; CompanyInfo."Bank Name") { }
            column(CompanyBankAccNo; CompanyInfo."Bank Account No.") { }
            column(CompanyVATRegNo; CompanyInfo."VAT Registration No.") { }
            column(CompanyRegNo; CompanyInfo."Registration No.") { }
            column(CompanySwiftCode; CompanyInfo."SWIFT Code") { }
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
                Contact: Record Contact;
                Customer: Record Customer;
                ShippingAgent: Record "Shipping Agent";
                SalesInvLine: Record "Sales Invoice Line";
                SalesPerson: Record "Salesperson/Purchaser";
            begin
                OutBoundText := GetOutboundMemoL(EQMRentalHeader);
                ShipAddress(EQMRentalHeader);
                CustomerAddress(EQMRentalHeader);
                CompanyAddress();
                // if Contact.Get(EQMRentalHeader."Customer No.") then begin
                //     ContactEmail := Contact."E-Mail";
                //     ContactName := Contact.Name;
                // end;
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
        OutBoundText: Text;


    procedure ShipAddress(RentalHeader: Record "EQM Rental Header")
    var
        LineNo: Integer;
        Country: Record "Country/Region";
    begin
        LineNo := 1;

        // Name
        if RentalHeader."Ship-to Name" <> '' then begin
            ShipToAddr[LineNo] := RentalHeader."Ship-to Name";
            LineNo += 1;
        end;

        // Name 2
        if RentalHeader."Ship-to Name 2" <> '' then begin
            ShipToAddr[LineNo] := RentalHeader."Ship-to Name 2";
            LineNo += 1;
        end;

        // Address 1
        if RentalHeader."Ship-to Address" <> '' then begin
            ShipToAddr[LineNo] := RentalHeader."Ship-to Address";
            LineNo += 1;
        end;

        // Address 2
        if RentalHeader."Ship-to Address 2" <> '' then begin
            ShipToAddr[LineNo] := RentalHeader."Ship-to Address 2";
            LineNo += 1;
        end;

        // Post Code + City (combined)
        if (RentalHeader."Ship-to Post Code" <> '') or (RentalHeader."Ship-to-City" <> '') then begin
            ShipToAddr[LineNo] := RentalHeader."Ship-to Post Code" + ' ' + RentalHeader."Ship-to-City";
            LineNo += 1;
        end;

        // County
        if RentalHeader."Ship-to County" <> '' then begin
            ShipToAddr[LineNo] := RentalHeader."Ship-to County";
            LineNo += 1;
        end;

        // Country
        if RentalHeader."Ship-to Country/Region Code" <> '' then begin
            Country.Get(RentalHeader."Ship-to Country/Region Code");
            ShipToAddr[LineNo] := Country.Name;
        end;
    end;

    procedure CustomerAddress(RentalHeader: Record "EQM Rental Header")
    var
        LineNo: Integer;
        Customer: Record Customer;
        Country: Record "Country/Region";
        Location: Record Location;
    begin
        LineNo := 1;

        if not Location.Get(RentalHeader."Location Code") then
            exit;

        // Name
        if Location.Name <> '' then begin
            CustAddr[LineNo] := Location.Name;
            LineNo += 1;
        end;

        // Name 2
        if Location."Name 2" <> '' then begin
            CustAddr[LineNo] := Location."Name 2";
            LineNo += 1;
        end;

        // Address 1
        if Location.Address <> '' then begin
            CustAddr[LineNo] := Location.Address;
            LineNo += 1;
        end;

        // Address 2
        if Location."Address 2" <> '' then begin
            CustAddr[LineNo] := Location."Address 2";
            LineNo += 1;
        end;

        // Post Code + City
        if (Location."Post Code" <> '') or (Location.City <> '') then begin
            CustAddr[LineNo] := Location."Post Code" + ' ' + Location.City;
            LineNo += 1;
        end;

        // County
        if Location.County <> '' then begin
            CustAddr[LineNo] := Location.County;
            LineNo += 1;
        end;

        // Country
        if Location."Country/Region Code" <> '' then begin
            Country.Get(Location."Country/Region Code");
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

    local procedure GetOutboundMemoL(var RentalHeader: Record "EQM Rental Header"): Text
    var
        InS: InStream;
        TempText: Text;
        LineText: Text;
        NewLine: Text[4];
    begin
        //NewLine := '\r\n';

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
}
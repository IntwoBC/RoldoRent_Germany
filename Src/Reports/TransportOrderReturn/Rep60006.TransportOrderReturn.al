report 60006 "Transport Order Return"
{
    ApplicationArea = All;
    Caption = 'Transport Order Return';
    UsageCategory = ReportsAndAnalysis;
    //RDLCLayout = 'Src/ReportLayouts/TransportOrderReturn.rdlc';
    RDLCLayout = 'Src/Reports/TransportOrderReturn/TransportOrderReturn.rdlc';
    dataset
    {
        dataitem(EQMRentalDispatchHeader; "EQM Rental Dispatch Header")
        {
            RequestFilterFields = "No.";
            column(No_; "No.") { }
            column(Contract_No_; ContractNo) { }
            column(CustomerNo; "Customer No.") { }
            column(Customer_Name; "Customer Name") { }
            column(Posting_Date; Format("Posting Date", 0, '<Day,2>-<Month>-<Year4>')) { }
            column(Off_Rent_Date; Format("Off-Rent Date", 0, '<Day,2>-<Month>-<Year4>')) { }
            column(Ship_to_Contact; "Ship-to Contact") { }
            column(I2I_Contact_No_; "I2I Contact No.") { }
            column(Customer_Project; "Customer Project") { }
            column(OutBoundText; OutBoundText) { }
            column(CustContactNo; CustContactNo) { }
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
            column(CompanyPhoneNo; CompanyPhoneNo) { }
            column(CompanyEmail; CompanyEmail) { }
            column(CompanyHomePage; CompanyHomePage) { }
            column(CompanyBankName; CompanyInfo."Bank Name") { }
            column(CompanyBankAccNo; CompanyInfo."Bank Account No.") { }
            column(CompanyVATRegNo; CompanyInfo."VAT Registration No.") { }
            column(CompanyRegNo; CompanyInfo."Registration No.") { }
            column(CompanySwiftCode; CompanyInfo."SWIFT Code") { }
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
                column(ItemWeight; ItemWeight) { }
                trigger OnPreDataItem()
                begin
                    SetRange("Line Type", "Line Type"::" ");
                    SetFilter(Quantity, '>0');
                end;

                trigger OnAfterGetRecord()
                var
                    Item: Record Item;
                begin
                    Clear(ItemWeight);
                    if Item.Get("No.") then
                        ItemWeight += Item."Net Weight" * "Qty. to Collect";
                end;
            }
            trigger OnAfterGetRecord()
            var
                Contact: Record Contact;
                Customer: Record Customer;
                ShippingAgent: Record "Shipping Agent";
                SalesInvLine: Record "Sales Invoice Line";
                SalesPerson: Record "Salesperson/Purchaser";
                RentalDispLines: Record "EQM Rental Dispatch Line";
            begin
                OutBoundText := GetOutboundMemoL(EQMRentalDispatchHeader);

                ShipAddress(EQMRentalDispatchHeader);
                CustomerAddress(EQMRentalDispatchHeader);
                CompanyAddress();
                UpdatePhEmailHP(EQMRentalDispatchHeader);

                if Customer.Get("Customer No.") then begin
                    CustContactNo := Customer.Contact;
                end;
                if ShippingAgent.Get(EQMRentalDispatchHeader."Shipping Agent Code") then
                    ShipAgentName := ShippingAgent.Name;
                if SalesPerson.Get("Salesperson Code") then begin
                    ContactName := SalesPerson.Name;
                    ContactEmail := SalesPerson."E-Mail";
                end;

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
        CompanyPhoneNo: Text[100];
        CompanyEmail: Text[100];
        CompanyHomePage: Text[100];
        CustContactNo: Text[100];
        ShipAgentName: Text[100];
        VATAmount: Decimal;
        VATPercent: Decimal;
        RentalFromDate: Date;
        RentalToDate: Date;
        OutBoundText: Text[2048];
        ContractNo: Text[100];
        ItemWeight: Decimal;



    procedure ShipAddress(EQMRentalDispatchHeader: Record "EQM Rental Dispatch Header")
    var
        LineNo: Integer;
        Country: Record "Country/Region";
    begin
        LineNo := 1;

        // Name
        if EQMRentalDispatchHeader."Ship-to Name" <> '' then begin
            ShipToAddr[LineNo] := EQMRentalDispatchHeader."Ship-to Name";
            LineNo += 1;
        end;

        // Name 2
        if EQMRentalDispatchHeader."Ship-to Name 2" <> '' then begin
            ShipToAddr[LineNo] := EQMRentalDispatchHeader."Ship-to Name 2";
            LineNo += 1;
        end;

        // Address 1
        if EQMRentalDispatchHeader."Ship-to Address" <> '' then begin
            ShipToAddr[LineNo] := EQMRentalDispatchHeader."Ship-to Address";
            LineNo += 1;
        end;

        // Address 2
        if EQMRentalDispatchHeader."Ship-to Address 2" <> '' then begin
            ShipToAddr[LineNo] := EQMRentalDispatchHeader."Ship-to Address 2";
            LineNo += 1;
        end;

        // Post Code + City (combined)
        if (EQMRentalDispatchHeader."Ship-to Post Code" <> '') or (EQMRentalDispatchHeader."Ship-to-City" <> '') then begin
            ShipToAddr[LineNo] := EQMRentalDispatchHeader."Ship-to Post Code" + ' ' + EQMRentalDispatchHeader."Ship-to-City";
            LineNo += 1;
        end;

        // County
        if EQMRentalDispatchHeader."Ship-to County" <> '' then begin
            ShipToAddr[LineNo] := EQMRentalDispatchHeader."Ship-to County";
            LineNo += 1;
        end;

        // Country
        if EQMRentalDispatchHeader."Ship-to Country/Region Code" <> '' then begin
            Country.Get(EQMRentalDispatchHeader."Ship-to Country/Region Code");
            ShipToAddr[LineNo] := Country.Name;
        end;
    end;

    local procedure GetOutboundMemoL(var RentalHeader: Record "EQM Rental Dispatch Header"): Text
    var
        InS: InStream;
        TempText: Text;
        LineText: Text;
        NewLine: Text[4];
    begin
        //NewLine := '\r\n';

        RentalHeader.CalcFields("Inbound Memo Text");

        if RentalHeader."Inbound Memo Text".HasValue then begin
            RentalHeader."Inbound Memo Text".CreateInStream(InS);

            while not InS.EOS do begin
                InS.ReadText(LineText);
                TempText += LineText;
            end;
        end;

        exit(TempText);
    end;

    procedure CustomerAddress(EQMRentalDispatchHeader: Record "EQM Rental Dispatch Header")
    var
        LineNo: Integer;
        Customer: Record Customer;
        Country: Record "Country/Region";
        Location: Record Location;
    begin
        LineNo := 1;

        if not Location.Get(EQMRentalDispatchHeader."Receiving Location Code") then
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

    procedure UpdatePhEmailHP(RentalDispHdr: Record "EQM Rental Dispatch Header")
    var
        Customer: Record Customer;
        CustomerPosting: Record "Customer Posting Group";
        CompanyInfoL: Record "Company Information";
    begin
        CompanyInfoL.Get();

        CompanyPhoneNo := CompanyInfoL."Phone No.";
        CompanyEmail := CompanyInfoL."E-Mail";
        CompanyHomePage := CompanyInfoL."Home Page";

        if not Customer.Get(RentalDispHdr."Customer No.") then
            exit;

        if not CustomerPosting.Get(Customer."Customer Posting Group") then
            exit;

        if (CustomerPosting.Code = 'AUSTRIA') or (CustomerPosting.Description = 'AUSTRIA') then begin
            CompanyPhoneNo := CompanyInfoL."I2I Phone No. AT";
            CompanyEmail := CompanyInfoL."I2I Email AT";
            CompanyHomePage := CompanyInfoL."I2I Home Page AT";
        end else
            if (CustomerPosting.Code = 'SCHWEIZ') or (CustomerPosting.Description = 'SCHWEIZ') then begin
                CompanyPhoneNo := CompanyInfoL."I2I Phone No. CH";
                CompanyEmail := CompanyInfoL."I2I Email CH";
                CompanyHomePage := CompanyInfoL."I2I Home Page CH";
            end;
    end;
}
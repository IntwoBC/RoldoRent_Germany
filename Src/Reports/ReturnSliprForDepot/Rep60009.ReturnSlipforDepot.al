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
                Contact: Record Contact;
                ShipmentAgent: Record "Shipping Agent";
                SalesPerson: Record "Salesperson/Purchaser";
                RentalDispLines: Record "EQM Rental Dispatch Line";
            begin
                OutBoundText := GetOutboundMemoL("EQM Rental Dispatch Header");
                ShipAddress("EQM Rental Dispatch Header");
                DepotAddress("EQM Rental Dispatch Header");
                CompanyAddress();
                UpdateFooterData("EQM Rental Dispatch Header");
                GetHomePageFromLocation("EQM Rental Dispatch Header"."Location Code");


                if SalesPerson.Get("Salesperson Code") then begin
                    ContactName := SalesPerson.Name;
                    ContactEmail := SalesPerson."E-Mail";
                end;

                if ShipmentAgent.Get("EQM Rental Dispatch Header"."Shipping Agent Code") then
                    ShipmentAgentName := ShipmentAgent.Name;

                RentalDispLines.SetRange("Document No.", "EQM Rental Dispatch Header"."No.");
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
        OutBoundText: Text;
        ShipmentAgentName: Text[100];
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
        ContractNo: Text[100];
        OpeningHours: Text[100];
        OpeningHoursLbl: Label 'Öffnungszeiten';

    procedure ShipAddress(RentalColHeader: Record "EQM Rental Dispatch Header")
    var
        LineNo: Integer;
        Country: Record "Country/Region";
    begin
        LineNo := 1;
        // Name
        if RentalColHeader."Ship-to Name" <> '' then begin
            ShipToAddr[LineNo] := RentalColHeader."Ship-to Name";
            LineNo += 1;
        end;
        // Name 2
        if RentalColHeader."Ship-to Name 2" <> '' then begin
            ShipToAddr[LineNo] := RentalColHeader."Ship-to Name 2";
            LineNo += 1;
        end;
        // Address 1
        if RentalColHeader."Ship-to Address" <> '' then begin
            ShipToAddr[LineNo] := RentalColHeader."Ship-to Address";
            LineNo += 1;
        end;
        // Address 2
        if RentalColHeader."Ship-to Address 2" <> '' then begin
            ShipToAddr[LineNo] := RentalColHeader."Ship-to Address 2";
            LineNo += 1;
        end;
        // Post Code + City (combined)
        if (RentalColHeader."Ship-to Post Code" <> '') or (RentalColHeader."Ship-to-City" <> '') then begin
            ShipToAddr[LineNo] := RentalColHeader."Ship-to Post Code" + ' ' + RentalColHeader."Ship-to-City";
            LineNo += 1;
        end;
        // Country
        if RentalColHeader."Ship-to Country/Region Code" <> '' then begin
            Country.Get(RentalColHeader."Ship-to Country/Region Code");
            ShipToAddr[LineNo] := Country.Name;
        end;
    end;

    local procedure GetOutboundMemoL(var RentalColHeader: Record "EQM Rental Dispatch Header"): Text
    var
        InS: InStream;
        TempText: Text;
        LineText: Text;
        NewLine: Text[4];
    begin
        //NewLine := '\r\n';
        RentalColHeader.CalcFields("Inbound Memo Text");
        if RentalColHeader."Inbound Memo Text".HasValue then begin
            RentalColHeader."Inbound Memo Text".CreateInStream(InS);
            while not InS.EOS do begin
                InS.ReadText(LineText);
                TempText += LineText;
            end;
        end;
        exit(TempText);
    end;

    procedure DepotAddress(RentalColHeader: Record "EQM Rental Dispatch Header")
    var
        LineNo: Integer;
        Customer: Record Customer;
        Country: Record "Country/Region";
        Location: Record Location;
    begin
        LineNo := 1;
        if not Location.Get(RentalColHeader."Receiving Location Code") then
            exit;
        if Location.Name <> '' then begin
            CustAddr[LineNo] := Location.Name;
            LineNo += 1;
        end;
        if Location."Name 2" <> '' then begin
            CustAddr[LineNo] := Location."Name 2";
            LineNo += 1;
        end;
        if Location.Address <> '' then begin
            CustAddr[LineNo] := Location.Address;
            LineNo += 1;
        end;
        if Location."Address 2" <> '' then begin
            CustAddr[LineNo] := Location."Address 2";
            LineNo += 1;
        end;
        if (Location."Post Code" <> '') or (Location.City <> '') then begin
            CustAddr[LineNo] := Location."Post Code" + ' ' + Location.City;
            LineNo += 1;
        end;
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
        // Country
        if CompanyInfoL."Country/Region Code" <> '' then begin
            Country.Get(CompanyInfoL."Country/Region Code");
            CompanyAddr[LineNo] := Country.Name;
        end;
    end;

    procedure UpdateFooterData(RentalColOrder: Record "EQM Rental Dispatch Header")
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

        if not Customer.Get(RentalColOrder."Customer No.") then
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
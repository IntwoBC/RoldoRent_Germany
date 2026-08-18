namespace RoldoRentGermany.RoldoRentGermany;
using Microsoft.Foundation.Address;
using Microsoft.Sales.Document;
using System.Utilities;
using Microsoft.Sales.Customer;
using Microsoft.Inventory.Location;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Sales.History;
using Microsoft.Foundation.Company;
using System.Globalization;

codeunit 60007 "I2I Report Helper"
{
    procedure CompanyAddress(var CompanyAddress: array[8] of Text[100])
    var
        LineNo: Integer;
        CompanyInfoL: Record "Company Information";
        Country: Record "Country/Region";
    begin
        LineNo := 1;

        CompanyInfoL.Get();

        // Name
        if CompanyInfoL.Name <> '' then begin
            CompanyAddress[LineNo] := CompanyInfoL.Name;
            LineNo += 1;
        end;

        // Name 2
        if CompanyInfoL."Name 2" <> '' then begin
            CompanyAddress[LineNo] := CompanyInfoL."Name 2";
            LineNo += 1;
        end;

        // Address 1
        if CompanyInfoL.Address <> '' then begin
            CompanyAddress[LineNo] := CompanyInfoL.Address;
            LineNo += 1;
        end;

        // Address 2
        if CompanyInfoL."Address 2" <> '' then begin
            CompanyAddress[LineNo] := CompanyInfoL."Address 2";
            LineNo += 1;
        end;

        // Post Code + City
        if (CompanyInfoL."Post Code" <> '') or (CompanyInfoL.City <> '') then begin
            CompanyAddress[LineNo] := CompanyInfoL."Post Code" + ' ' + CompanyInfoL.City;
            LineNo += 1;
        end;

        // Country
        if CompanyInfoL."Country/Region Code" <> '' then begin
            Country.Get(CompanyInfoL."Country/Region Code");
            CompanyAddress[LineNo] := Country.Name;
        end;
    end;

    procedure GetAddressData(RecRef: RecordRef; var ShipAddress: array[8] of Text[100]; var BillAddress: array[8] of Text[100]; var CustAddressArr: array[8] of Text[100])
    var
        RentalCollectionOrder: Record "EQM Rental Dispatch Header";
        RentalHeader: Record "EQM Rental Header";
        SalesCrMemo: Record "Sales Cr.Memo Header";
        SalesInvHdr: Record "Sales Invoice Header";
        SalesHdr: Record "Sales Header";
    begin
        case RecRef.Number of
            Database::"EQM Rental Dispatch Header":
                begin
                    RecRef.SetTable(RentalCollectionOrder);
                    SetAddress(ShipAddress, RentalCollectionOrder."Ship-to Name", RentalCollectionOrder."Ship-to Name 2",
                        RentalCollectionOrder."Ship-to Address", RentalCollectionOrder."Ship-to Address 2",
                        RentalCollectionOrder."Ship-to Post Code", RentalCollectionOrder."Ship-to-City",
                        RentalCollectionOrder."Ship-to Country/Region Code");
                    SetAddress(BillAddress, RentalCollectionOrder."Ship-to Name", RentalCollectionOrder."Ship-to Name 2",
                        RentalCollectionOrder."Ship-to Address", RentalCollectionOrder."Ship-to Address 2",
                        RentalCollectionOrder."Ship-to Post Code", RentalCollectionOrder."Ship-to-City",
                        RentalCollectionOrder."Ship-to Country/Region Code");
                    CustomerAddress(CustAddressArr, RentalCollectionOrder."Customer No.");
                end;
            Database::"Sales Cr.Memo Header":
                begin
                    RecRef.SetTable(SalesCrMemo);
                    SetAddress(ShipAddress, SalesCrMemo."Ship-to Name", SalesCrMemo."Ship-to Name 2",
                        SalesCrMemo."Ship-to Address", SalesCrMemo."Ship-to Address 2",
                        SalesCrMemo."Ship-to Post Code", SalesCrMemo."Ship-to City",
                        SalesCrMemo."Ship-to Country/Region Code");
                    SetAddress(BillAddress, SalesCrMemo."Ship-to Name", SalesCrMemo."Ship-to Name 2",
                        SalesCrMemo."Ship-to Address", SalesCrMemo."Ship-to Address 2",
                        SalesCrMemo."Ship-to Post Code", SalesCrMemo."Ship-to City",
                        SalesCrMemo."Ship-to Country/Region Code");
                    CustomerAddress(CustAddressArr, SalesCrMemo."Bill-to Customer No.");
                end;
            Database::"EQM Rental Header":
                begin
                    RecRef.SetTable(RentalHeader);
                    SetAddress(ShipAddress, RentalHeader."Ship-to Name", RentalHeader."Ship-to Name 2",
                        RentalHeader."Ship-to Address", RentalHeader."Ship-to Address 2",
                        RentalHeader."Ship-to Post Code", RentalHeader."Ship-to-City",
                        RentalHeader."Ship-to Country/Region Code");
                    SetAddress(BillAddress, RentalHeader."Ship-to Name", RentalHeader."Ship-to Name 2",
                        RentalHeader."Ship-to Address", RentalHeader."Ship-to Address 2",
                        RentalHeader."Ship-to Post Code", RentalHeader."Ship-to-City",
                        RentalHeader."Ship-to Country/Region Code");
                    CustomerAddress(CustAddressArr, RentalHeader."Bill-to Customer No.");
                end;
            Database::"Sales Invoice Header":
                begin
                    RecRef.SetTable(SalesInvHdr);

                    SetAddress(
                        ShipAddress,
                        SalesInvHdr."Ship-to Name",
                        SalesInvHdr."Ship-to Name 2",
                        SalesInvHdr."Ship-to Address",
                        SalesInvHdr."Ship-to Address 2",
                        SalesInvHdr."Ship-to Post Code",
                        SalesInvHdr."Ship-to City",
                        SalesInvHdr."Ship-to Country/Region Code");
                    SetAddress(
                        BillAddress,
                        SalesInvHdr."Bill-to Name",
                        SalesInvHdr."Bill-to Name 2",
                        SalesInvHdr."Bill-to Address",
                        SalesInvHdr."Bill-to Address 2",
                        SalesInvHdr."Bill-to Post Code",
                        SalesInvHdr."Bill-to City",
                        SalesInvHdr."Bill-to Country/Region Code");
                    CustomerAddress(CustAddressArr, SalesInvHdr."Bill-to Customer No.");
                end;
            Database::"Sales Header":
                begin
                    RecRef.SetTable(SalesHdr);
                    SetAddress(
                        ShipAddress,
                        SalesHdr."Ship-to Name",
                        SalesHdr."Ship-to Name 2",
                        SalesHdr."Ship-to Address",
                        SalesHdr."Ship-to Address 2",
                        SalesHdr."Ship-to Post Code",
                        SalesHdr."Ship-to City",
                        SalesHdr."Ship-to Country/Region Code");
                    SetAddress(
                        BillAddress,
                        SalesHdr."Bill-to Name",
                        SalesHdr."Bill-to Name 2",
                        SalesHdr."Bill-to Address",
                        SalesHdr."Bill-to Address 2",
                        SalesHdr."Bill-to Post Code",
                        SalesHdr."Bill-to City",
                        SalesHdr."Bill-to Country/Region Code");
                    CustomerAddress(CustAddressArr, SalesHdr."Bill-to Customer No.");
                end;
        end;
    end;

    procedure GetShipAddressData(RecRef: RecordRef; var ShipAddress: array[8] of Text[100])
    var
        UnusedBillAddress: array[8] of Text[100];
        UnusedCustomerAddress: array[8] of Text[100];
    begin
        GetAddressData(RecRef, ShipAddress, UnusedBillAddress, UnusedCustomerAddress);
    end;

    procedure GetShipAndCustomerAddressData(RecRef: RecordRef; var ShipAddress: array[8] of Text[100]; var CustAddressArr: array[8] of Text[100])
    var
        UnusedBillAddress: array[8] of Text[100];
    begin
        GetAddressData(RecRef, ShipAddress, UnusedBillAddress, CustAddressArr);
    end;

    procedure GetShipAndBillAddressData(RecRef: RecordRef; var ShipAddress: array[8] of Text[100]; var BillAddress: array[8] of Text[100])
    var
        UnusedCustomerAddress: array[8] of Text[100];
    begin
        GetAddressData(RecRef, ShipAddress, BillAddress, UnusedCustomerAddress);
    end;

    local procedure SetAddress(var AddressArray: array[8] of Text[100]; Name: Text[100]; Name2: Text[100];
    Address1: Text[100]; Address2: Text[100]; PostCode: Code[20]; City: Text[30]; CountryCode: Code[10])
    var
        Country: Record "Country/Region";
        LineNo: Integer;
    begin
        LineNo := 1;

        if Name <> '' then begin
            AddressArray[LineNo] := Name;
            LineNo += 1;
        end;

        if Name2 <> '' then begin
            AddressArray[LineNo] := Name2;
            LineNo += 1;
        end;

        if Address1 <> '' then begin
            AddressArray[LineNo] := Address1;
            LineNo += 1;
        end;

        if Address2 <> '' then begin
            AddressArray[LineNo] := Address2;
            LineNo += 1;
        end;

        if (PostCode <> '') or (City <> '') then begin
            AddressArray[LineNo] := PostCode + ' ' + City;
            LineNo += 1;
        end;

        if CountryCode <> '' then
            if Country.Get(CountryCode) then
                AddressArray[LineNo] := Country.Name;
    end;

    procedure CustomerAddress(var CustAddress: array[8] of Text[100]; CustomerNo: Code[20])
    var
        LineNo: Integer;
        Customer: Record Customer;
        Country: Record "Country/Region";
    begin
        LineNo := 1;

        if not Customer.Get(CustomerNo) then
            exit;

        if Customer.Name <> '' then begin
            CustAddress[LineNo] := Customer.Name;
            LineNo += 1;
        end;

        if Customer."Name 2" <> '' then begin
            CustAddress[LineNo] := Customer."Name 2";
            LineNo += 1;
        end;

        if Customer.Address <> '' then begin
            CustAddress[LineNo] := Customer.Address;
            LineNo += 1;
        end;

        if Customer."Address 2" <> '' then begin
            CustAddress[LineNo] := Customer."Address 2";
            LineNo += 1;
        end;

        if (Customer."Post Code" <> '') or (Customer.City <> '') then begin
            CustAddress[LineNo] := Customer."Post Code" + ' ' + Customer.City;
            LineNo += 1;
        end;

        if Customer."Country/Region Code" <> '' then
            if Country.Get(Customer."Country/Region Code") then
                CustAddress[LineNo] := Country.Name;
    end;

    local procedure GetCompanyRegionCode(CustomerNo: Code[20]): Text[10]
    var
        Customer: Record Customer;
        CustomerPosting: Record "Customer Posting Group";
    begin
        if CustomerNo = '' then
            exit('');

        if not Customer.Get(CustomerNo) then
            exit('');

        if not CustomerPosting.Get(Customer."Customer Posting Group") then
            exit('');

        if (CustomerPosting.Code = 'AUSTRIA') or (CustomerPosting.Description = 'AUSTRIA') then
            exit('AT');

        if (CustomerPosting.Code = 'SCHWEIZ') or (CustomerPosting.Description = 'SCHWEIZ') then
            exit('CH');

        exit('');
    end;

    procedure UpdateFooterData(CustomerNo: Code[20];
        var CompanyNameTxt: Text[100]; var CompanyAddressTxt: Text[100]; var CompanyCityTxt: Text[100];
        var CompanyPhoneNo: Text[100]; var CompanyEmail: Text[100]; var CompanyHomePage: Text[100];
        var CompanyRegNo: Text[100]; var CompanyContactPerson: Text[100];
        var CompanyBankName: Text[100]; var CompanyBankAccNo: Text[100]; var CompanySwiftCode: Text[100])
    var
        CompanyInfoL: Record "Company Information";
        RegionCode: Text[10];
    begin
        CompanyInfoL.Get();

        CompanyNameTxt := CompanyInfoL.Name;
        CompanyAddressTxt := CompanyInfoL.Address;
        if CompanyInfoL."Address 2" <> '' then
            CompanyAddressTxt += ', ' + CompanyInfoL."Address 2";

        if (CompanyInfoL."Post Code" <> '') or (CompanyInfoL.City <> '') then
            CompanyCityTxt := CompanyInfoL."Post Code" + ' ' + CompanyInfoL.City;

        CompanyPhoneNo := CompanyInfoL."Phone No.";
        CompanyEmail := CompanyInfoL."E-Mail";
        CompanyHomePage := CompanyInfoL."Home Page";
        CompanyRegNo := CompanyInfoL."Registration No.";
        CompanyContactPerson := CompanyInfoL."Contact Person";
        CompanyBankName := CompanyInfoL."Bank Name";
        CompanyBankAccNo := CompanyInfoL."Bank Account No.";
        CompanySwiftCode := CompanyInfoL."SWIFT Code";

        RegionCode := GetCompanyRegionCode(CustomerNo);

        case RegionCode of
            'AT':
                begin
                    CompanyPhoneNo := CompanyInfoL."I2I Phone No. AT";
                    CompanyEmail := CompanyInfoL."I2I Email AT";
                    CompanyHomePage := CompanyInfoL."I2I Home Page AT";
                    CompanyRegNo := CompanyInfoL."I2I Company Reg No. AT";
                    CompanyContactPerson := CompanyInfoL."I2I Contact Person AT";
                    CompanyBankName := CompanyInfoL."I2I Bank Name AT";
                    CompanyBankAccNo := CompanyInfoL."I2I Bank Acc. No. AT";
                    CompanySwiftCode := CompanyInfoL."I2I Swift AT";
                end;
            'CH':
                begin
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
    end;

        procedure UpdateCompanyReportData(CustomerNo: Code[20]; OpeningHoursLocationCode: Code[20];
            var CompanyAddressArr: array[8] of Text[100];
            var CompanyNameTxt: Text[100]; var CompanyAddressTxt: Text[100]; var CompanyCityTxt: Text[100];
            var CompanyPhoneNo: Text[100]; var CompanyEmail: Text[100]; var CompanyHomePage: Text[100];
            var CompanyRegNo: Text[100]; var CompanyContactPerson: Text[100];
            var CompanyBankName: Text[100]; var CompanyBankAccNo: Text[100]; var CompanySwiftCode: Text[100];
            var OpeningHours: Text[100])
        begin
            CompanyAddress(CompanyAddressArr);
            UpdateFooterData(
                CustomerNo,
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
                CompanySwiftCode);
            OpeningHours := GetHomePageFromLocation(OpeningHoursLocationCode);
        end;

        procedure GetFirstDispatchContractNo(DocumentNo: Code[20]): Text[100]
        var
            RentalDispLine: Record "EQM Rental Dispatch Line";
        begin
            RentalDispLine.SetRange("Document No.", DocumentNo);
            if RentalDispLine.FindSet() then
                repeat
                    if RentalDispLine."Contract No." <> '' then
                        exit(RentalDispLine."Contract No.");
                until RentalDispLine.Next() = 0;
        end;

        procedure BuildTransportFooterTexts(DeliveryConfirmationDateLineLbl: Text; DeliveryConfirmationNameLineLbl: Text;
            DeliveryConfirmationSignatureLineLbl: Text; ContactInfoLbl: Text; TermsAndConditionsLbl: Text;
            CompanyPhoneNo: Text[100]; CompanyEmail: Text[100]; CompanyHomePage: Text[100];
            var DeliveryConfirmationTxt: Text[512]; var ContactInfoTxt: Text[512]; var TermsAndConditionsTxt: Text[250])
        var
            TextBuilder: TextBuilder;
        begin
            TextBuilder.AppendLine(DeliveryConfirmationDateLineLbl);
            TextBuilder.AppendLine(DeliveryConfirmationNameLineLbl);
            TextBuilder.Append(DeliveryConfirmationSignatureLineLbl);
            DeliveryConfirmationTxt := TextBuilder.ToText();

            ContactInfoTxt := StrSubstNo(ContactInfoLbl, CompanyPhoneNo, CompanyEmail);
            TermsAndConditionsTxt := StrSubstNo(TermsAndConditionsLbl, CompanyHomePage);
        end;

    procedure GetHomePageFromLocation(LocationCode: Code[20]) OpeningHours: Text[100]
    var
        LocationL: Record Location;
    begin
        if LocationL.Get(LocationCode) then
            OpeningHours := LocationL."Home Page";
    end;

    procedure AssignCurrencyCode(CurrencyCode: Code[20]; VATPercent: Decimal;
        TotalExclVATLbl: Text; TotalInclVATLbl: Text; TotalVATLbl: Text;
        var TotalExclVAT: Text[100]; var TotalInclVAT: Text[100]; var TotalVAT: Text[100])
    var
        GLSetup: Record "General Ledger Setup";
    begin
        if CurrencyCode = '' then begin
            GLSetup.Get();
            CurrencyCode := GLSetup."LCY Code";
        end;

        TotalExclVAT := StrSubstNo(TotalExclVATLbl, CurrencyCode);
        TotalVAT := StrSubstNo(TotalVATLbl, VATPercent);
        TotalInclVAT := StrSubstNo(TotalInclVATLbl, CurrencyCode);
    end;

    procedure GetReportLanguageId(DocumentLanguageCode: Code[10]; CustomerNo: Code[20]; DefaultLanguageCodeLbl: Code[10]): Integer
    var
        Customer: Record Customer;
        LanguageMgt: Codeunit Language;
        ResolvedLanguageCode: Code[10];
        LanguageId: Integer;
    begin
        ResolvedLanguageCode := DocumentLanguageCode;

        if (ResolvedLanguageCode = '') and (CustomerNo <> '') then
            if Customer.Get(CustomerNo) then
                ResolvedLanguageCode := Customer."Language Code";

        if ResolvedLanguageCode = '' then
            ResolvedLanguageCode := DefaultLanguageCodeLbl;

        if ResolvedLanguageCode = '' then
            exit(0);

        LanguageId := LanguageMgt.GetLanguageId(ResolvedLanguageCode);
        if (LanguageId = 0) and (DefaultLanguageCodeLbl <> '') and (ResolvedLanguageCode <> DefaultLanguageCodeLbl) then
            LanguageId := LanguageMgt.GetLanguageId(DefaultLanguageCodeLbl);

        exit(LanguageId);
    end;

    procedure GetShipToAddressFromLocation(LocationCode: Code[20]; var ShipAddress: array[8] of Text[100])
    var
        Location: Record Location;
        Country: Record "Country/Region";
        LineNo: Integer;
    begin
        LineNo := 1;
        if not Location.Get(LocationCode) then
            exit;

        // Name
        if Location.Name <> '' then begin
            ShipAddress[LineNo] := Location.Name;
            LineNo += 1;
        end;

        // Name 2
        if Location."Name 2" <> '' then begin
            ShipAddress[LineNo] := Location."Name 2";
            LineNo += 1;
        end;

        // Address 1
        if Location.Address <> '' then begin
            ShipAddress[LineNo] := Location.Address;
            LineNo += 1;
        end;

        // Address 2
        if Location."Address 2" <> '' then begin
            ShipAddress[LineNo] := Location."Address 2";
            LineNo += 1;
        end;

        // Post Code + City
        if (Location."Post Code" <> '') or (Location.City <> '') then begin
            ShipAddress[LineNo] := Location."Post Code" + ' ' + Location.City;
            LineNo += 1;
        end;

        // Country
        if Location."Country/Region Code" <> '' then
            if Country.Get(Location."Country/Region Code") then
                ShipAddress[LineNo] := Country.Name;
    end;

    procedure GetMemoTextFromBlob(RecRef: RecordRef; FieldNo: Integer): Text
    var
        TempBlob: Codeunit "Temp Blob";
        FldRef: FieldRef;
        InS: InStream;
        TempText: Text;
        LineText: Text;
    begin
        FldRef := RecRef.Field(FieldNo);
        FldRef.CalcField();

        if FldRef.Length() = 0 then
            exit('');

        TempBlob.FromFieldRef(FldRef);
        if not TempBlob.HasValue() then
            exit('');

        TempBlob.CreateInStream(InS);
        while not InS.EOS do begin
            InS.ReadText(LineText);
            TempText += LineText;
        end;
        exit(TempText);
    end;
}

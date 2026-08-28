namespace RoldoRent.RoldoRent;

using Microsoft.Sales.History;
using Microsoft.Finance.GeneralLedger.Setup;
using RoldoRentGermany.RoldoRentGermany;
using Microsoft.Sales.Setup;
using Microsoft.Foundation.Address;
using Microsoft.Sales.Customer;
using Microsoft.Foundation.Company;

report 60010 "I2I Combine Invoice"
{
    ApplicationArea = All;
    Caption = 'Combine Invoice';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'Src\Reports\CombineInvoice\CombineInvoice.rdl';
    dataset
    {
        dataitem(SalesInvoiceHeader; "Sales Invoice Header")
        {
            //RequestFilterFields = "Bill-to Customer No.", "No.", "Posting Date";
            column(No; "No.") { }
            column(EQMCombine_Customer_Proj; "EQMCombine Customer Proj") { }
            column(Bill_to_Customer_No_; "Bill-to Customer No.") { }
            column(Posting_Date; "Posting Date") { }
            //Customer Address
            column(CustomerAddress1; CustomerAddress[1]) { }
            column(CustomerAddress2; CustomerAddress[2]) { }
            column(CustomerAddress3; CustomerAddress[3]) { }
            column(CustomerAddress4; CustomerAddress[4]) { }
            column(CustomerAddress5; CustomerAddress[5]) { }
            column(CustomerAddress6; CustomerAddress[6]) { }
            column(CustomerAddress7; CustomerAddress[7]) { }
            column(CustomerAddress8; CustomerAddress[8]) { }
            //Amount Fields
            column(Amount; Round(Amount, 0.01, '=')) { }
            column(Amount_Including_VAT; Round("Amount Including VAT", 0.01, '=')) { }
            column(TotalLineAmount; Round(TotalLineAmount, 0.01, '=')) { }
            column(TotalInclAmount; Round(TotalInclAmount, 0.01, '=')) { }
            column(TotalAmount; Round(TotalAmount, 0.01, '=')) { }
            column(TotalVATAmount; Round(TotalVATAmount, 0.01, '=')) { }
            //Option Fields
            column(Referencetxt; Referencetxt) { }
            column(DatetoPrint; DatetoPrint) { }
            //Company Fields
            column(CompanyPicture; CompanyInformation.Picture) { }
            column(CompanyNametxt; CompanyNametxt) { }
            column(CompanyAddresstxt; CompanyAddresstxt) { }
            column(CompanyCitytxt; CompanyCitytxt) { }
            column(CompanyPhNo; CompanyPhNo) { }
            column(CompanyEmail; CompanyEmail) { }
            column(CompanyHP; CompanyHP) { }
            column(CompanyVATReg; CompanyVATReg) { }
            column(CompanyRegNo; CompanyRegNo) { }
            column(CompanyIBANCode; CompanyIBANCode) { }
            column(CompanySwiftCode; CompanySwiftCode) { }
            column(CompanyBankName; CompanyBankName) { }
            //Label Fields
            column(CombineInvLbl; CombineInvLbl) { }
            column(ReferenceLbl; ReferenceLbl) { }
            column(ProjectCodeLbl; ProjectCodeLbl) { }
            column(CustomerLbl; CustomerLbl) { }
            column(DateLbl; DateLbl) { }
            column(InvNoLbl; InvNoLbl) { }
            column(StartDateLbl; StartDateLbl) { }
            column(EndDateLbl; EndDateLbl) { }
            column(ProjectNoLbl; ProjectNoLbl) { }
            column(DescriptionLbl; DescriptionLbl) { }
            column(TotalLbl; TotalLbl) { }
            column(AmountLbl; AmountLbl) { }
            column(ExclVATLbl; ExclVATLblTxt) { }
            column(VATLbl; VATLblTxt) { }
            column(InclVATLbl; InclVATLblTxt) { }
            column(StartDate; StartDate) { }
            column(EndDate; EndDate) { }
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = field("No.");
                //DataItemTableView = where(Type = filter(Item | "G/L Account"));
                column(EQM_Rental_From_Date; "EQM Rental From Date") { }
                column(EQM_Rental_To_Date; "EQM Rental To Date") { }
                column(Description; Description) { }
                column(Line_Amount; Round("Line Amount", 0.01, '=')) { }
            }
            trigger OnPreDataItem()
            var
                NormalizedDocumentNoFilter: Text[250];
                RangeSeparatorPos: Integer;
                DocumentNoFrom: Code[20];
                DocumentNoTo: Code[20];
                TempDocumentNo: Code[20];
            begin
                if CustomerNoFilter <> '' then
                    SetRange("Bill-to Customer No.", CustomerNoFilter);
                if DocumentNoFilter <> '' then begin
                    NormalizedDocumentNoFilter := DelChr(DocumentNoFilter, '=', ' ');
                    RangeSeparatorPos := StrPos(NormalizedDocumentNoFilter, '..');
                    if RangeSeparatorPos > 0 then begin
                        DocumentNoFrom := CopyStr(NormalizedDocumentNoFilter, 1, RangeSeparatorPos - 1);
                        DocumentNoTo := CopyStr(NormalizedDocumentNoFilter, RangeSeparatorPos + 2);
                        if (DocumentNoFrom <> '') and (DocumentNoTo <> '') then begin
                            if DocumentNoFrom > DocumentNoTo then begin
                                TempDocumentNo := DocumentNoFrom;
                                DocumentNoFrom := DocumentNoTo;
                                DocumentNoTo := TempDocumentNo;
                            end;
                            SetRange("No.", DocumentNoFrom, DocumentNoTo);
                        end else
                            SetFilter("No.", NormalizedDocumentNoFilter);
                    end else
                        SetFilter("No.", NormalizedDocumentNoFilter);
                end;
                if PostingDateFilter <> '' then
                    SetFilter("Posting Date", PostingDateFilter);

                CalculateFilteredTotals(SalesInvoiceHeader);
            end;

            trigger OnAfterGetRecord()
            var
                ReportHelper: Codeunit "I2I Report Helper";
                RecRefL: RecordRef;
                UnusedShipAddress: array[8] of Text[100];
            begin
                RecRefL.GetTable(SalesInvoiceHeader);

                CalcFields(Amount, "Amount Including VAT");
                Clear(StartDate);
                Clear(EndDate);
                StartDateValue := 0D;
                EndDateValue := 0D;
                Clear(CustomerAddress);
                ReportHelper.GetShipAndCustomerAddressData(RecRefL, UnusedShipAddress, CustomerAddress);
                CompanyAddress();
                SetInvoicePeriodDates(SalesInvoiceHeader);
                TotalLineAmount := CalculateLineAmount(SalesInvoiceHeader);
                VATLblTxt := StrSubstNo(VATLbl, GetInvoiceVATPercent(SalesInvoiceHeader));
                ExclVATLblTxt := StrSubstNo(ExclVATLbl, ReportHelper.GetCurrencyCode(SalesInvoiceHeader."Currency Code"));
                InclVATLblTxt := StrSubstNo(InclVATLbl, ReportHelper.GetCurrencyCode(SalesInvoiceHeader."Currency Code"));
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(Referencetxt; Referencetxt)
                    {
                        ApplicationArea = All;
                        Caption = 'Reference';
                    }
                    field(DatetoPrint; DatetoPrint)
                    {
                        ApplicationArea = All;
                        Caption = 'Date to Print';
                    }
                }
                group(SalesInvHeader)
                {
                    Caption = 'Sales Invoice Header Filters';
                    field(CustomerNoFilter; CustomerNoFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'Customer No.';
                        TableRelation = Customer."No.";
                    }
                    field(DocumentNoFilter; DocumentNoFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'Document No.';
                    }
                    field(PostingDateFilter; PostingDateFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'Posting Date';
                    }
                }
            }
        }
    }
    trigger OnInitReport()
    begin
        CompanyInformation.Get();
        CompanyInformation.CalcFields(Picture);
    end;

    var
        Referencetxt: Text[100];
        DatetoPrint: Date;
        CustomerNoFilter: Text[100];
        DocumentNoFilter: Text[250];
        PostingDateFilter: Text[250];
        StartDate: Text[100];
        EndDate: Text[100];
        StartDateValue: Date;
        EndDateValue: Date;
        CompanyInformation: Record "Company Information";
        CustomerAddress: Array[8] of Text[100];
        CompanyNametxt: Text[100];
        CompanyAddresstxt: Text[100];
        CompanyCitytxt: Text[100];
        CompanyPhNo: Text[100];
        CompanyEmail: Text[100];
        CompanyHP: Text[100];
        CompanyVATReg: Text[100];
        CompanyRegNo: Text[100];
        CompanySwiftCode: Text[100];
        CompanyIBANCode: Text[100];
        CompanyBankName: Text[100];
        TotalLineAmount: Decimal;
        TotalAmount: Decimal;
        TotalVATAmount: Decimal;
        TotalInclAmount: Decimal;
        CombineInvLbl: Label 'Combine Invoice';
        ReferenceLbl: Label 'Reference:';
        ProjectCodeLbl: Label 'Project Code:';
        CustomerLbl: Label 'Customer';
        DateLbl: Label 'Date';
        InvNoLbl: Label 'Invoice No.';
        StartDateLbl: Label 'Start Date';
        EndDateLbl: Label 'End Date';
        ProjectNoLbl: Label 'Project No.';
        DescriptionLbl: Label 'Description';
        AmountLbl: Label 'Amount';
        TotalLbl: Label 'Total';
        ExclVATLbl: Label 'Total %1 excl. VAT';
        ExclVATLblTxt: Text[100];
        VATLbl: Label '%1 % VAT';
        VATLblTxt: Text[100];
        InclVATLbl: Label 'Total %1 incl. VAT';
        InclVATLblTxt: Text[100];

    procedure CustomerAddressL(SalesInvHeader: Record "Sales Invoice Header");
    var
        Customer: Record Customer;
        LineNo: Integer;
        Country: Record "Country/Region";
    begin
        LineNo := 1;
        if SalesInvHeader."Bill-to Name" <> '' then begin
            CustomerAddress[LineNo] := SalesInvHeader."Bill-to Name";
            LineNo += 1;
        end;
        if SalesInvHeader."Bill-to Address" <> '' then begin
            CustomerAddress[LineNo] := SalesInvHeader."Bill-to Address";
            LineNo += 1;
        end;
        if SalesInvoiceHeader."Bill-to Address 2" <> '' then begin
            CustomerAddress[LineNo] := SalesInvHeader."Bill-to Address 2";
            LineNo += 1;
        end;
        if (SalesInvHeader."Bill-to Post Code" <> '') OR (SalesInvHeader."Bill-to City" <> '') then begin
            CustomerAddress[LineNo] := SalesInvHeader."Bill-to Post Code" + ' ' + SalesInvHeader."Bill-to City";
            LineNo += 1;
        end;
        if Country.Get(SalesInvHeader."Bill-to Country/Region Code") then begin
            CustomerAddress[LineNo] := Country.Name;
        end;
    end;

    procedure CompanyAddress()
    var
        CompanyInfoL: Record "Company Information";
    begin
        CompanyInfoL.Get();
        CompanyNametxt := CompanyInfoL.Name;
        CompanyAddresstxt := CompanyInfoL.Address;
        CompanyCitytxt := CompanyInfoL."Post Code" + ' ' + CompanyInfoL.City;
        CompanyPhNo := CompanyInfoL."Phone No.";
        CompanyEmail := CompanyInfoL."E-Mail";
        CompanyHP := CompanyInfoL."Home Page";
        CompanyVATReg := CompanyInfoL."VAT Registration No.";
        CompanyRegNo := CompanyInfoL."Registration No.";
        CompanySwiftCode := CompanyInfoL."SWIFT Code";
        CompanyIBANCode := CompanyInfoL.IBAN;
        CompanyBankName := CompanyInfoL."Bank Name";
    end;

    procedure CalculateLineAmount(SalesInvHeader: Record "Sales Invoice Header"): Decimal
    var
        SalesInvLine: Record "Sales Invoice Line";
        TotalLineAmountL: Decimal;
    begin
        SalesInvLine.SetRange("Document No.", SalesInvoiceHeader."No.");
        if SalesInvLine.FindSet() then
            repeat
                TotalLineAmountL += SalesInvLine."Line Amount";
            until SalesInvLine.Next() = 0;
        exit(Round(TotalLineAmountL, 0.01, '='));
    end;

    procedure SetInvoicePeriodDates(SalesInvHeader: Record "Sales Invoice Header")
    var
        SalesInvLine: Record "Sales Invoice Line";
    begin
        Clear(StartDate);
        Clear(EndDate);
        Clear(StartDateValue);
        Clear(EndDateValue);

        SalesInvLine.SetRange("Document No.", SalesInvHeader."No.");
        if SalesInvLine.FindSet() then
            repeat
                if SalesInvLine."EQM Rental From Date" <> 0D then
                    if (StartDateValue = 0D) or (SalesInvLine."EQM Rental From Date" < StartDateValue) then
                        StartDateValue := SalesInvLine."EQM Rental From Date";

                if SalesInvLine."EQM Rental To Date" <> 0D then
                    if (EndDateValue = 0D) or (SalesInvLine."EQM Rental To Date" > EndDateValue) then
                        EndDateValue := SalesInvLine."EQM Rental To Date";
            until SalesInvLine.Next() = 0;

        if StartDateValue <> 0D then
            StartDate := Format(StartDateValue);

        if EndDateValue <> 0D then
            EndDate := Format(EndDateValue);
    end;

    procedure CalculateFilteredTotals(var SalesInvHeaderFilter: Record "Sales Invoice Header")
    var
        SalesInvHeaderTotal: Record "Sales Invoice Header";
    begin
        Clear(TotalAmount);
        Clear(TotalInclAmount);
        Clear(TotalVATAmount);

        SalesInvHeaderTotal.CopyFilters(SalesInvHeaderFilter);
        if SalesInvHeaderTotal.FindSet() then
            repeat
                SalesInvHeaderTotal.CalcFields(Amount, "Amount Including VAT");
                TotalAmount += SalesInvHeaderTotal.Amount;
                TotalInclAmount += SalesInvHeaderTotal."Amount Including VAT";
            until SalesInvHeaderTotal.Next() = 0;

        TotalAmount := Round(TotalAmount, 0.01, '=');
        TotalInclAmount := Round(TotalInclAmount, 0.01, '=');
        TotalVATAmount := Round(TotalInclAmount - TotalAmount, 0.01, '=');
    end;

    procedure GetInvoiceVATPercent(SalesInvHeader: Record "Sales Invoice Header"): Decimal
    var
        SalesInvLine: Record "Sales Invoice Line";
    begin
        SalesInvLine.SetRange("Document No.", SalesInvHeader."No.");
        if SalesInvLine.FindSet() then
            repeat
                if SalesInvLine."VAT %" <> 0 then
                    exit(SalesInvLine."VAT %");
            until SalesInvLine.Next() = 0;
        exit(0);
    end;



    procedure UpdatePhEmailHP(SalesInvHeader: Record "Sales Invoice Header")
    var
        Customer: Record Customer;
        CustomerPosting: Record "Customer Posting Group";
        CompanyInfoL: Record "Company Information";
    begin
        CompanyInfoL.Get();

        CompanyPhNo := CompanyInfoL."Phone No.";
        CompanyEmail := CompanyInfoL."E-Mail";
        CompanyHP := CompanyInfoL."Home Page";

        if not Customer.Get(SalesInvHeader."Bill-to Customer No.") then
            exit;

        if not CustomerPosting.Get(Customer."Customer Posting Group") then
            exit;

        if (CustomerPosting.Code = 'AUSTRIA') or (CustomerPosting.Description = 'AUSTRIA') then begin
            CompanyPhNo := CompanyInfoL."I2I Phone No. AT";
            CompanyEmail := CompanyInfoL."I2I Email AT";
            CompanyHP := CompanyInfoL."I2I Home Page AT";
        end else
            if (CustomerPosting.Code = 'SCHWEIZ') or (CustomerPosting.Description = 'SCHWEIZ') then begin
                CompanyPhNo := CompanyInfoL."I2I Phone No. CH";
                CompanyEmail := CompanyInfoL."I2I Email CH";
                CompanyHP := CompanyInfoL."I2I Home Page CH";
            end;
    end;
}

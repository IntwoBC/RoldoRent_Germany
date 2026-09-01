report 60004 "Posted Rental Invoice"
{
    ApplicationArea = All;
    Caption = 'Posted Rental Invoice';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'Src/Reports/PostedRentalInvoice/PostedRentalInvoice.rdlc';
    Permissions = tabledata "Sales Invoice Header" = r;

    dataset
    {
        dataitem(SalesInvoiceHeader; "Sales Invoice Header")
        {
            RequestFilterFields = "No.";
            column(No_SalesInvoiceHeader; "No.") { }
            column(EQM_Contract_No_; "EQM Contract No.") { }
            column(Posting_Date; Format("Posting Date", 0, '<Day,2>-<Month,2>-<Year>')) { }
            column(Due_Date; Format("Due Date", 0, '<Day,2>-<Month,2>-<Year>')) { }
            column(VAT_Registration_No_; "VAT Registration No.") { }
            column(External_Document_No_; "External Document No.") { }
            column(Your_Reference; "Your Reference") { }
            column(EQMCombine_Customer_Proj; "EQMCombine Customer Proj") { }
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
            // column(CompanyPhoneNo; CompanyInfo."Phone No.") { }
            // column(CompanyEmail; CompanyInfo."E-Mail") { }
            // column(CompanyHomePage; CompanyInfo."Home Page") { }
            // column(CompanyBankName; CompanyInfo."Bank Name") { }
            // column(CompanyBankAccNo; CompanyInfo."Bank Account No.") { }
            // column(CompanyVATRegNo; CompanyInfo."VAT Registration No.") { }
            // column(CompanyRegNo; CompanyInfo."Registration No.") { }
            // column(CompanySwiftCode; CompanyInfo."SWIFT Code") { }
            column(CompanyIBAN; CompanyInfo.IBAN) { }
            column(Amount_Including_VAT; "Amount Including VAT") { DecimalPlaces = 2 : 2; }
            column(AmountIncludingVATDecimal; AmountIncludingVATDecimal) { DecimalPlaces = 2 : 2; }
            column(Amount; Amount) { DecimalPlaces = 2 : 2; }
            column(AmountDecimal; AmountDecimal) { DecimalPlaces = 2 : 2; }
            column(VATAmount; VATAmount) { DecimalPlaces = 2 : 2; }
            column(VATPercent; VATPercent) { }
            column(VATPercentText; VATPercentText) { }
            column(InVerhuurhdrText; InVerhuurHdrText) { }
            column(InVerhuurQtyText; InVerhuurQtyText) { }
            column(InVerhuurDescText; InVerhuurDescText) { }
            column(VATReversedText; VATReversedText) { }
            column(RentalFromDate_H; RentalFromDate) { }
            column(RentalToDate_H; RentalToDate) { }
            column(RentalPeriodText; RentalPeriodText) { }
            column(RentalFromText; RentalFromText) { }
            column(RentalToText; RentalToText) { }
            column(PaymentTermsDescription; PaymentTermsDesc) { }
            column(CustVATRegNo; CustVATRegNo) { }
            column(HasDiscount; HasDiscount) { }
            column(InvoiceTitleLbl; InvoiceTitleLbl) { }
            column(ProjectCodeLbl; ProjectCodeLbl) { }
            column(InvoiceDateLbl; InvoiceDateLbl) { }
            column(DueDateLbl; DueDateLbl) { }
            column(PaymentTermsLbl; PaymentTermsLbl) { }
            column(CustomerNoLbl; CustomerNoLbl) { }
            column(VATNoLbl; VATNoLbl) { }
            column(RentalPeriodHdrLbl; RentalPeriodHdrLbl) { }
            column(YourReferenceLbl; YourReferenceLbl) { }
            column(ReceiptNoLbl; ReceiptNoLbl) { }
            column(DateLbl; DateLbl) { }
            column(DescriptionLbl; DescriptionLbl) { }
            column(MutationLbl; MutationLbl) { }
            column(QtyOnRentLbl; QtyOnRentLbl) { }
            column(RentalDaysLbl; RentalDaysLbl) { }
            column(PricePerDayLbl; PricePerDayLbl) { }
            column(DiscountPctLbl; DiscountPctLbl) { }
            column(AmountLbl; AmountLbl) { }
            column(RentLbl; RentLbl) { }
            column(ReturnLbl; ReturnLbl) { }
            column(TotalEURLbl; TotalExclVATTxt) { }
            column(TotalInclEURLbl; TotalInclVATTxt) { }
            column(ExclVATLbl; ExclVATLbl) { }
            column(VATLbl; VATLbl) { }
            column(InclVATLbl; InclVATLbl) { }
            column(VATReverseChargeLbl; VATReverseChargeLbl) { }
            column(UntilLbl; UntilLbl) { }
            column(OnRentAsOfLbl; OnRentAsOfLbl) { }
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
            dataitem(MovementLine; Integer)
            {
                DataItemTableView = sorting(Number);
                column(BonnrHuur; MovBonnrHuur) { }
                column(BonnrRetour; MovBonnrRetour) { }
                column(DatumHuur; MovDatumHuur) { }
                column(DatumRetour; MovDatumRetour) { }
                column(Description; MovDescription) { }
                column(Mutatie; MovMutatie) { }
                column(AantalInHuur; MovAantalInHuur) { }
                column(HuurDagen; MovHuurDagen) { }
                column(PrijsPerDag; MovPrijsPerDag) { }
                column(Bedrag; MovBedrag) { }
                column(IsReturnLine; MovIsReturnLine) { }
                column(KortingPct; MovKortingPct) { }

                trigger OnPreDataItem()
                begin
                    if TempMovementLineCount = 0 then
                        CurrReport.Break();
                    SetRange(Number, 1, TempMovementLineCount);
                end;

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then
                        TempMovementLine.FindSet()
                    else
                        TempMovementLine.Next();

                    MovBonnrHuur := TempMovementLine.BonnrHuur;
                    MovBonnrRetour := TempMovementLine.BonnrRetour;
                    MovDatumHuur := TempMovementLine.DatumHuur;
                    MovDatumRetour := TempMovementLine.DatumRetour;
                    MovDescription := TempMovementLine.Description;
                    MovMutatie := TempMovementLine.Mutatie;
                    MovAantalInHuur := TempMovementLine.AantalInHuur;
                    MovHuurDagen := TempMovementLine.HuurDagen;
                    MovPrijsPerDag := TempMovementLine.PrijsPerDag;
                    MovBedrag := TempMovementLine.Bedrag;
                    MovIsReturnLine := TempMovementLine.IsReturnLine;
                    MovKortingPct := TempMovementLine.KortingPct;
                end;
            }

            dataitem(VATCounter; Integer)
            {
                DataItemTableView = sorting(Number);
                column(VATAmtLineVATIdentifier; TempVATAmountLine."VAT Identifier") { }
                column(VATAmtLineVATPer; TempVATAmountLine."VAT %") { DecimalPlaces = 0 : 5; }
                column(VATAmtLineVATBase; TempVATAmountLine."VAT Base") { AutoFormatType = 1; }
                column(VATAmtLineVATAmt; TempVATAmountLine."VAT Amount") { AutoFormatType = 1; }
                column(VATAmtLineAmtInclVAT; TempVATAmountLine."Amount Including VAT") { AutoFormatType = 1; }
                column(VATAmtLineLineAmt; TempVATAmountLine."Line Amount") { AutoFormatType = 1; }

                trigger OnPreDataItem()
                begin
                    SetRange(Number, 1, TempVATAmountLine.Count);
                end;

                trigger OnAfterGetRecord()
                begin
                    TempVATAmountLine.GetLine(Number);
                end;
            }

            trigger OnAfterGetRecord()
            var
                Customer: Record Customer;
                SalesInvLine: Record "Sales Invoice Line";
                PaymentTerms: Record "Payment Terms";
                ReportHelper: Codeunit "I2I Report Helper";
                RecRefl: RecordRef;
            begin
                RecRefl.GetTable(SalesInvoiceHeader);

                if "Language Code" <> '' then
                    LanguageId := LanguageMgt.GetLanguageId("Language Code")
                else
                    LanguageId := 0;
                if LanguageId = 0 then
                    LanguageId := LanguageMgt.GetLanguageId(DefaultLanguageCodeLbl);
                if LanguageId <> 0 then
                    CurrReport.Language := LanguageId;

                Clear(RentalFromDate);
                Clear(RentalToDate);
                Clear(PaymentTermsDesc);
                Clear(CustVATRegNo);
                Clear(RentalPeriodText);
                Clear(RentalFromText);
                Clear(RentalToText);
                Clear(VATReversedText);

                CalcFields("Amount Including VAT", Amount);
                AmountIncludingVATDecimal := Round("Amount Including VAT", 0.01);
                AmountDecimal := Round(Amount, 0.01);
                ReportHelper.GetShipAndBillAddressData(RecRefL, CustAddr, ShipToAddr);
                ReportHelper.CompanyAddress(CompanyAddr);

                if Customer.Get("Bill-to Customer No.") then begin
                    CustVATRegNo := Customer."VAT Registration No.";
                    if Customer."Country/Region Code" = 'BE' then
                        VATReversedText := 'X';
                end;

                if PaymentTerms.Get("Payment Terms Code") then
                    PaymentTermsDesc := PaymentTerms.Description;

                VATAmount := "Amount Including VAT" - Amount;

                SalesInvLine.SetRange("Document No.", "No.");
                SalesInvLine.SetFilter(Type, '%1|%2', SalesInvLine.Type::Item, SalesInvLine.Type::"G/L Account");
                SalesInvLine.SetRange("EQM Rental Sale", false);
                if SalesInvLine.FindSet() then
                    repeat
                        if SalesInvLine."EQM Rental" then begin
                            if (SalesInvLine."EQM Rental From Date" <> 0D) then
                                if (RentalFromDate = 0D) or (SalesInvLine."EQM Rental From Date" < RentalFromDate) then
                                    RentalFromDate := SalesInvLine."EQM Rental From Date";
                            if (SalesInvLine."EQM Rental To Date" <> 0D) then
                                if (SalesInvLine."EQM Rental To Date" > RentalToDate) then
                                    RentalToDate := SalesInvLine."EQM Rental To Date";
                        end;
                    until SalesInvLine.Next() = 0;

                if (RentalFromDate <> 0D) and (RentalToDate <> 0D) then begin
                    RentalFromText := Format(RentalFromDate, 0, '<Day,2>-<Month,2>-<Year>');
                    RentalToText := Format(RentalToDate, 0, '<Day,2>-<Month,2>-<Year>');
                end;

                BuildVATAmountLines();

                VATPercent := 0;
                Clear(VATPercentText);
                if GetSingleVATPercent(VATPercent) then
                    VATPercentText := FormatVATPercent(VATPercent);

                BuildMovementLines();
                ReportHelper.UpdateCompanyReportData(
                                    SalesInvoiceHeader."Sell-to Customer No.",
                                    SalesInvoiceHeader."Location Code",
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
                BuildInVerhuurText();

                TotalExclVATTxt := StrSubstNo(TotalEURLbl, ReportHelper.GetCurrencyCode(SalesInvoiceHeader."Currency Code"));
                TotalInclVATTxt := StrSubstNo(TotalInclEURLbl, ReportHelper.GetCurrencyCode(SalesInvoiceHeader."Currency Code"));

                if not IsReportInPreviewMode() then
                    CODEUNIT.Run(CODEUNIT::"Sales Inv.-Printed", SalesInvoiceHeader);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
            }
        }
    }

    trigger OnInitReport()
    begin
        if CompanyInfo.Get() then
            CompanyInfo.CalcFields(Picture);
    end;

    var
        TempMovementLine: Record "I2I Rental Movement Line" temporary;
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        RentalInvoice: Report "Standard Sales - Invoice";
        CompanyInfo: Record "Company Information";
        LanguageMgt: Codeunit Language;
        CustAddr: array[8] of Text[100];
        ShipToAddr: array[8] of Text[100];
        CompanyAddr: array[8] of Text[100];
        VATAmount: Decimal;
        VATPercent: Decimal;
        AmountIncludingVATDecimal: Decimal;
        AmountDecimal: Decimal;
        LanguageId: Integer;
        VATPercentText: Text[30];
        RentalFromDate: Date;
        RentalToDate: Date;
        InVerhuurQtyText: Text;
        InVerhuurDescText: Text;
        InVerhuurHdrText: Text;
        VATReversedText: Text;
        TempMovementLineCount: Integer;
        PaymentTermsDesc: Text[100];
        CustVATRegNo: Text[20];
        RentalPeriodText: Text[50];
        RentalFromText: Text[20];
        RentalToText: Text[20];
        MovBonnrHuur: Code[35];
        MovBonnrRetour: Code[35];
        MovDatumHuur: Text[20];
        MovDatumRetour: Text[20];
        MovDescription: Text[100];
        MovMutatie: Decimal;
        MovAantalInHuur: Decimal;
        MovHuurDagen: Decimal;
        MovPrijsPerDag: Decimal;
        MovBedrag: Decimal;
        MovIsReturnLine: Boolean;
        MovKortingPct: Decimal;
        HasDiscount: Boolean;
        OpeningHours: Text[100];
        InvoiceTitleLbl: Label 'Rental Invoice';
        ProjectCodeLbl: Label 'Project Code:';
        InvoiceDateLbl: Label 'Invoice Date:';
        DueDateLbl: Label 'Due Date:';
        PaymentTermsLbl: Label 'Payment Terms:';
        CustomerNoLbl: Label 'Customer No.:';
        VATNoLbl: Label 'VAT No.:';
        RentalPeriodHdrLbl: Label 'Rental Period:';
        YourReferenceLbl: Label 'Your Reference:';
        ReceiptNoLbl: Label 'Receipt No.';
        DateLbl: Label 'Date';
        DescriptionLbl: Label 'Description';
        MutationLbl: Label 'Mutation';
        QtyOnRentLbl: Label 'Qty. on Rent';
        RentalDaysLbl: Label 'Rental Days';
        PricePerDayLbl: Label 'Price/Day';
        DiscountPctLbl: Label 'Discount %', Comment = '%  is a literal percent sign';
        AmountLbl: Label 'Amount';
        RentLbl: Label 'Rent';
        ReturnLbl: Label 'Return';
        TotalEURLbl: Label 'Total %1';
        TotalInclEURLbl: Label 'Total %1';
        ExclVATLbl: Label 'excl. VAT';
        VATLbl: Label 'VAT';
        InclVATLbl: Label 'incl. VAT';
        VATReverseChargeLbl: Label 'VAT reverse charge.';
        UntilLbl: Label 'up to and incl.';
        OnRentAsOfLbl: Label 'On rent as of';
        DefaultLanguageCodeLbl: Label 'DE', Locked = true;
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
        TotalExclVATTxt: Text[50];
        TotalInclVATTxt: Text[50];

    local procedure BuildVATAmountLines()
    var
        SalesInvLine: Record "Sales Invoice Line";
    begin
        TempVATAmountLine.Reset();
        TempVATAmountLine.DeleteAll();

        SalesInvLine.SetRange("Document No.", SalesInvoiceHeader."No.");
        SalesInvLine.SetFilter(Type, '<>%1', SalesInvLine.Type::" ");
        SalesInvLine.SetFilter("Line Amount", '<>0');
        if SalesInvLine.FindSet() then
            repeat
                TempVATAmountLine.Init();
                TempVATAmountLine."VAT Identifier" := SalesInvLine."VAT Identifier";
                TempVATAmountLine."VAT Calculation Type" := SalesInvLine."VAT Calculation Type";
                TempVATAmountLine."Tax Group Code" := SalesInvLine."Tax Group Code";
                TempVATAmountLine."VAT %" := SalesInvLine."VAT %";
                TempVATAmountLine."VAT Base" := SalesInvLine.Amount;
                TempVATAmountLine."Amount Including VAT" := SalesInvLine."Amount Including VAT";
                TempVATAmountLine."Line Amount" := SalesInvLine."Line Amount";
                if SalesInvLine."Allow Invoice Disc." then
                    TempVATAmountLine."Inv. Disc. Base Amount" := SalesInvLine."Line Amount";
                TempVATAmountLine."Invoice Discount Amount" := SalesInvLine."Inv. Discount Amount";
                TempVATAmountLine.InsertLine();
            until SalesInvLine.Next() = 0;
    end;

    local procedure GetSingleVATPercent(var SingleVATPercent: Decimal): Boolean
    var
        FoundVATPercent: Boolean;
    begin
        TempVATAmountLine.Reset();
        if TempVATAmountLine.FindSet() then
            repeat
                if not FoundVATPercent then begin
                    SingleVATPercent := TempVATAmountLine."VAT %";
                    FoundVATPercent := true;
                end else
                    if TempVATAmountLine."VAT %" <> SingleVATPercent then
                        exit(false);
            until TempVATAmountLine.Next() = 0;

        exit(FoundVATPercent);
    end;

    local procedure FormatVATPercent(VATPercentToFormat: Decimal): Text[30]
    begin
        exit(Format(VATPercentToFormat, 0, '<Precision,0:5><Standard Format,0>') + ' %');
    end;

    local procedure BuildMovementLines()
    var
        NextLineNumber: Integer;
        MovementDisplayLinesAdded: Boolean;
    begin
        TempMovementLine.Reset();
        TempMovementLine.DeleteAll();
        TempMovementLineCount := 0;
        NextLineNumber := 0;
        HasDiscount := false;

        MovementDisplayLinesAdded := BuildRentalMovementDisplayLines(NextLineNumber);
        AddDirectInvoiceDisplayLines(NextLineNumber, MovementDisplayLinesAdded);

        TempMovementLine.Reset();
        if TempMovementLine.FindSet() then
            repeat
                if TempMovementLine.KortingPct <> 0 then begin
                    HasDiscount := true;
                    break;
                end;
            until TempMovementLine.Next() = 0;
    end;

    local procedure BuildRentalMovementDisplayLines(var NextLineNumber: Integer): Boolean
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
        GroupKeys: List of [Text];
        GroupRentalNos: List of [Code[20]];
        GroupDescriptions: List of [Text[100]];
        GroupUnitPrices: List of [Decimal];
        GroupDiscounts: List of [Decimal];
        GroupPeriodFroms: List of [Date];
        GroupPeriodTos: List of [Date];
        GroupContractExtLinePairs: List of [Text];
        KeyValue: Text;
        PairValue: Text;
        ExistingPairs: Text;
        GroupIndex: Integer;
        LinesAdded: Boolean;
        i: Integer;
    begin
        ApplyRentalMovementLineFilters(SalesInvoiceLine);
        if SalesInvoiceLine.FindSet() then
            repeat
                if IsRentalMovementInvoiceLine(SalesInvoiceLine) then begin
                    KeyValue := MakeItemGroupKey(SalesInvoiceLine);
                    PairValue := SalesInvoiceLine."EQM Contract No." + '~' + Format(SalesInvoiceLine."EQM Rental Line No.");
                    GroupIndex := GroupKeys.IndexOf(KeyValue);
                    if GroupIndex = 0 then begin
                        GroupKeys.Add(KeyValue);
                        GroupRentalNos.Add(SalesInvoiceLine."EQM Rental No.");
                        GroupDescriptions.Add(SalesInvoiceLine.Description);
                        GroupUnitPrices.Add(SalesInvoiceLine."Unit Price");
                        GroupDiscounts.Add(SalesInvoiceLine."Line Discount %");
                        GroupPeriodFroms.Add(SalesInvoiceLine."EQM Rental From Date");
                        GroupPeriodTos.Add(SalesInvoiceLine."EQM Rental To Date");
                        GroupContractExtLinePairs.Add(PairValue);
                    end else begin
                        ExistingPairs := GroupContractExtLinePairs.Get(GroupIndex);
                        if StrPos(';' + ExistingPairs + ';', ';' + PairValue + ';') = 0 then
                            GroupContractExtLinePairs.Set(GroupIndex, ExistingPairs + ';' + PairValue);
                        if (SalesInvoiceLine."EQM Rental From Date" <> 0D) then
                            if (GroupPeriodFroms.Get(GroupIndex) = 0D) or (SalesInvoiceLine."EQM Rental From Date" < GroupPeriodFroms.Get(GroupIndex)) then
                                GroupPeriodFroms.Set(GroupIndex, SalesInvoiceLine."EQM Rental From Date");
                        if SalesInvoiceLine."EQM Rental To Date" > GroupPeriodTos.Get(GroupIndex) then
                            GroupPeriodTos.Set(GroupIndex, SalesInvoiceLine."EQM Rental To Date");
                    end;
                end;
            until SalesInvoiceLine.Next() = 0;

        for i := 1 to GroupKeys.Count() do
            if EmitMovementRowsForItemGroup(
                GroupContractExtLinePairs.Get(i), GroupDescriptions.Get(i),
                GroupUnitPrices.Get(i), GroupDiscounts.Get(i),
                GroupPeriodFroms.Get(i), GroupPeriodTos.Get(i),
                GroupRentalNos.Get(i), NextLineNumber) then
                LinesAdded := true;

        exit(LinesAdded);
    end;

    local procedure EmitMovementRowsForItemGroup(ContractExtLinePairsText: Text; Description: Text[100]; UnitPrice: Decimal; LineDiscountPct: Decimal; PeriodFrom: Date; PeriodTo: Date; RentalNoValue: Code[20]; var NextLineNumber: Integer): Boolean
    var
        RentalReturnEntry: Record "EQM Rental Return Entry";
        PriceFactor: Decimal;
        GroupSortKey: Code[20];
        EvBoundaryDate: List of [Date];
        EvEventDate: List of [Date];
        EvIsReturn: List of [Boolean];
        EvEntryNo: List of [Integer];
        EvMutation: List of [Decimal];
        EvExtDocNo: List of [Code[35]];
        Indexes: List of [Integer];
        AggBoundaryDate: List of [Date];
        AggEventDate: List of [Date];
        AggIsReturn: List of [Boolean];
        AggExtDocNo: List of [Code[35]];
        AggMutation: List of [Decimal];
        AggKeys: List of [Text];
        PairParts: List of [Text];
        Pairs: List of [Text];
        StartQty: Decimal;
        RunningQty: Decimal;
        FirstBoundaryAfterPeriodFrom: Date;
        NextBoundaryDate: Date;
        Days: Decimal;
        Bedrag: Decimal;
        EmittedRow: Boolean;
        EmittedFirstRow: Boolean;
        SameDateAsNext: Boolean;
        i: Integer;
        j: Integer;
        Tmp: Integer;
        Idx: Integer;
        AggPos: Integer;
        BoundaryDate: Date;
        EventDate: Date;
        AggKey: Text;
        ContractNo: Code[20];
        ExtLineNo: Integer;
        PairText: Text;
    begin
        if (PeriodFrom = 0D) or (PeriodTo = 0D) then
            exit(false);

        GroupSortKey := PadStr('', MaxStrLen(GroupSortKey) - StrLen(RentalNoValue), '0') + RentalNoValue;
        PriceFactor := (100 - LineDiscountPct) / 100;

        Pairs := ContractExtLinePairsText.Split(';');
        foreach PairText in Pairs do begin
            PairParts := PairText.Split('~');
            ContractNo := CopyStr(PairParts.Get(1), 1, MaxStrLen(ContractNo));
            Evaluate(ExtLineNo, PairParts.Get(2));
            RentalReturnEntry.Reset();
            RentalReturnEntry.SetRange("Contract No.", ContractNo);
            RentalReturnEntry.SetRange("Ext. Rental Line No.", ExtLineNo);
            RentalReturnEntry.SetRange("Undo Entry", false);
            RentalReturnEntry.SetFilter("Entry Type", '%1|%2',
                RentalReturnEntry."Entry Type"::"On-Rent",
                RentalReturnEntry."Entry Type"::"Off-Rent");
            if RentalReturnEntry.FindSet() then
                repeat
                    if RentalReturnEntry."Entry Type" = RentalReturnEntry."Entry Type"::"Off-Rent" then begin
                        EvBoundaryDate.Add(RentalReturnEntry."Off-Rent Date" + 1);
                        EvEventDate.Add(RentalReturnEntry."Off-Rent Date");
                        EvIsReturn.Add(true);
                    end else begin
                        EvBoundaryDate.Add(RentalReturnEntry."On-Rent Date");
                        EvEventDate.Add(RentalReturnEntry."On-Rent Date");
                        EvIsReturn.Add(false);
                    end;
                    EvEntryNo.Add(RentalReturnEntry."Entry No.");
                    EvMutation.Add(-RentalReturnEntry.Quantity);
                    EvExtDocNo.Add(RentalReturnEntry."I2I External Document No.");
                until RentalReturnEntry.Next() = 0;
        end;

        for i := 1 to EvBoundaryDate.Count() do
            Indexes.Add(i);
        for i := 1 to Indexes.Count() - 1 do
            for j := i + 1 to Indexes.Count() do
                if IsEventBefore(Indexes.Get(j), Indexes.Get(i), EvBoundaryDate, EvEntryNo) then begin
                    Tmp := Indexes.Get(i);
                    Indexes.Set(i, Indexes.Get(j));
                    Indexes.Set(j, Tmp);
                end;

        StartQty := 0;
        for i := 1 to Indexes.Count() do begin
            Idx := Indexes.Get(i);
            if EvEventDate.Get(Idx) < PeriodFrom then
                StartQty += EvMutation.Get(Idx);
        end;
        RunningQty := StartQty;

        FirstBoundaryAfterPeriodFrom := PeriodTo + 1;
        for i := 1 to Indexes.Count() do begin
            Idx := Indexes.Get(i);
            if (EvBoundaryDate.Get(Idx) > PeriodFrom) and (EvBoundaryDate.Get(Idx) <= PeriodTo) then begin
                FirstBoundaryAfterPeriodFrom := EvBoundaryDate.Get(Idx);
                break;
            end;
        end;

        if StartQty > 0 then begin
            Days := FirstBoundaryAfterPeriodFrom - PeriodFrom;
            Bedrag := RunningQty * Days * UnitPrice * PriceFactor;
            InsertCarryOverMovementRow(NextLineNumber, Description, PeriodFrom, RunningQty, Days, UnitPrice, Bedrag, GroupSortKey, 0, LineDiscountPct);
            EmittedRow := true;
            EmittedFirstRow := true;
        end;

        for i := 1 to Indexes.Count() do begin
            Idx := Indexes.Get(i);
            EventDate := EvEventDate.Get(Idx);
            if (EventDate >= PeriodFrom) and (EventDate <= PeriodTo) then begin
                AggKey := Format(EvBoundaryDate.Get(Idx), 0, 9) + '|' +
                    Format(EvIsReturn.Get(Idx)) + '|' + EvExtDocNo.Get(Idx);
                AggPos := AggKeys.IndexOf(AggKey);
                if AggPos = 0 then begin
                    AggKeys.Add(AggKey);
                    AggBoundaryDate.Add(EvBoundaryDate.Get(Idx));
                    AggEventDate.Add(EventDate);
                    AggIsReturn.Add(EvIsReturn.Get(Idx));
                    AggExtDocNo.Add(EvExtDocNo.Get(Idx));
                    AggMutation.Add(EvMutation.Get(Idx));
                end else
                    AggMutation.Set(AggPos, AggMutation.Get(AggPos) + EvMutation.Get(Idx));
            end;
        end;

        for i := 1 to AggKeys.Count() do begin
            BoundaryDate := AggBoundaryDate.Get(i);
            EventDate := AggEventDate.Get(i);
            RunningQty += AggMutation.Get(i);

            if BoundaryDate > PeriodTo then
                Days := 0
            else
                if BoundaryDate = PeriodFrom then
                    Days := FirstBoundaryAfterPeriodFrom - PeriodFrom
                else begin
                    SameDateAsNext := false;
                    if i < AggKeys.Count() then
                        SameDateAsNext := AggBoundaryDate.Get(i + 1) = BoundaryDate;
                    if SameDateAsNext then
                        Days := 0
                    else begin
                        NextBoundaryDate := PeriodTo + 1;
                        for j := i + 1 to AggKeys.Count() do
                            if (AggBoundaryDate.Get(j) > BoundaryDate) and (AggBoundaryDate.Get(j) <= PeriodTo) then begin
                                NextBoundaryDate := AggBoundaryDate.Get(j);
                                break;
                            end;
                        Days := NextBoundaryDate - BoundaryDate;
                    end;
                end;

            if (BoundaryDate = PeriodFrom) and EmittedFirstRow then
                Bedrag := AggMutation.Get(i) * Days * UnitPrice * PriceFactor
            else
                if (Days > 0) and (RunningQty > 0) then
                    Bedrag := RunningQty * Days * UnitPrice * PriceFactor
                else
                    Bedrag := 0;

            InsertEventMovementRow(NextLineNumber, Description, EventDate, AggIsReturn.Get(i),
                AggMutation.Get(i), RunningQty, Days, UnitPrice, Bedrag, AggExtDocNo.Get(i), not EmittedFirstRow, GroupSortKey, 0, LineDiscountPct);
            EmittedRow := true;
            EmittedFirstRow := true;
        end;

        exit(EmittedRow);
    end;

    local procedure IsEventBefore(IdxA: Integer; IdxB: Integer; EvBoundaryDate: List of [Date]; EvEntryNo: List of [Integer]): Boolean
    var
        DateA: Date;
        DateB: Date;
    begin
        DateA := EvBoundaryDate.Get(IdxA);
        DateB := EvBoundaryDate.Get(IdxB);
        if DateA <> DateB then
            exit(DateA < DateB);
        exit(EvEntryNo.Get(IdxA) < EvEntryNo.Get(IdxB));
    end;

    local procedure InsertCarryOverMovementRow(var NextLineNumber: Integer; Description: Text[100]; FromDate: Date; Qty: Decimal; Days: Decimal; UnitPrice: Decimal; Bedrag: Decimal; ContractNo: Code[20]; ExtLineNo: Integer; LineDiscountPct: Decimal)
    begin
        NextLineNumber += 1;
        TempMovementLine.Init();
        TempMovementLine."Line No." := NextLineNumber;
        TempMovementLine.Description := Description;
        TempMovementLine.Mutatie := 0;
        TempMovementLine.AantalInHuur := Qty;
        TempMovementLine.HuurDagen := Days;
        TempMovementLine.PrijsPerDag := UnitPrice;
        TempMovementLine.Bedrag := Bedrag;
        TempMovementLine.DatumHuur := Format(FromDate, 0, '<Day,2>-<Month,2>-<Year>');
        TempMovementLine.IsReturnLine := false;
        TempMovementLine.RentalNo := ContractNo;
        TempMovementLine.SortOrder := 1;
        TempMovementLine.SortDate := FromDate;
        TempMovementLine.ExtLineNo := ExtLineNo;
        TempMovementLine.KortingPct := LineDiscountPct;
        TempMovementLine.Insert();
        TempMovementLineCount += 1;
    end;

    local procedure InsertEventMovementRow(var NextLineNumber: Integer; Description: Text[100]; EventDate: Date; IsReturn: Boolean; Mutation: Decimal; RunningQty: Decimal; Days: Decimal; UnitPrice: Decimal; Bedrag: Decimal; ExtDocNo: Code[35]; IsOpeningRow: Boolean; ContractNo: Code[20]; ExtLineNo: Integer; LineDiscountPct: Decimal)
    begin
        NextLineNumber += 1;
        TempMovementLine.Init();
        TempMovementLine."Line No." := NextLineNumber;
        TempMovementLine.Description := Description;
        TempMovementLine.AantalInHuur := RunningQty;
        TempMovementLine.HuurDagen := Days;
        TempMovementLine.PrijsPerDag := UnitPrice;
        TempMovementLine.Bedrag := Bedrag;
        TempMovementLine.RentalNo := ContractNo;
        TempMovementLine.ExtLineNo := ExtLineNo;
        TempMovementLine.SortDate := EventDate;
        if IsOpeningRow then begin
            TempMovementLine.SortOrder := 1;
            TempMovementLine.Mutatie := 0;
            if IsReturn then begin
                TempMovementLine.DatumRetour := Format(EventDate, 0, '<Day,2>-<Month,2>-<Year>');
                TempMovementLine.BonnrRetour := ExtDocNo;
            end else begin
                TempMovementLine.DatumHuur := Format(EventDate, 0, '<Day,2>-<Month,2>-<Year>');
                TempMovementLine.BonnrHuur := ExtDocNo;
            end;
            TempMovementLine.IsReturnLine := IsReturn;
        end else begin
            TempMovementLine.SortOrder := 2;
            TempMovementLine.Mutatie := Mutation;
            if IsReturn then begin
                TempMovementLine.DatumRetour := Format(EventDate, 0, '<Day,2>-<Month,2>-<Year>');
                TempMovementLine.BonnrRetour := ExtDocNo;
                TempMovementLine.IsReturnLine := true;
            end else begin
                TempMovementLine.DatumHuur := Format(EventDate, 0, '<Day,2>-<Month,2>-<Year>');
                TempMovementLine.BonnrHuur := ExtDocNo;
                TempMovementLine.IsReturnLine := false;
            end;
        end;
        TempMovementLine.KortingPct := LineDiscountPct;
        TempMovementLine.Insert();
        TempMovementLineCount += 1;
    end;

    local procedure MakeItemGroupKey(SalesInvoiceLine: Record "Sales Invoice Line"): Text
    begin
        exit(SalesInvoiceLine."EQM Rental No." + '|' +
             Format(SalesInvoiceLine."Unit Price", 0, 9) + '|' +
             Format(SalesInvoiceLine."Line Discount %", 0, 9));
    end;

    local procedure AddDirectInvoiceDisplayLines(var NextLineNumber: Integer; MovementDisplayLinesAdded: Boolean)
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
    begin
        SalesInvoiceLine.SetRange("Document No.", SalesInvoiceHeader."No.");
        SalesInvoiceLine.SetFilter("Sell-to Customer No.", '<>%1', '');
        SalesInvoiceLine.SetFilter(Type, '<>%1', SalesInvoiceLine.Type::" ");
        SalesInvoiceLine.SetRange("EQM Hide Line", false);
        if SalesInvoiceLine.FindSet() then
            repeat
                if ShouldAddDirectInvoiceDisplayLine(SalesInvoiceLine, MovementDisplayLinesAdded) then
                    InsertDirectInvoiceDisplayLine(SalesInvoiceLine, NextLineNumber);
            until SalesInvoiceLine.Next() = 0;
    end;

    local procedure ShouldAddDirectInvoiceDisplayLine(SalesInvoiceLine: Record "Sales Invoice Line"; MovementDisplayLinesAdded: Boolean): Boolean
    begin
        if IsRentalMovementInvoiceLine(SalesInvoiceLine) then
            exit(false);

        if MovementDisplayLinesAdded and IsSalesInvoiceLineRepresentedByMovement(SalesInvoiceLine) then
            exit(false);

        exit(true);
    end;

    local procedure InsertDirectInvoiceDisplayLine(SalesInvoiceLine: Record "Sales Invoice Line"; var NextLineNumber: Integer)
    var
        ReceiptNo: Code[35];
        ReceiptDate: Text[100];
    begin
        NextLineNumber += 1;
        TempMovementLine.Init();
        TempMovementLine."Line No." := NextLineNumber;
        TempMovementLine.Description := SalesInvoiceLine.Description;
        TempMovementLine.AantalInHuur := SalesInvoiceLine.Quantity;
        TempMovementLine.HuurDagen := 0;
        TempMovementLine.PrijsPerDag := SalesInvoiceLine."Unit Price";
        TempMovementLine.Bedrag := SalesInvoiceLine."Line Amount";
        TempMovementLine.Mutatie := 0;
        TempMovementLine.IsReturnLine := false;
        TempMovementLine.RentalNo := SalesInvoiceLine."EQM Contract No.";
        TempMovementLine.SortOrder := 9;
        TempMovementLine.SortDate := 0D;
        TempMovementLine.ExtLineNo := SalesInvoiceLine."EQM Rental Line No.";
        TempMovementLine.KortingPct := SalesInvoiceLine."Line Discount %";
        if (SalesInvoiceLine.Type = SalesInvoiceLine.Type::Item) and SalesInvoiceLine."EQM Rental Sale" then begin
            GetRentalSaleReceiptInfo(SalesInvoiceLine, ReceiptNo, ReceiptDate);
            TempMovementLine.BonnrHuur := ReceiptNo;
            if ReceiptDate <> '' then begin
                TempMovementLine.DatumHuur := Format(ReceiptDate, 0, '<Day,2>-<Month,2>-<Year>');
                Evaluate(TempMovementLine.SortDate, ReceiptDate);
            end;
        end;
        TempMovementLine.Insert();
        TempMovementLineCount += 1;
    end;

    local procedure GetRentalSaleReceiptInfo(SalesInvoiceLine: Record "Sales Invoice Line"; var ReceiptNo: Code[35]; var ReceiptDate: Text[100])
    var
        RentalReturnEntry: Record "EQM Rental Return Entry";
    begin
        Clear(ReceiptNo);
        Clear(ReceiptDate);

        if (SalesInvoiceLine."EQM Contract No." = '') or (SalesInvoiceLine."EQM Rental Line No." = 0) then
            exit;

        RentalReturnEntry.SetRange("Contract No.", SalesInvoiceLine."EQM Contract No.");
        RentalReturnEntry.SetRange("Ext. Rental Line No.", SalesInvoiceLine."EQM Rental Line No.");
        RentalReturnEntry.SetRange("Undo Entry", false);
        //RentalReturnEntry.SetRange("Entry Type", RentalReturnEntry."Entry Type"::"On-Rent");
        if RentalReturnEntry.FindLast() then begin
            ReceiptNo := RentalReturnEntry."I2I External Document No.";
            ReceiptDate := Format(RentalReturnEntry."On-Rent Date", 0, '<Day,2>-<Month,2>-<Year>');
        end;
    end;

    local procedure IsRentalMovementInvoiceLine(SalesInvoiceLine: Record "Sales Invoice Line"): Boolean
    begin
        exit(
            (not SalesInvoiceLine."EQM Rental Sale") and
            (SalesInvoiceLine."EQM Rental No." <> ''));
    end;

    local procedure IsSalesInvoiceLineRepresentedByMovement(SalesInvoiceLine: Record "Sales Invoice Line"): Boolean
    begin
        exit(
            (SalesInvoiceLine."Sell-to Customer No." <> '') and
            (not SalesInvoiceLine."EQM Rental Sale") and
            (not SalesInvoiceLine."EQM Hide Line") and
            (SalesInvoiceLine."EQM Rental" or
             (SalesInvoiceLine."EQM Rental No." <> '') or
             (SalesInvoiceLine."EQM Rental Quantity" <> 0) or
             (SalesInvoiceLine."EQM Rental From Date" <> 0D) or
             (SalesInvoiceLine."EQM Rental To Date" <> 0D)));
    end;

    local procedure ApplyRentalMovementLineFilters(var SalesInvoiceLine: Record "Sales Invoice Line")
    begin
        SalesInvoiceLine.SetRange("Document No.", SalesInvoiceHeader."No.");
        SalesInvoiceLine.SetFilter("Sell-to Customer No.", '<>%1', '');
        SalesInvoiceLine.SetRange("EQM Rental Sale", false);
        SalesInvoiceLine.SetRange("EQM Hide Line", false);
    end;

    local procedure BuildInVerhuurText()
    var
        SalesInvLine: Record "Sales Invoice Line";
        RentalLine: Record "EQM Rental Line";
        RentalReturnEntry: Record "EQM Rental Return Entry";
        TypeHelper: Codeunit "Type Helper";
        ProcessedLines: List of [Text];
        LineKey: Text;
        ItemQuantities: Dictionary of [Code[20], Decimal];
        ItemDescriptions: Dictionary of [Code[20], Text[100]];
        ItemKeys: List of [Code[20]];
        ItemNo: Code[20];
        TempKey: Code[20];
        NetQuantity: Decimal;
        TotalQty: Decimal;
        i: Integer;
        j: Integer;
    begin
        Clear(InVerhuurQtyText);
        Clear(InVerhuurDescText);
        Clear(InVerhuurHdrText);

        if RentalToDate = 0D then
            exit;

        SalesInvLine.SetRange("Document No.", SalesInvoiceHeader."No.");
        SalesInvLine.SetFilter("EQM Contract No.", '<>%1', '');
        SalesInvLine.SetFilter("EQM Rental Line No.", '<>%1', 0);
        if SalesInvLine.FindSet() then
            repeat
                LineKey := SalesInvLine."EQM Contract No." + '|' + Format(SalesInvLine."EQM Rental Line No.");
                if not ProcessedLines.Contains(LineKey) then begin
                    ProcessedLines.Add(LineKey);

                    if RentalLine.Get(RentalLine."Contract Type"::Contract, SalesInvLine."EQM Contract No.", SalesInvLine."EQM Rental Line No.") then
                        if (not RentalLine."Non-Billable") and (not RentalLine."Rental Sale") then begin
                            RentalReturnEntry.Reset();
                            RentalReturnEntry.SetRange("Contract No.", SalesInvLine."EQM Contract No.");
                            RentalReturnEntry.SetRange("Ext. Rental Line No.", SalesInvLine."EQM Rental Line No.");
                            RentalReturnEntry.SetRange("Entry Type", RentalReturnEntry."Entry Type"::Shipment);
                            RentalReturnEntry.SetRange("Undo Entry", false);
                            RentalReturnEntry.SetRange("Fully Consumed Accessory", false);
                            RentalReturnEntry.SetRange("Shipment Date", 0D, RentalToDate);
                            RentalReturnEntry.CalcSums(Quantity);
                            NetQuantity := RentalReturnEntry.Quantity;

                            RentalReturnEntry.Reset();
                            RentalReturnEntry.SetRange("Contract No.", SalesInvLine."EQM Contract No.");
                            RentalReturnEntry.SetRange("Ext. Rental Line No.", SalesInvLine."EQM Rental Line No.");
                            RentalReturnEntry.SetRange("Entry Type", RentalReturnEntry."Entry Type"::Return);
                            RentalReturnEntry.SetRange("Undo Entry", false);
                            RentalReturnEntry.SetRange("Fully Consumed Accessory", false);
                            RentalReturnEntry.SetRange("Return Date", 0D, RentalToDate);
                            RentalReturnEntry.CalcSums(Quantity);
                            NetQuantity += RentalReturnEntry.Quantity;

                            NetQuantity := -NetQuantity;

                            if NetQuantity > 0 then begin
                                ItemNo := RentalLine."No.";
                                if ItemQuantities.ContainsKey(ItemNo) then
                                    ItemQuantities.Set(ItemNo, ItemQuantities.Get(ItemNo) + NetQuantity)
                                else begin
                                    ItemQuantities.Add(ItemNo, NetQuantity);
                                    ItemDescriptions.Add(ItemNo, RentalLine.Description);
                                end;
                            end;
                        end;
                end;
            until SalesInvLine.Next() = 0;

        ItemKeys := ItemQuantities.Keys();
        for i := 1 to ItemKeys.Count() - 1 do
            for j := i + 1 to ItemKeys.Count() do
                if ItemKeys.Get(j) < ItemKeys.Get(i) then begin
                    TempKey := ItemKeys.Get(i);
                    ItemKeys.Set(i, ItemKeys.Get(j));
                    ItemKeys.Set(j, TempKey);
                end;

        foreach ItemNo in ItemKeys do begin
            TotalQty := ItemQuantities.Get(ItemNo);
            InVerhuurQtyText += Format(TotalQty, 0, '<Integer>') + TypeHelper.CRLFSeparator();
            InVerhuurDescText += ItemDescriptions.Get(ItemNo) + TypeHelper.CRLFSeparator();
        end;

        if InVerhuurQtyText <> '' then
            InVerhuurHdrText := Format(RentalToDate + 1, 0, '<Day,2>-<Month,2>-<Year>');
    end;

    procedure IsReportInPreviewMode(): Boolean
    var
        MailManagement: Codeunit "Mail Management";
    begin
        exit(CurrReport.Preview() or MailManagement.IsHandlingGetEmailBody());
    end;
}
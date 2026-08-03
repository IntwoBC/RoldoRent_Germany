report 60007 "Purchase Order"
{
    Caption = 'Purchase - Order';
    PreviewMode = PrintLayout;
    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Src/Reports/PurchaseOrder/PurchaseOrder.rdlc';
    dataset
    {
        dataitem(PurchHdr; "Purchase Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") WHERE("Document Type" = CONST(Order));
            RequestFilterFields = "No.", "Buy-from Vendor No.", "No. Printed";
            RequestFilterHeading = 'Purchase Order';
            column(lblAllowInvDisc; Trl('AllowInvDisc')) { }
            column(lblAmount; Trl('Amount')) { }
            column(OutBoundText; OutBoundText) { }
            column(LocationAddr1; LocationAddr[1]) { }
            column(LocationAddr2; LocationAddr[2]) { }
            column(LocationAddr3; LocationAddr[3]) { }
            column(LocationAddr4; LocationAddr[4]) { }
            column(LocationAddr5; LocationAddr[5]) { }
            column(LocationAddr6; LocationAddr[6]) { }
            column(lblBankAccNo; Trl('BankAccNo')) { }
            column(lblBankName; Trl('BankName')) { }
            column(lblBuyFromAddress; Trl('BuyFromAddress')) { }
            column(lblBuyFromVendorNo; Trl('BuyFromVendorNo')) { }
            column(lblCompanyRegistrationNo; Trl('CompanyRegistrationNo')) { }
            column(lblDescription; Trl('Description')) { }
            column(lblDirectUnitCost; Trl('DirectUnitCost')) { }
            column(lblDocumentDate; Trl('DocumentDate')) { }
            column(lblDueDate; Trl('DueDate')) { }
            column(lblEmail; Trl('Email')) { }
            column(lblExpectedReceiptDate; Trl('ExpectedReceiptDate')) { }
            column(lblFaxNo; Trl('FaxNo')) { }
            column(lblGiroNo; Trl('GiroNo')) { }
            column(lblGLAccountNo; Trl('GLAccountNo')) { }
            column(lblHeaderDimensions; Trl('HeaderDimensions')) { }
            column(lblHomePage; Trl('HomePage')) { }
            column(lblIBAN; Trl('IBAN')) { }
            column(lblInvDiscAmount; Trl('InvDiscAmount')) { }
            column(lblInvDiscBaseAmount; Trl('InvDiscBaseAmount')) { }
            column(lblInvoiceDate; Trl('InvoiceDate')) { }
            column(lblInvoiceNo; Trl('InvoiceNo')) { }
            column(lblLineAmount; Trl('LineAmount')) { }
            column(lblLineDimensions; Trl('LineDimensions')) { }
            column(lblLineDiscountPerc; Trl('LineDiscountPerc')) { }
            column(lblNo; Trl('No')) { }
            column(lblOrderNo; Trl('OrderNo')) { }
            column(lblPageOf; Trl('Page{0}of{1}')) { }
            column(lblPaymentDiscountVAT; Trl('PaymentDiscountVAT')) { }
            column(lblPaymentTerms; Trl('Payment Terms')) { }
            column(lblPayToAddress; Trl('PayToVendorAddress')) { }
            column(lblPayToVendorNo; Trl('PayToVendorNo')) { }
            column(lblPhoneNo; Trl('PhoneNo')) { }
            column(lblPrepaymentPaymentTerms; Trl('PrepaymentPaymentTerms')) { }
            column(lblPrepaymentSpecification; Trl('PrepaymentSpecification')) { }
            column(lblPrepaymentVATSpecification; Trl('PrepaymentVATSpecification')) { }
            column(lblPricesInclVAT; Trl('PricesInclVAT')) { }
            column(lblPromisedReceiptDate; Trl('PromisedReceiptDate')) { }
            column(lblPurchPerson; Trl('Purchaser')) { }
            column(lblQuantity; Trl('Quantity')) { }
            column(lblRequestedReceiptDate; Trl('RequestedReceiptDate')) { }
            column(lblShipment; Trl('Shipment')) { }
            column(lblShipmentMethod; Trl('Shipment Method')) { }
            column(lblShipToAddress; Trl('ShipToAddress')) { }
            column(lblSubtotal; Trl('Subtotal')) { }
            column(lblSWIFT; Trl('SWIFT')) { }
            column(lblTotal; Trl('Total')) { }
            column(lblTotalTransFooter; Trl('TotalTransFooter')) { }
            column(lblTotalTransHeader; Trl('TotalTransHeader')) { }
            column(lblUOM; Trl('UOM')) { }
            column(lblVATAmount; Trl('VATAmount')) { }
            column(lblVATAmountSpecification; Trl('VATAmountSpecification')) { }
            column(lblVATBase; Trl('VATBase')) { }
            column(lblVATIdentifier; Trl('VATIdentifier')) { }
            column(lblVATPerc; Trl('VATPerc')) { }
            column(lblVATRegistrationNo; Trl('VAT Registration No.')) { }
            column(lblYourReference; Trl('Your Reference')) { }
            column(lblBIC; Trl('BIC')) { }
            column(lblPage; Trl('Page')) { }
            column(lblPaymentMethod; Trl('PaymentMethod')) { }
            column(lblTermsAndCond; Trl('TermsAndCond')) { }
            column(lblOrder; Trl('Order')) { }
            column(lblLine; Trl('Line')) { }
            column(LblComment; Trl('Comment')) { }
            column(lblTaxID; Trl('TaxID')) { }
            column(lblRoutingNo; Trl('RoutingNo')) { }
            column(lblLockbox; Trl('LockBox')) { }
            column(lblVendQuoteNo; Trl('VendQuoteNo')) { }
            column(lblPurchOrderNo; Trl('Purchase Order No.')) { }
            column(lblCostCenter; Trl('CostCenter')) { }
            column(lblProjectCode; Trl('ProjectCode')) { }
            column(BuyFromAddr1; EBuyFromAddr[1]) { }
            column(BuyFromAddr2; EBuyFromAddr[2]) { }
            column(BuyFromAddr3; EBuyFromAddr[3]) { }
            column(BuyFromAddr4; EBuyFromAddr[4]) { }
            column(BuyFromAddr5; EBuyFromAddr[5]) { }
            column(BuyFromAddr6; EBuyFromAddr[6]) { }
            column(BuyFromAddr7; EBuyFromAddr[7]) { }
            column(BuyFromAddr8; EBuyFromAddr[8]) { }
            column(BuyFromVendorNo; "Buy-from Vendor No.") { }
            column(CompanyAddr1; ECompanyAddr[1]) { }
            column(CompanyAddr2; ECompanyAddr[2]) { }
            column(CompanyAddr3; ECompanyAddr[3]) { }
            column(CompanyAddr4; ECompanyAddr[4]) { }
            column(CompanyAddr5; ECompanyAddr[5]) { }
            column(CompanyAddr6; ECompanyAddr[6]) { }
            column(CompanyAddr7; ECompanyAddr[7]) { }
            column(CompanyAddr8; ECompanyAddr[8]) { }
            column(CompanyBankAccNo; RecCompanyInfo."Bank Account No.") { }
            column(CompanyBankName; RecCompanyInfo."Bank Name") { }
            column(CompanyEMail; RecCompanyInfo."E-Mail") { }
            column(CompanyFaxNo; RecCompanyInfo."Fax No.") { }
            column(CompanyGiroNo; RecCompanyInfo."Giro No.") { }
            column(CompanyHomePage; RecCompanyInfo."Home Page") { }
            column(CompanyIBAN; RecCompanyInfo.IBAN) { }
            column(CompanyPhoneNo; RecCompanyInfo."Phone No.") { }
            column(CompanyPicture; RecCompanyInfo.Picture) { }
            column(CompanyRegistrationNo; RecCompanyInfo."Registration No.") { }
            column(CompanySWIFT; RecCompanyInfo."SWIFT Code") { }
            column(CompanyVATRegNo; RecCompanyInfo."VAT Registration No.") { }
            column(DocumentDate; "Document Date") { }
            column(DocumentDateText; FORMAT("Document Date", 0, '<Day> <Month Text> <Year4>')) { }
            column(DocumentNo; "No.") { }
            column(DueDate; "Due Date") { }
            column(DueDateText; FORMAT("Due Date", 0, '<Day> <Month Text> <Year4>')) { }
            column(HideLineDiscount; HideLineDiscount) { }
            column(LanguageCode; "Language Code") { }
            column(PaymentTermsDesc; "Payment Terms Code") { }
            column(PayToAddr1; PayToVendAddr[1]) { }
            column(PayToAddr2; PayToVendAddr[2]) { }
            column(PayToAddr3; PayToVendAddr[3]) { }
            column(PayToAddr4; PayToVendAddr[4]) { }
            column(PayToAddr5; PayToVendAddr[5]) { }
            column(PayToAddr6; PayToVendAddr[6]) { }
            column(PayToAddr7; PayToVendAddr[7]) { }
            column(PayToAddr8; PayToVendAddr[8]) { }
            column(PayToVendorNo; "Pay-to Vendor No.") { }
            column(PostingDate; "Posting Date") { }
            column(PostingDateText; FORMAT("Posting Date", 0, '<Day> <Month Text> <Year4>')) { }
            column(PricesInclVAT; "Prices Including VAT") { }
            column(PricesInclVATYesNo; FORMAT("Prices Including VAT")) { }
            column(SalesPurchPersonName; RecSalesPurchPerson.Name) { }
            column(SelltoCustNo; "Sell-to Customer No.") { }
            column(ShipmentMethodDesc; "Shipment Method Code") { }
            column(ShipToAddr1; ShipToAddr[1]) { }
            column(ShipToAddr2; ShipToAddr[2]) { }
            column(ShipToAddr3; ShipToAddr[3]) { }
            column(ShipToAddr4; ShipToAddr[4]) { }
            column(ShipToAddr5; ShipToAddr[5]) { }
            column(ShipToAddr6; ShipToAddr[6]) { }
            column(ShipToAddr7; ShipToAddr[7]) { }
            column(ShipToAddr8; ShipToAddr[8]) { }
            column(TotalText; TotalText) { }
            column(TotalExclVATText; TotalExclVATText) { }
            column(TotalInclVATText; TotalInclVATText) { }
            column(VALExchRate; VALExchRate) { }
            column(VALSpecLCYHeader; VALSpecLCYHeader) { }
            column(VATBaseDiscPerc; "VAT Base Discount %")
            {
                AutoFormatType = 1;
            }
            column(VATRegNo; VendorG."VAT Registration No.") { }
            column(YourReference; "Your Reference") { }
            column(CompanyLocation; IntCompanyLocation) { }
            column(SalesPurchPersonEMail; RecSalesPurchPerson."E-Mail") { }
            column(VendQuoteNo; "Vendor Order No.") { }
            column(TotalAmountInclVAT; TotalAmountInclVAT) { }
            column(TotLineAmount; TotLineAmount) { }
            column(VATAmtText; VATAmtLine.VATAmountText()) { }
            column(VATAmount; VATAmtLine."VAT Amount") { }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);
                column(OutputNo; OutputNo) { }
                column(PurchOrderTitle; STRSUBSTNO(Trl('PurchOrder%1'), CopyText)) { }
                dataitem(HdrComment; "Purch. Comment Line")
                {
                    DataItemLink = "Document Type" = FIELD("Document Type"), "No." = FIELD("No.");
                    DataItemLinkReference = PurchHdr;
                    DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.") WHERE("Document Line No." = CONST(0));
                    column(Comment_2; Comment)
                    {
                    }

                    trigger OnPreDataItem();
                    begin
                        if not ShowInternalInfo then
                            CurrReport.BREAK;
                    end;
                }
                dataitem(HeaderDim; "Dimension Set Entry")
                {
                    DataItemLink = "Dimension Set ID" = FIELD("Dimension Set ID");
                    DataItemLinkReference = PurchHdr;
                    DataItemTableView = SORTING("Dimension Set ID", "Dimension Code");
                    column(DimText; "Dimension Value Name") { }
                    trigger OnAfterGetRecord();
                    begin
                    end;

                    trigger OnPreDataItem();
                    begin
                        if not ShowInternalInfo then
                            CurrReport.BREAK;
                    end;
                }
                dataitem(PurchLine; "Purchase Line")
                {
                    DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");
                    UseTemporary = true;
                    column(Amount; Amount)
                    {
                        AutoFormatExpression = "Currency Code";
                        AutoFormatType = 1;
                    }
                    column(AmountInclVAT; "Amount Including VAT")
                    {
                        AutoFormatExpression = "Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Description; Description) { }
                    column(DirectUnitCost; "Direct Unit Cost")
                    {
                        AutoFormatExpression = "Currency Code";
                        AutoFormatType = 2;
                    }
                    column(ExpectedReceiptDate; "Expected Receipt Date") { }
                    column(InvDiscAmount; -"Inv. Discount Amount")
                    {
                        AutoFormatExpression = "Currency Code";
                        AutoFormatType = 1;
                    }
                    column(LineAmount; "Line Amount")
                    {
                        AutoFormatExpression = "Currency Code";
                        AutoFormatType = 1;
                    }
                    column(LineDiscPerc; "Line Discount %") { }
                    column(No_2; "No.") { }
                    column(PromisedReceiptDate; "Promised Receipt Date") { }
                    column(Quantity; Quantity) { }
                    column(RequestedReceiptDate; "Requested Receipt Date") { }
                    column(Type; FORMAT(Type)) { }
                    column(TypeNo; Type.AsInteger() + 0) { }
                    column(UOM; "Unit of Measure Code") { }
                    column(VATIdentifier; "VAT Identifier") { }
                    column(LineNo; "Line No.") { }
                    column(VendorItemNo; "Vendor Item No.") { }
                    column(CostCenter; "Shortcut Dimension 2 Code") { }
                    column(ProjectCode; "EQM Construction Project Code") { }
                    column(Unit_Cost; "Unit Cost") { }
                    column(Vendor_Item_No_; "Vendor Item No.") { }
                    dataitem(LineComment; "Sales Comment Line")
                    {
                        DataItemLink = "Document Type" = FIELD("Document Type"), "No." = FIELD("Document No."), "Document Line No." = FIELD("Line No.");
                        DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.");
                        column(Comment; LineComment.Comment) { }

                        trigger OnPreDataItem();
                        begin
                            if not ShowInternalInfo then
                                CurrReport.BREAK;
                        end;
                    }
                    dataitem(LineDim; "Dimension Set Entry")
                    {
                        DataItemLink = "Dimension Set ID" = FIELD("Dimension Set ID");
                        DataItemTableView = SORTING("Dimension Set ID", "Dimension Code");
                        column(DimText_2; "Dimension Value Name") { }

                        trigger OnAfterGetRecord();
                        begin
                        end;

                        trigger OnPreDataItem();
                        begin
                            if not ShowInternalInfo then
                                CurrReport.BREAK;
                        end;
                    }

                    trigger OnAfterGetRecord();
                    begin
                        if not PurchHdr."Prices Including VAT" and
                           (PurchLine."VAT Calculation Type" = PurchLine."VAT Calculation Type"::"Full VAT")
                        then
                            PurchLine."Line Amount" := 0;

                        Clear(No);
                        if "Vendor Item No." <> '' then
                            No := "Vendor Item No."
                        else
                            No := "No.";

                    end;

                    trigger OnPreDataItem();
                    var
                        wlMoreLines: Boolean;
                    begin
                        RESET;
                        wlMoreLines := PurchLine.FIND('+');
                        while wlMoreLines and (PurchLine.Description = '') and (PurchLine."Description 2" = '') and
                              (PurchLine."No." = '') and (PurchLine.Quantity = 0) and
                              (PurchLine.Amount = 0)
                        do
                            wlMoreLines := PurchLine.NEXT(-1) <> 0;
                        if not wlMoreLines then
                            CurrReport.BREAK;
                        PurchLine.SETRANGE("Line No.", 0, PurchLine."Line No.");
                    end;
                }
                dataitem(VATAmtLine; "VAT Amount Line")
                {
                    DataItemTableView = SORTING("VAT Identifier", "VAT Calculation Type", "Tax Group Code", "Use Tax", Positive);
                    UseTemporary = true;
                    column(InvDiscAmount_2; "Invoice Discount Amount")
                    {
                        AutoFormatExpression = PurchHdr."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(InvDiscBaseAmount; "Inv. Disc. Base Amount")
                    {
                        AutoFormatExpression = PurchHdr."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(LineAmount_2; "Line Amount")
                    {
                        AutoFormatExpression = PurchHdr."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(VATBase; "VAT Base")
                    {
                        AutoFormatExpression = PurchHdr."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(VATIdentifier_2; "VAT Identifier") { }
                    column(VATPerc; "VAT %")
                    {
                        DecimalPlaces = 0 : 5;
                    }

                    trigger OnPreDataItem();
                    begin
                        if TotVATAmount = 0 then
                            CurrReport.BREAK;

                        RESET;
                    end;
                }
                dataitem(VATAmtLineLCY; "VAT Amount Line")
                {
                    DataItemTableView = SORTING("VAT Identifier", "VAT Calculation Type", "Tax Group Code", "Use Tax", Positive);
                    UseTemporary = true;
                    column(VALVATBaseLCY; VALVATBaseLCY)
                    {
                        AutoFormatType = 1;
                    }
                    column(VALVATAmountLCY; VALVATAmountLCY)
                    {
                        AutoFormatType = 1;
                    }
                    column(VATIdentifier_3; "VAT Identifier") { }
                    column(VATPerc_2; "VAT %")
                    {
                        DecimalPlaces = 0 : 5;
                    }

                    trigger OnAfterGetRecord();
                    begin
                        VALVATBaseLCY :=
                          VATAmtLine.GetBaseLCY(
                            PurchHdr."Posting Date", PurchHdr."Currency Code", PurchHdr."Currency Factor");
                        VALVATAmountLCY :=
                          VATAmtLine.GetAmountLCY(
                            PurchHdr."Posting Date", PurchHdr."Currency Code", PurchHdr."Currency Factor");

                        TotVALVATBaseLCY += VALVATBaseLCY;
                        TotVALVATAmountLCY += VALVATAmountLCY;
                    end;

                    trigger OnPreDataItem();
                    begin
                        if not ShowVATLCY then
                            CurrReport.BREAK;

                        VATAmtLineLCY.COPY(VATAmtLine, true); //Set VATAmtLineLCY to VATAmtLine
                        RESET;
                    end;
                }
                dataitem(TermsAndConditions; "Integer")
                {
                    DataItemTableView = SORTING(Number) ORDER(Ascending) WHERE(Number = CONST(1));
                    column(PaymentMethodDesc; PurchHdr."Payment Method Code") { }
                    column(RequestedReceiptDate_2; FORMAT(PurchHdr."Requested Receipt Date", 0, '<Day> <Month Text> <Year4>')) { }
                }
                dataitem(Total; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    column(MonolithicVAT; MonolithicVAT) { }
                    column(NoOfVATAmtLines; NoOfVATAmountLines) { }
                    column(TotAmount; TotAmount)
                    {
                        AutoFormatExpression = PurchHdr."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(TotInvDiscAmount; TotInvDiscAmount) { }
                    column(TotInvDiscBaseAmount; TotInvDiscBaseAmount) { }
                    column(TotPaymentDiscOnVAT; TotPaymentDiscOnVAT)
                    {
                        AutoFormatExpression = PurchHdr."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(TotVATAmount; TotVATAmount)
                    {
                        AutoFormatExpression = PurchHdr."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(TotVALVATBaseLCY; TotVALVATBaseLCY) { }
                    column(TotVALVATAmountLCY; TotVALVATAmountLCY) { }

                    trigger OnAfterGetRecord();
                    begin
                        NoOfVATAmountLines := VATAmtLine.COUNT;
                        //wgMonolithicVAT := wgCduDocCreatorReportFunctions.wgFncIsMonolithicVAT(VATAmtLine);//Krishna
                        if MonolithicVAT then
                            VATAmountText := STRSUBSTNO(Trl('TotalVATAmount%1Perc'), VATAmtLine."VAT %")
                        else
                            VATAmountText := Trl('TotalVATAmount');
                    end;
                }
                dataitem(PrepmtLine; "Prepayment Inv. Line Buffer")
                {
                    DataItemTableView = SORTING(Adjustment);
                    UseTemporary = true;
                    column(LineAmount_3; PrepmtLineAmount)
                    {
                        AutoFormatExpression = PurchHdr."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Description_2; Description) { }
                    column(GLAccountNo; "G/L Account No.") { }
                    column(Amount_2; Amount)
                    {
                        AutoFormatExpression = PurchHdr."Currency Code";
                        AutoFormatType = 1;
                    }
                    dataitem(PrepmtDim; "Dimension Set Entry")
                    {
                        DataItemLink = "Dimension Set ID" = FIELD("Dimension Set ID");
                        DataItemTableView = SORTING("Dimension Set ID", "Dimension Code");
                        column(DimText_3; "Dimension Value Name")// wgDimText)
                        {
                        }

                        trigger OnAfterGetRecord();
                        begin
                            // wgCduDocCreatorReportFunctions.wgFncGetDimText(PrepmtDim, wgDimText);
                        end;

                        trigger OnPreDataItem();
                        begin
                            if not ShowInternalInfo then
                                CurrReport.BREAK;
                        end;
                    }

                    trigger OnAfterGetRecord();
                    begin
                        if PurchHdr."Prices Including VAT" then
                            PrepmtLineAmount := "Amount Incl. VAT"
                        else
                            PrepmtLineAmount := Amount;
                    end;

                    trigger OnPreDataItem();
                    begin
                        RESET;
                    end;
                }
                dataitem(PrepmtVATAmtLine; "VAT Amount Line")
                {
                    DataItemTableView = SORTING("VAT Identifier", "VAT Calculation Type", "Tax Group Code", "Use Tax", Positive);
                    UseTemporary = true;
                    column(VATAmount_2; "VAT Amount")
                    {
                        AutoFormatExpression = PurchHdr."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(VATBase_2; "VAT Base")
                    {
                        AutoFormatExpression = PurchHdr."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(LineAmount_4; "Line Amount")
                    {
                        AutoFormatExpression = PurchHdr."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(VATPerc_3; "VAT %")
                    {
                        DecimalPlaces = 0 : 5;
                    }
                    column(VATIdentifier_4; "VAT Identifier") { }
                }
                dataitem(PrepmtTotal; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    column(TotPrepmtLineAMount; TotPrepmtLineAmount) { }
                    column(TotPrepmtVATAmount; TotPrepmtVATAmount) { }
                    column(TotPrepmtAmount; TotPrepmtAmount) { }
                    column(VATAmtText_2; VATAmountText) { }

                    trigger OnAfterGetRecord();
                    begin
                        NoOfVATAmountLines := VATAmtLine.COUNT;
                        if MonolithicVAT then
                            VATAmountText := STRSUBSTNO(Trl('TotalVATAmount%1Perc'), VATAmtLine."VAT %")
                        else
                            VATAmountText := Trl('TotalVATAmount');
                    end;
                }

                trigger OnAfterGetRecord();
                begin
                    if Number > 1 then begin
                        CopyText := Trl('Copy');
                        OutputNo += 1;
                    end;

                    TotVALVATBaseLCY := 0;
                    TotVALVATAmountLCY := 0;
                end;

                trigger OnPostDataItem();
                begin
                    if not CurrReport.PREVIEW then
                        CODEUNIT.RUN(CODEUNIT::"Purch.Header-Printed", PurchHdr);
                end;

                trigger OnPreDataItem();
                begin
                    NoOfLoops := ABS(NoOfCopies) + 1;
                    CopyText := '';
                    SETRANGE(Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord();
            var
                wlRecTempPrepmtPurchLine: Record "Purchase Line" temporary;
                wlRecTempPurchLine: Record "Purchase Line" temporary;
                wlRecTempPrepmtVATAmountLineDeduct: Record "VAT Amount Line" temporary;
                wlCduPurchPost: Codeunit "Purch.-Post";
                wlRecRef: RecordRef;
                CountryRegionL: Record "Country/Region";
            begin

                ShipToAddr[1] := PurchHdr."Ship-to Name";
                ShipToAddr[2] := PurchHdr."Ship-to Contact";
                ShipToAddr[3] := PurchHdr."Ship-to Address";
                ShipToAddr[4] := PurchHdr."Ship-to Address 2";
                ShipToAddr[5] := PurchHdr."Ship-to City";
                ShipToAddr[6] := PurchHdr."Ship-to County";
                ShipToAddr[7] := PurchHdr."Ship-to Post Code";
                Clear(CountryRegionL);
                if CountryRegionL.Get(PurchHdr."Ship-to Country/Region Code") then;
                ShipToAddr[8] := CountryRegionL.Name;

                EBuyFromAddr[1] := PurchHdr."Buy-from Vendor Name";
                EBuyFromAddr[2] := PurchHdr."Buy-from Contact";
                EBuyFromAddr[3] := PurchHdr."Buy-from Address";
                EBuyFromAddr[4] := PurchHdr."Buy-from Address 2";
                EBuyFromAddr[5] := PurchHdr."Buy-from City";
                EBuyFromAddr[6] := PurchHdr."Buy-from County";
                EBuyFromAddr[7] := PurchHdr."Buy-from Post Code";
                Clear(CountryRegionL);
                if CountryRegionL.Get(PurchHdr."Buy-from Country/Region Code") then;
                EBuyFromAddr[8] := CountryRegionL.Name;

                FormatAddressFields(PurchHdr);
                UpdatePhEmailHP(PurchHdr);
                FormatDocumentFields(PurchHdr);


                if not CurrReport.PREVIEW then begin
                    if ArchiveDocument then
                        CduArchiveManagement.StorePurchDocument(PurchHdr, LogInteraction);

                    if LogInteraction then begin
                        CALCFIELDS("No. of Archived Versions");
                        CduSegManagement.LogDocument(
                          13, "No.", "Doc. No. Occurrence", "No. of Archived Versions", DATABASE::Vendor, "Buy-from Vendor No.",
                          "Purchaser Code", '', "Posting Description", '');
                    end;
                end;

                CLEAR(wlCduPurchPost);
                PurchLine.RESET;
                PurchLine.DELETEALL;
                VATAmtLine.RESET;
                VATAmtLine.DELETEALL;
                wlCduPurchPost.GetPurchLines(PurchHdr, PurchLine, 0);

                PurchLine.CalcVATAmountLines(0, PurchHdr, PurchLine, VATAmtLine);
                PurchLine.UpdateVATOnLines(0, PurchHdr, PurchLine, VATAmtLine);

                TotInvDiscAmount := VATAmtLine.GetTotalInvDiscAmount;
                TotInvDiscBaseAmount := VATAmtLine.GetTotalInvDiscBaseAmount(PurchHdr."Prices Including VAT", PurchHdr."Currency Code");
                TotLineAmount := VATAmtLine.GetTotalLineAmount(PurchHdr."Prices Including VAT", PurchHdr."Currency Code");
                TotVATAmount := VATAmtLine.GetTotalVATAmount;
                TotPaymentDiscOnVAT := -(TotLineAmount - TotInvDiscAmount - VATAmtLine.GetTotalAmountInclVAT);
                TotAmount := VATAmtLine.GetTotalVATBase;

                if (not RecGLSetup."Print VAT specification in LCY") or
                   (PurchHdr."Currency Code" = '') or
                   (VATAmtLine.GetTotalVATAmount = 0)
                then begin
                    ShowVATLCY := false;
                    VALSpecLCYHeader := '';
                    VALExchRate := '';
                end
                else begin
                    ShowVATLCY := true;
                    if RecGLSetup."LCY Code" = '' then
                        VALSpecLCYHeader := Trl('VATAmtSpecIn') + ' ' + Trl('LocalCurrency')
                    else
                        VALSpecLCYHeader := Trl('VATAmtSpecIn') + ' ' + FORMAT(RecGLSetup."LCY Code");
                    RecCurrExchRate.FindCurrency(PurchHdr."Posting Date", PurchHdr."Currency Code", 1);
                    VALExchRate := STRSUBSTNO(Trl('ExchangeRate%1/%2'), RecCurrExchRate."Relational Exch. Rate Amount", RecCurrExchRate."Exchange Rate Amount");
                end;

                PrepmtLine.RESET;
                PrepmtLine.DELETEALL;
                PrepmtVATAmtLine.RESET;
                PrepmtVATAmtLine.DELETEALL;
                CduPurchPostPrepmt.GetPurchLines(PurchHdr, 0, wlRecTempPrepmtPurchLine);

                if not wlRecTempPrepmtPurchLine.ISEMPTY then begin
                    CduPurchPostPrepmt.GetPurchLinesToDeduct(PurchHdr, wlRecTempPurchLine);
                    if not wlRecTempPurchLine.ISEMPTY then
                        CduPurchPostPrepmt.CalcVATAmountLines(PurchHdr, wlRecTempPurchLine, wlRecTempPrepmtVATAmountLineDeduct, 1);
                end;

                CduPurchPostPrepmt.CalcVATAmountLines(PurchHdr, wlRecTempPrepmtPurchLine, PrepmtVATAmtLine, 0);
                DeductVATAmountLine(PrepmtVATAmtLine, wlRecTempPrepmtVATAmountLineDeduct);
                CduPurchPostPrepmt.UpdateVATOnLines(PurchHdr, wlRecTempPrepmtPurchLine, PrepmtVATAmtLine, 0);
                CduPurchPostPrepmt.BuildInvLineBuffer(PurchHdr, wlRecTempPrepmtPurchLine, 0, PrepmtLine);
                TotPrepmtLineAmount := VATAmtLine.GetTotalLineAmount(PurchHdr."Prices Including VAT", PurchHdr."Currency Code");
                TotPrepmtVATAmount := VATAmtLine.GetTotalVATAmount;
                TotPrepmtAmount := PrepmtVATAmtLine.GetTotalVATBase;
                wlRecRef.GETTABLE(PurchHdr);
                Clear(TotalAmountInclVAT);
                TotalAmountInclVAT := VATAmtLine.GetTotalAmountInclVAT;
                Clear(VendorG);
                if VendorG.Get("Buy-from Vendor No.") then;

                OutBoundText := GetOutboundMemoL(PurchHdr);
                LocationAddress(PurchHdr);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NoOfCopies; NoOfCopies)
                    {
                        Caption = 'No. of Copies';
                        ApplicationArea = All;
                    }
                    field(ShowInternalInfo; ShowInternalInfo)
                    {
                        Caption = 'Show Internal Information';
                        ApplicationArea = All;
                    }
                    field(ArchiveDocument; ArchiveDocument)
                    {
                        Caption = 'Archive Document';
                        ApplicationArea = All;

                        trigger OnValidate();
                        begin
                            if not ArchiveDocument then
                                LogInteraction := false;
                        end;
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ApplicationArea = All;

                        trigger OnValidate();
                        begin
                            if LogInteraction then
                                ArchiveDocument := ArchiveDocumentEnable;
                        end;
                    }
                }
            }
        }

        trigger OnInit();
        begin
            LogInteractionEnable := true;
        end;

        trigger OnOpenPage();
        var
            DocumentTypeL: Enum "Interaction Log Entry Document Type";
        begin
            LogInteraction := CduSegManagement.FindInteractionTemplateCode(DocumentTypeL::"Purch. Ord.") <> '';
            LogInteractionEnable := LogInteraction;
            NoOfCopies := 0;
        end;
    }
    trigger OnInitReport();
    begin
        RecGLSetup.GET;
        RecPurchSetup.GET;
        RecCompanyInfo.GET;
        RecCompanyInfo.CALCFIELDS(Picture);
    end;

    trigger OnPreReport();
    begin
        if CurrReport.USEREQUESTPAGE = false then
            NoOfCopies := 0;
    end;

    var
        RecLanguage: Record Language;
        RecSalesPurchPerson: Record "Salesperson/Purchaser";
        RecCompanyInfo: Record "Company Information";
        RecGLSetup: Record "General Ledger Setup";
        RecPurchSetup: Record "Purchases & Payables Setup";
        RecCurrExchRate: Record "Currency Exchange Rate";
        CduFormatAddr: Codeunit "Format Address";
        CduFormatDoc: Codeunit "Format Document";
        CduPurchPostPrepmt: Codeunit "Purchase-Post Prepayments";
        CduSegManagement: Codeunit SegManagement;
        CduArchiveManagement: Codeunit ArchiveManagement;
        EBuyFromAddr: array[8] of Text[50];
        ECompanyAddr: array[8] of Text[50];
        CompanyInfoFaxNo: Text;
        CompanyInfoPhoneNo: Text;
        CopyText: Text[30];
        DimText: Text[120];
        PayToVendAddr: array[8] of Text[50];
        EShipToAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        LocationAddr: array[8] of Text[50];

        TotalExclVATText: Text[50];
        TotalInclVATText: Text[50];
        TotalText: Text[50];
        VALExchRate: Text[50];
        VALSpecLCYHeader: Text[80];
        VATAmountText: Text[30];
        PrepmtLineAmount: Decimal;
        TotAmount: Decimal;
        TotInvDiscAmount: Decimal;
        TotInvDiscBaseAmount: Decimal;
        TotLineAmount: Decimal;
        TotPaymentDiscOnVAT: Decimal;
        TotPrepmtAmount: Decimal;
        TotPrepmtLineAmount: Decimal;
        TotPrepmtVATAmount: Decimal;
        TotVALVATAmountLCY: Decimal;
        TotVALVATBaseLCY: Decimal;
        TotVATAmount: Decimal;
        VALVATAmountLCY: Decimal;
        VALVATBaseLCY: Decimal;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        NoOfVATAmountLines: Integer;
        OutputNo: Integer;
        ReportId: Integer;
        ArchiveDocument: Boolean;
        ArchiveDocumentEnable: Boolean;
        HideLineDiscount: Boolean;
        LogInteraction: Boolean;
        LogInteractionEnable: Boolean;
        MonolithicVAT: Boolean;
        ShowInternalInfo: Boolean;
        ShowVATLCY: Boolean;
        IntCompanyLocation: Integer;
        TxtCostCenter: Text[100];
        TxtProjectCode: Text[50];
        TotalAmountInclVAT: Decimal;
        VendorG: Record Vendor;
        No: Code[50];
        OutBoundText: Text[2048];

    local procedure Trl(pLblName: Text): Text;
    begin
        exit(pLblName);
    end;

    procedure InitializeRequest(pNoOfCopiesFrom: Integer; pShowInternalInfoFrom: Boolean; pArchiveDocumentFrom: Boolean; pLogInteractionFrom: Boolean);
    begin
        NoOfCopies := pNoOfCopiesFrom;
        ShowInternalInfo := pShowInternalInfoFrom;
        ArchiveDocument := pArchiveDocumentFrom;
        LogInteraction := pLogInteractionFrom;
    end;

    local procedure GetOutboundMemoL(var PurchHeader: Record "Purchase Header"): Text
    var
        InS: InStream;
        TempText: Text;
        LineText: Text;
        NewLine: Text[4];
    begin
        //NewLine := '\r\n';

        PurchHeader.CalcFields("I2I Inbound Memo Text");

        if PurchHeader."I2I Inbound Memo Text".HasValue then begin
            PurchHeader."I2I Inbound Memo Text".CreateInStream(InS);

            while not InS.EOS do begin
                InS.ReadText(LineText);
                TempText += LineText;
            end;
        end;

        exit(TempText);
    end;

    procedure DeductVATAmountLine(var VATAmounLine: Record "VAT Amount Line"; var VATAmountLineDeduct: Record "VAT Amount Line");
    begin
        if VATAmounLine.FINDSET then
            repeat
                VATAmountLineDeduct := VATAmounLine;
                if VATAmountLineDeduct.FIND then begin
                    VATAmounLine."VAT Base" -= VATAmountLineDeduct."VAT Base";
                    VATAmounLine."VAT Amount" -= VATAmountLineDeduct."VAT Amount";
                    VATAmounLine."Amount Including VAT" -= VATAmountLineDeduct."Amount Including VAT";
                    VATAmounLine."Line Amount" -= VATAmountLineDeduct."Line Amount";
                    VATAmounLine."Inv. Disc. Base Amount" -= VATAmountLineDeduct."Inv. Disc. Base Amount";
                    VATAmounLine."Invoice Discount Amount" -= VATAmountLineDeduct."Invoice Discount Amount";
                    VATAmounLine."Calculated VAT Amount" -= VATAmountLineDeduct."Calculated VAT Amount";
                    VATAmounLine."VAT Difference" -= VATAmountLineDeduct."VAT Difference";
                    VATAmounLine.MODIFY;
                end;
            until VATAmounLine.NEXT = 0;
    end;

    local procedure FormatDocumentFields(pRecPurchHeader: Record "Purchase Header");
    var
        PurchPersonText: Text[30];
        CurrencyCode: Code[10];
    begin
        CurrencyCode := pRecPurchHeader."Currency Code";
        if CurrencyCode = '' then begin
            RecGLSetup.TESTFIELD("LCY Code");
            CurrencyCode := RecGLSetup."LCY Code";
        end;
        TotalText := STRSUBSTNO(Trl('Total%1'), CurrencyCode);
        TotalInclVATText := STRSUBSTNO(Trl('Totaal %1 incl. btw'), CurrencyCode);
        TotalExclVATText := STRSUBSTNO(Trl('Totaal %1 excl. btw'), CurrencyCode);
        CduFormatDoc.SetPurchaser(RecSalesPurchPerson, pRecPurchHeader."Purchaser Code", PurchPersonText);
    end;

    local procedure FormatAddressFields(var vRecPurchHeader: Record "Purchase Header");
    var
        RespCenter: Record "Responsibility Center";
    begin
        CduFormatAddr.GetCompanyAddr(vRecPurchHeader."Responsibility Center", RespCenter, RecCompanyInfo, ECompanyAddr);
        CompanyInfoPhoneNo := RecCompanyInfo."Phone No.";
        CompanyInfoFaxNo := RecCompanyInfo."Fax No.";
        CduFormatAddr.PurchHeaderPayTo(PayToVendAddr, vRecPurchHeader);
        CduFormatAddr.PurchHeaderShipTo(EShipToAddr, vRecPurchHeader);
        CduFormatAddr.PurchHeaderBuyFrom(EBuyFromAddr, vRecPurchHeader);
    end;

    procedure UpdatePhEmailHP(PurchaseHeader: Record "Purchase Header")
    var
        Customer: Record Customer;
        CustomerPosting: Record "Customer Posting Group";
        CompanyInfoL: Record "Company Information";
    begin
        CompanyInfoL.Get();

        RecCompanyInfo."Phone No." := CompanyInfoL."Phone No.";
        RecCompanyInfo."E-Mail" := CompanyInfoL."E-Mail";
        RecCompanyInfo."Home Page" := CompanyInfoL."Home Page";

        if PurchaseHeader."Sell-to Customer No." = '' then
            exit;

        if not Customer.Get(PurchaseHeader."Sell-to Customer No.") then
            exit;

        if not CustomerPosting.Get(Customer."Customer Posting Group") then
            exit;

        if (CustomerPosting.Code = 'AUSTRIA') or (CustomerPosting.Description = 'AUSTRIA') then begin
            RecCompanyInfo."Phone No." := CompanyInfoL."I2I Phone No. AT";
            RecCompanyInfo."E-Mail" := CompanyInfoL."I2I Email AT";
            RecCompanyInfo."Home Page" := CompanyInfoL."I2I Home Page AT";
        end else
            if (CustomerPosting.Code = 'SCHWEIZ') or (CustomerPosting.Description = 'SCHWEIZ') then begin
                RecCompanyInfo."Phone No." := CompanyInfoL."I2I Phone No. CH";
                RecCompanyInfo."E-Mail" := CompanyInfoL."I2I Email CH";
                RecCompanyInfo."Home Page" := CompanyInfoL."I2I Home Page CH";
            end;
    end;

    procedure LocationAddress(PurchaseHeader: Record "Purchase Header")
    var
        LineNo: Integer;
        Customer: Record Customer;
        Country: Record "Country/Region";
        Location: Record Location;
    begin
        LineNo := 1;

        if not Location.Get(PurchaseHeader."Location Code") then
            exit;

        // Name
        if Location.Name <> '' then begin
            LocationAddr[LineNo] := Location.Name;
            LineNo += 1;
        end;

        // Name 2
        if Location."Name 2" <> '' then begin
            LocationAddr[LineNo] := Location."Name 2";
            LineNo += 1;
        end;

        // Address 1
        if Location.Address <> '' then begin
            LocationAddr[LineNo] := Location.Address;
            LineNo += 1;
        end;

        // Address 2
        if Location."Address 2" <> '' then begin
            LocationAddr[LineNo] := Location."Address 2";
            LineNo += 1;
        end;

        // Post Code + City
        if (Location."Post Code" <> '') or (Location.City <> '') then begin
            LocationAddr[LineNo] := Location."Post Code" + ' ' + Location.City;
            LineNo += 1;
        end;

        // // County
        // if Location.County <> '' then begin
        //     LocationAddr[LineNo] := Location.County;
        //     LineNo += 1;
        // end;

        // Country
        if Location."Country/Region Code" <> '' then begin
            Country.Get(Location."Country/Region Code");
            LocationAddr[LineNo] := Country.Name;
        end;
    end;
}
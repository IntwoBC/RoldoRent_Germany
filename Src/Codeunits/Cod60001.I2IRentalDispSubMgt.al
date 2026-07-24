codeunit 60001 "I2I Rental Disp. Sub Mgt"
{

    procedure InsertGLLine(RentalHeader: Record "EQM Rental Header"; RentalQty: Decimal; IsPreview: Boolean; ExternalDocumentNo: Code[35]; CustomerProject: Code[20]; ReturnDate: Date)
    var
        GLSetup: Record "General Ledger Setup";
        RentalLine: Record "EQM Rental Line";
        LineNo: Integer;
        GLAccount: Record "G/L Account";
    begin
        LineNo := 0;

        GLSetup.Get();
        RentalLine.Reset();
        RentalLine.SetRange("Contract Type", RentalHeader."Contract Type");
        RentalLine.SetRange("Contract No.", RentalHeader."Contract No.");
        if RentalLine.FindLast() then
            LineNo := RentalLine."Line No." + 10000
        else
            LineNo := 10000;

        Clear(RentalLine);
        RentalLine.Init();
        RentalLine."Contract Type" := RentalHeader."Contract Type";
        RentalLine."Contract No." := RentalHeader."Contract No.";
        RentalLine."Line No." := LineNo;
        RentalLine.Type := RentalLine.Type::"G/L Account";
        RentalLine.Validate("No.", GLSetup."I2I Rental Col. Rev. G/L Acc");
        RentalLine."Rental Sale" := true;
        if GLAccount.Get(GLSetup."I2I Rental Col. Rev. G/L Acc") then
            RentalLine.Description := GLAccount.Name;
        RentalLine.Validate(Quantity, 1);
        if RentalQty <= GLSetup."I2I Rental Quantity Threshold" then
            RentalLine.Validate("Unit Price", GLSetup."I2I Rental Price Bel. Thres.")
        else
            RentalLine.Validate("Unit Price", GLSetup."I2I Rental Price Abv. Thres.");
        RentalLine."I2I External Document No." := ExternalDocumentNo;
        RentalLine."Customer Project" := CustomerProject;
        RentalLine."Line Amount (Period)" := RentalLine."Unit Price" * RentalLine.Quantity;
        //RentalLine."Location Code" := LocationCode;
        RentalLine.Validate("Shipment Date", ReturnDate);
        if not IsPreview then
            RentalLine.Insert();
    end;

    procedure InsertTransportGLLine(RentalHeader: Record "EQM Rental Header"; TransportCharges: Decimal; IsPreview: Boolean; ExternalDocumentNo: Code[35]; CustomerProject: Code[20]; ReturnDate: Date)
    var
        GLSetup: Record "General Ledger Setup";
        RentalLine: Record "EQM Rental Line";
        LineNo: Integer;
        GLAccount: Record "G/L Account";
    begin
        LineNo := 0;

        GLSetup.Get();
        GLSetup.TestField("I2I Transp. Rev. G/L Acc");

        RentalLine.Reset();
        RentalLine.SetRange("Contract Type", RentalHeader."Contract Type");
        RentalLine.SetRange("Contract No.", RentalHeader."Contract No.");
        if RentalLine.FindLast() then
            LineNo := RentalLine."Line No." + 10000
        else
            LineNo := 10000;

        Clear(RentalLine);
        RentalLine.Init();
        RentalLine."Contract Type" := RentalHeader."Contract Type";
        RentalLine."Contract No." := RentalHeader."Contract No.";
        RentalLine."Line No." := LineNo;
        RentalLine.Type := RentalLine.Type::"G/L Account";
        RentalLine.Validate("No.", GLSetup."I2I Transp. Rev. G/L Acc");
        RentalLine."Rental Sale" := true;
        if GLAccount.Get(GLSetup."I2I Transp. Rev. G/L Acc") then
            RentalLine.Description := GLAccount.Name;
        RentalLine.Validate(Quantity, 1);
        RentalLine."Unit Price" := TransportCharges;
        RentalLine."Line Amount (Period)" := RentalLine."Unit Price" * RentalLine.Quantity;
        RentalLine."I2I External Document No." := ExternalDocumentNo;
        RentalLine."Customer Project" := CustomerProject;
        //RentalLine."Location Code" := LocationCode;
        RentalLine.Validate("Shipment Date", ReturnDate);
        if not IsPreview then
            RentalLine.Insert();
    end;


    local procedure HandleRentalPosting(RentalShptHeader: Record "EQM Rental Dispatch Header"; IsPreview: Boolean)
    var
        RentalColleclines: Record "EQM Rental Dispatch Line";
        PostCollectLine: Record "EQM Rental Posted Coll. Line";
        RentalHeader: Record "EQM Rental Header";
        RentalQty: Decimal;
        RentalContractPage: Page "EQM Rental Contract";
    begin
        RentalQty := 0;

        RentalColleclines.SetRange("Document No.", RentalShptHeader."No.");
        RentalColleclines.SetRange(Type, RentalColleclines.Type::Item);
        if RentalColleclines.FindSet() then
            repeat
                RentalQty += RentalColleclines."Qty. to Collect";
            until RentalColleclines.Next() = 0;

        RentalHeader.SetRange("Contract No.", GetOldContractID(RentalShptHeader));
        if RentalHeader.FindFirst() then begin
            if RentalShptHeader."I2I Handling Fee" then
                InsertGLLine(RentalHeader, RentalQty, IsPreview, RentalShptHeader."I2I External Document No.", RentalShptHeader."Customer Project", RentalShptHeader."Return Date");

            if RentalShptHeader."I2I Transportation Charges" then
                InsertTransportGLLine(RentalHeader, RentalShptHeader."I2I Transportation Cost", IsPreview, RentalShptHeader."I2I External Document No.", RentalShptHeader."Customer Project", RentalShptHeader."Return Date");

            ExecuteShipAll(RentalHeader."Contract No.");
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"EQM Rental Ship-Post Coll.", OnBeforeRentalShptPostCollection, '', false, false)]
    local procedure OnBeforeRentalShptPostCollection(var RentalDispHeader: Record "EQM Rental Dispatch Header")
    begin
        HandleRentalPosting(RentalDispHeader, false);
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"EQM Rental Ship-Post Coll.", OnAfterRentalShptPostCollection, '', false, false)]
    // local procedure OnAfterRentalShptPostCollection(var RentalDispHeader: Record "EQM Rental Dispatch Header")
    // begin
    //     ExecuteShipAll(RentalDispHeader."Contract No.");
    // end;

    [EventSubscriber(ObjectType::Page, Page::"EQM Rental Collection Order", OnBeforePostDoc, '', false, false)]
    local procedure OnBeforePostDoc(var RentalDispatchHeader: Record "EQM Rental Dispatch Header"; PostingCodeunitID: Integer; Navigate: Enum "Navigate After Posting")
    var
        RentalColleclines: Record "EQM Rental Dispatch Line";
        GLSetup: Record "General Ledger Setup";
    begin
        RentalDispatchHeader.TestField("I2I External Document No.");

        if RentalDispatchHeader."Receiving Location Code" = '' then
            Error('Receiving Location Code must not be blank before posting.');
        if RentalDispatchHeader."I2I Transportation Charges" then
            if RentalDispatchHeader."I2I Transportation Cost" <= 0 then
                Error('Transportation Charges is enabled. Please enter a valid Transportation Cost before posting.');

        if not GLSetup.Get() then
            Error('General Ledger Setup must be configured.');

        GLSetup.TestField("I2I Rental Col. Rev. G/L Acc");
        GLSetup.TestField("I2I Transp. Rev. G/L Acc");
    end;

    [EventSubscriber(ObjectType::Page, Page::"EQM Rental Collection Order", OnBeforeShowPostedConfirmationMessage, '', false, false)]
    local procedure OnRunPreviewOnAfterSetPostingFlags(var RentalDispatchHeader: Record "EQM Rental Dispatch Header"; var PostedDispatchHeader: Record "EQM Rental Posted Coll. Header"; var IsHandled: Boolean)
    var
        GLSetup: Record "General Ledger Setup";
    begin
        if not GLSetup.Get() then
            Error('General Ledger Setup must be configured.');

        RentalDispatchHeader.TestField("I2I External Document No.");

        if RentalDispatchHeader."Receiving Location Code" = '' then
            Error('Receiving Location Code must not be blank before posting.');
        if RentalDispatchHeader."I2I Transportation Charges" then
            if RentalDispatchHeader."I2I Transportation Cost" <= 0 then
                Error('Transportation Charges is enabled. Please enter a valid Transportation Cost before posting.');

        HandleRentalPosting(RentalDispatchHeader, true);
    end;

    procedure GetOldContractID(RenntalShptHdr: Record "EQM Rental Dispatch Header"): Code[20]
    var
        RentalShptLine: Record "EQM Rental Dispatch Line";
        OldContractID: Code[20];
        NewContractID: Code[20];
    begin
        RentalShptLine.SetRange("Document Type", RenntalShptHdr."Document Type");
        RentalShptLine.SetRange("Document No.", RenntalShptHdr."No.");
        RentalShptLine.SetRange(Type, RentalShptLine.Type::Item);
        if RentalShptLine.FindSet() then
            repeat
                NewContractID := RentalShptLine."Contract No.";
                if (OldContractID = '') OR (NewContractID < OldContractID) then
                    OldContractID := NewContractID;
            until RentalShptLine.Next() = 0;
        exit(OldContractID);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"EQM Rental Ship-Post Coll.", OnAfterPostedCollectHeaderInsert, '', false, false)]
    local procedure OnAfterPostedCollectHeaderInsert(var RentalPostedCollectHeader: Record "EQM Rental Posted Coll. Header"; RentalDispHeader: Record "EQM Rental Dispatch Header")
    begin
        RentalPostedCollectHeader."I2I External Document No." := RentalDispHeader."I2I External Document No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"EQM Rental Ship-Post Coll.", 'OnAfterInsertPostedCollectionLine', '', false, false)]
    local procedure OnAfterInsertPostedCollectionLine(RentalShptHeader: Record "EQM Rental Dispatch Header"; RentalShptLine: Record "EQM Rental Dispatch Line"; PostCollectHeader: Record "EQM Rental Posted Coll. Header"; PostCollectLine: Record "EQM Rental Posted Coll. Line")
    begin
        if PostCollectLine."I2I External Document No." <> RentalShptLine."I2I External Document No." then begin
            PostCollectLine."I2I External Document No." := RentalShptLine."I2I External Document No.";
            PostCollectLine.Modify();
        end;
    end;

    // local procedure ExecuteShipAll(ContractNo: Code[20])
    // var
    //     RentalHeader: Record "EQM Rental Header";
    // begin
    //     RentalHeader.SetRange("Contract Type", RentalHeader."Contract Type"::Contract);
    //     RentalHeader.SetRange("Contract No.", ContractNo);
    //     if RentalHeader.FindFirst() then
    //         RentalHeader.DeliverRentalLineFromRentalHeader(0);
    // end;
    local procedure ExecuteShipAll(ContractNo: Code[20])
    var
        RentalHeader: Record "EQM Rental Header";
        RentalLine: Record "EQM Rental Line";
        RentalDeliveryMgt: Codeunit "EQM Rental Delivery Mgt.";
    begin
        RentalHeader.Get(RentalHeader."Contract Type"::Contract, ContractNo);
        RentalHeader.TestField(Status, RentalHeader.Status::Signed);

        RentalLine.SetRange("Contract Type", RentalHeader."Contract Type");
        RentalLine.SetRange("Contract No.", RentalHeader."Contract No.");
        RentalLine.SetRange("Rental Closed", false);
        RentalLine.SetRange("Transferd To Order", false);
        RentalLine.SetFilter("Qty. to Ship", '>0');

        if RentalLine.IsEmpty() then
            exit;

        RentalDeliveryMgt.SetHideValidationDialog_On(true);
        RentalDeliveryMgt.DeliverRentalLine_On(RentalLine, true, 0);
    end;
}
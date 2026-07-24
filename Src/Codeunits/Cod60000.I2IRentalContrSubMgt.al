codeunit 60000 "I2I Rental Contr. Sub Mgt."
{
    /*[EventSubscriber(ObjectType::Codeunit, Codeunit::"EQM Sign Rental Document", OnBeforePerformManualSignProcedure, '', false, false)]
    local procedure OnBeforePerformManualSignProcedure(var RentalHeader: Record "EQM Rental Header"; var IsHandled: Boolean)
    var
        GLSetup: Record "General Ledger Setup";
        RentalLine: Record "EQM Rental Line";
        LineNo: Integer;
        RentalQty: Decimal;
        GLAccount: Record "G/L Account";
    begin
        RentalQty := 0;
        LineNo := 0;

        if not GLSetup.Get() then
            Error('General Ledger Setup must be configured.');

        GLSetup.TestField("I2I Rental Revenue G/L Account");

        if RentalHeader."I2I Transport Charges" then begin
            GLSetup.TestField("I2I Transp. Rev. G/L Acc");

            RentalLine.SetRange("Contract Type", RentalHeader."Contract Type");
            RentalLine.SetRange("Contract No.", RentalHeader."Contract No.");
            RentalLine.SetRange(Type, RentalLine.Type::"G/L Account");
            RentalLine.SetRange("No.", GLSetup."I2I Transp. Rev. G/L Acc");
            if RentalLine.FindFirst() then begin
                if RentalLine."Unit Price" <= 0 then
                    Error('Transport line must have a Unit Price greater than 0.');
            end;
        end;

        RentalLine.Reset();
        RentalLine.SetRange("Contract Type", RentalHeader."Contract Type");
        RentalLine.SetRange("Contract No.", RentalHeader."Contract No.");
        RentalLine.SetRange(Type, RentalLine.Type::Item);
        if RentalLine.FindSet() then
            repeat
                if RentalLine."I2I External Document No." = '' then
                    Error('External Document No. must be filled in Rental Line %1 before signing.', RentalLine."Line No.");
            until RentalLine.Next() = 0;

        RentalLine.Reset();
        RentalLine.SetRange("Contract Type", RentalHeader."Contract Type");
        RentalLine.SetRange("Contract No.", RentalHeader."Contract No.");
        RentalLine.SetRange(Type, RentalLine.Type::"G/L Account");
        RentalLine.SetRange("No.", GLSetup."I2I Rental Revenue G/L Account");
        if RentalLine.FindFirst() then
            exit;

        RentalLine.Reset();
        RentalLine.SetRange("Contract Type", RentalHeader."Contract Type");
        RentalLine.SetRange("Contract No.", RentalHeader."Contract No.");
        if RentalLine.FindLast() then
            LineNo := RentalLine."Line No." + 10000
        else
            LineNo := 10000;

        RentalLine.Reset();
        RentalLine.SetRange("Contract Type", RentalHeader."Contract Type");
        RentalLine.SetRange("Contract No.", RentalHeader."Contract No.");
        RentalLine.SetRange(Type, RentalLine.Type::Item);
        if RentalLine.FindSet() then
            repeat
                RentalQty += RentalLine.Quantity;
            Until RentalLine.Next() = 0;

        Clear(RentalLine);
        RentalLine.Init();
        RentalLine."Contract Type" := RentalHeader."Contract Type";
        RentalLine."Contract No." := RentalHeader."Contract No.";
        RentalLine."Line No." := LineNo;
        RentalLine.Type := RentalLine.Type::"G/L Account";
        RentalLine."No." := GLSetup."I2I Rental Revenue G/L Account";
        RentalLine."Rental Sale" := true;
        if GLAccount.Get(GLSetup."I2I Rental Revenue G/L Account") then
            RentalLine.Description := GLAccount.Name;
        RentalLine.Validate(Quantity, 1);
        if RentalQty <= GLSetup."I2I Rental Quantity Threshold" then
            RentalLine.Validate("Unit Price", GLSetup."I2I Rental Price Bel. Thres.")
        else
            RentalLine.Validate("Unit Price", GLSetup."I2I Rental Price Abv. Thres.");
        RentalLine."Line Amount (Period)" := RentalLine."Unit Price" * RentalLine.Quantity;
        RentalLine.Insert(true);
    end;*/

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"EQM Rental Header Mgt.", OnBeforeDeliverRentalLineFromRentalHeader, '', false, false)]
    local procedure OnBeforeDeliverRentalLineFromRentalHeader(var RentalHeader: Record "EQM Rental Header"; ShipDocType: Option; var IsHandled: Boolean)
    var
        GLSetup: Record "General Ledger Setup";
        RentalLineL: Record "EQM Rental Line";
        LineNo: Integer;
        RentalQty: Decimal;
        GLAccount: Record "G/L Account";
    begin
        RentalQty := 0;
        LineNo := 0;

        RentalHeader.TestField("External Document No.");
        RentalHeader.TestField("Location Code");

        if not GLSetup.Get() then
            Error('General Ledger Setup must be configured.');

        GLSetup.TestField("I2I Rental Revenue G/L Account");

        if RentalHeader."I2I Transport Charges" then begin
            GLSetup.TestField("I2I Transp. Rev. G/L Acc");

            RentalLineL.SetRange("Contract Type", RentalHeader."Contract Type");
            RentalLineL.SetRange("Contract No.", RentalHeader."Contract No.");
            RentalLineL.SetRange(Type, RentalLineL.Type::"G/L Account");
            RentalLineL.SetRange("No.", GLSetup."I2I Transp. Rev. G/L Acc");
            if RentalLineL.FindFirst() then begin
                if RentalLineL."Unit Price" <= 0 then
                    Error('Transport line must have a Unit Price greater than 0.');
            end;
        end;

        RentalLineL.Reset();
        RentalLineL.SetRange("Contract Type", RentalHeader."Contract Type");
        RentalLineL.SetRange("Contract No.", RentalHeader."Contract No.");
        RentalLineL.SetRange(Type, RentalLineL.Type::Item);
        if RentalLineL.FindSet() then
            repeat
                if RentalLineL."I2I External Document No." = '' then
                    Error('External Document No. must be filled in Rental Line %1 before signing.', RentalLineL."Line No.");
            until RentalLineL.Next() = 0;

        // RentalLineL.Reset();
        // RentalLineL.SetRange("Contract Type", RentalHeader."Contract Type");
        // RentalLineL.SetRange("Contract No.", RentalHeader."Contract No.");
        // RentalLineL.SetRange(Type, RentalLineL.Type::"G/L Account");
        // RentalLineL.SetRange("No.", GLSetup."I2I Rental Revenue G/L Account");
        // if RentalLineL.FindFirst() then
        //     exit;

        RentalLineL.Reset();
        RentalLineL.SetRange("Contract Type", RentalHeader."Contract Type");
        RentalLineL.SetRange("Contract No.", RentalHeader."Contract No.");
        if RentalLineL.FindLast() then
            LineNo := RentalLineL."Line No." + 10000
        else
            LineNo := 10000;

        RentalLineL.Reset();
        RentalLineL.SetRange("Contract Type", RentalHeader."Contract Type");
        RentalLineL.SetRange("Contract No.", RentalHeader."Contract No.");
        RentalLineL.SetRange(Type, RentalLineL.Type::"G/L Account");
        RentalLineL.SetRange("No.", GLSetup."I2I Rental Revenue G/L Account");

        if RentalLineL.FindFirst() then begin
            // Update existing line
            RentalLineL.Validate(Quantity, 1);
            if RentalQty <= GLSetup."I2I Rental Quantity Threshold" then
                RentalLineL.Validate("Unit Price", GLSetup."I2I Rental Price Bel. Thres.")
            else
                RentalLineL.Validate("Unit Price", GLSetup."I2I Rental Price Abv. Thres.");
            RentalLineL."Line Amount (Period)" := RentalLineL."Unit Price" * RentalLineL.Quantity;
            RentalLineL.Modify();
        end else begin
            // Insert new line
            RentalLineL.Reset();
            RentalLineL.SetRange("Contract Type", RentalHeader."Contract Type");
            RentalLineL.SetRange("Contract No.", RentalHeader."Contract No.");
            if RentalLineL.FindLast() then
                LineNo := RentalLineL."Line No." + 10000
            else
                LineNo := 10000;

            Clear(RentalLineL);
            RentalLineL.Init();
            RentalLineL."Contract Type" := RentalHeader."Contract Type";
            RentalLineL."Contract No." := RentalHeader."Contract No.";
            RentalLineL."Line No." := LineNo;
            RentalLineL.Type := RentalLineL.Type::"G/L Account";
            RentalLineL.Validate("No.", GLSetup."I2I Rental Revenue G/L Account");
            RentalLineL."Rental Sale" := true;

            if GLAccount.Get(GLSetup."I2I Rental Revenue G/L Account") then
                RentalLineL.Description := GLAccount.Name;

            RentalLineL.Validate(Quantity, 1);

            if RentalQty <= GLSetup."I2I Rental Quantity Threshold" then
                RentalLineL.Validate("Unit Price", GLSetup."I2I Rental Price Bel. Thres.")
            else
                RentalLineL.Validate("Unit Price", GLSetup."I2I Rental Price Abv. Thres.");

            RentalLineL."Line Amount (Period)" := RentalLineL."Unit Price" * RentalLineL.Quantity;
            RentalLineL."Gen. Prod. Posting Group" := GLAccount."Gen. Prod. Posting Group";
            RentalLineL."Shipment Date" := WorkDate();
            RentalLineL."I2I External Document No." := RentalHeader."External Document No.";
            RentalLineL."Customer Project" := RentalHeader."Customer Project";
            RentalLineL.Insert(true);
            Commit();
        end;
    end;


    [EventSubscriber(ObjectType::Table, Database::"EQM Rental Header", OnBeforeMessageIfContractLinesExist, '', false, false)]
    local procedure SkipMessageForLocationCode(var RentalHeader: Record "EQM Rental Header"; ChangedFieldName: Text; var IsHandled: Boolean)
    begin
        if ChangedFieldName = RentalHeader.FieldCaption("Location Code") then
            IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Posted Sales Invoices", OnAfterActionEvent, 'Print', false, false)]
    local procedure OnAfterPrintActionEvent(var Rec: Record "Sales Invoice Header")
    begin
        Codeunit.Run(Codeunit::"Sales Inv.-Printed", Rec);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Posted Sales Invoices", OnAfterActionEvent, 'Email', false, false)]
    local procedure OnAfterEmailActionEvent(var Rec: Record "Sales Invoice Header")
    begin
        Codeunit.Run(Codeunit::"Sales Inv.-Printed", Rec);
    end;

    [EventSubscriber(ObjectType::Page, Page::"EQM Posted Rental Invoices", OnAfterActionEvent, 'Print', false, false)]
    local procedure OnAfterPrintActionEventRental(var Rec: Record "Sales Invoice Header")
    begin
        Codeunit.Run(Codeunit::"Sales Inv.-Printed", Rec);
    end;

    [EventSubscriber(ObjectType::Page, Page::"EQM Posted Rental Invoices", OnAfterActionEvent, 'Email', false, false)]
    local procedure OnAfterEmailActionEventRental(var Rec: Record "Sales Invoice Header")
    begin
        Codeunit.Run(Codeunit::"Sales Inv.-Printed", Rec);
    end;
}
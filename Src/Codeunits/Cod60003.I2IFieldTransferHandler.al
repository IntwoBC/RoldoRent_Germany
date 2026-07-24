codeunit 60003 "I2I Field Transfer Handler"
{
    [EventSubscriber(ObjectType::Table, Database::"Sales Invoice Line", OnAfterInitFromSalesLine, '', false, false)]
    local procedure CopyToSalesInvLine(var SalesInvLine: Record "Sales Invoice Line"; SalesInvHeader: Record "Sales Invoice Header"; SalesLine: Record "Sales Line")
    begin
        SalesInvLine."I2I External Document No." := SalesLine."I2I External Document No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"EQM Rental Line Entry Mgt.", OnAfterMoveRentalLine2RentalEntry, '', false, false)]
    local procedure OnAfterMoveRentalLine2RentalEntry(RentalLine: Record "EQM Rental Line"; var EntryLine: Record "EQM Rental Entry Basis")
    begin
        EntryLine."I2I External Document No." := RentalLine."I2I External Document No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"EQM RentalManagement", OnAfterInitSalesLineFromEntryLineAttachLineNo, '', false, false)]
    local procedure OnAfterInitSalesLineFromEntryLineAttachLineNo(var SalesLine: Record "Sales Line"; EntryLine: Record "EQM Rental Entry Basis"; AttachedToLineNo: Integer; Simulate: Boolean)
    begin
        SalesLine."I2I External Document No." := EntryLine."I2I External Document No.";
    end;

    [EventSubscriber(ObjectType::Table, Database::"VAT Amount Line", 'OnAfterVATAmountText', '', false, false)]
    local procedure OnAfterVATAmountTextHandler(VATPercentage: Decimal; FullCount: Integer; var Result: Text[30])
    begin
        if VATPercentage = 0 then
            Result := 'btw-bedrag'
        else
            Result := StrSubstNo('%1% btw', VATPercentage);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post", OnBeforeCode, '', false, false)]
    local procedure OnBeforeCode(var ItemJournalLine: Record "Item Journal Line"; var HideDialog: Boolean; var SuppressCommit: Boolean; var IsHandled: Boolean)
    begin
        ItemJournalLine.TestField("Reason Code");
    end;

    // [EventSubscriber(ObjectType::Table, Database::"EQM Rental Return Entry", OnAfterInsertEvent, '', false, false)]
    // local procedure OnAfterInsertRentalReturnEntry(var Rec: Record "EQM Rental Return Entry"; RunTrigger: Boolean)
    // var
    //     RentalLine: Record "EQM Rental Line";
    //     RentalDispLine: Record "EQM Rental Dispatch Line";
    // begin
    //     if Rec."Contract No." = '' then
    //         exit;

    //     if RentalLine.Get(RentalLine."Contract Type"::Contract, Rec."Contract No.", Rec."Ext. Rental Line No.") then begin
    //         if Rec."I2I External Document No." <> RentalLine."I2I External Document No." then begin
    //             Rec."I2I External Document No." := RentalLine."I2I External Document No.";
    //             Rec.Modify();
    //         end;
    //     end;
    // end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"EQM Return Post Entry", 'OnBeforeReturnEntryInsert', '', false, false)]
    local procedure OnBeforeReturnEntryInsert(var RentalReturnEntry: Record "EQM Rental Return Entry"; ReturnJnlLine: Record "EQM Rental Return Journal Line")
    var
        RentalLine: Record "EQM Rental Line";
        RentalDispatchLine: Record "EQM Rental Dispatch Line";
        PostRentalDispatchLine: Record "EQM Rental Posted Coll. Line";
    begin
        if RentalReturnEntry."Contract No." = '' then
            exit;

        case RentalReturnEntry."Entry Type" of
            RentalReturnEntry."Entry Type"::Shipment, RentalReturnEntry."Entry Type"::"On-Rent":
                begin
                    if RentalLine.Get(RentalLine."Contract Type"::Contract, RentalReturnEntry."Contract No.", RentalReturnEntry."Ext. Rental Line No.") then
                        RentalReturnEntry."I2I External Document No." := RentalLine."I2I External Document No.";
                end;
            RentalReturnEntry."Entry Type"::Return, RentalReturnEntry."Entry Type"::"Off-Rent":
                begin
                    if PostRentalDispatchLine.Get(RentalReturnEntry."Pst. Dispatch Doc. No.", RentalReturnEntry."Pst. Dispatch Line No.") then
                        RentalReturnEntry."I2I External Document No." := PostRentalDispatchLine."I2I External Document No.";
                end;
        end;
    end;
}
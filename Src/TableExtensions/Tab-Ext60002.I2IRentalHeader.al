tableextension 60002 "I2I Rental Header" extends "EQM Rental Header"
{
    fields
    {
        modify("External Document No.")
        {
            trigger OnAfterValidate()
            var
                CheckHeader: Record "EQM Rental Header";
                CheckLine: Record "EQM Rental Line";
            begin
                if Rec."External Document No." = '' then
                    exit;

                // Check other header records for duplicate External Document No.
                Clear(CheckHeader);
                CheckHeader.SetRange("External Document No.", Rec."External Document No.");
                CheckHeader.SetFilter("Contract No.", '<>%1', Rec."Contract No.");
                if CheckHeader.FindFirst() then
                    Error('External Document No. %1 is already used in Contract %2.', Rec."External Document No.", CheckHeader."Contract No.");

                // Check lines for duplicate I2I External Document No.
                Clear(CheckLine);
                CheckLine.SetRange("I2I External Document No.", Rec."External Document No.");
                CheckLine.SetFilter("Contract No.", '<>%1', Rec."Contract No.");
                if CheckLine.FindFirst() then
                    Error('External Document No. %1 is already used in Contract %2.', Rec."External Document No.", CheckLine."Contract No.");
            end;
        }
        field(60000; "I2I Transport Charges"; Boolean)
        {
            Caption = 'Transport Charges';
            InitValue = false;
            trigger OnValidate()
            var
                GLSetup: Record "General Ledger Setup";
                RentalLine: Record "EQM Rental Line";
                GLAccount: Record "G/L Account";
                LineNo: Integer;
            begin
                LineNo := 0;

                GLSetup.Get();
                GLSetup.TestField("I2I Transp. Rev. G/L Acc");

                if not Rec."I2I Transport Charges" then
                    exit;

                // RentalLine.Reset();
                // RentalLine.SetRange("Contract Type", Rec."Contract Type");
                // RentalLine.SetRange("Contract No.", Rec."Contract No.");
                // RentalLine.SetRange(Type, RentalLine.Type::"G/L Account");
                // RentalLine.SetRange("No.", GLSetup."I2I Transp. Rev. G/L Acc");
                // if not RentalLine.IsEmpty() then
                //     exit;

                Clear(RentalLine);
                RentalLine.SetRange("Contract Type", Rec."Contract Type");
                RentalLine.SetRange("Contract No.", Rec."Contract No.");
                if RentalLine.FindLast() then
                    LineNo := RentalLine."Line No." + 10000
                else
                    LineNo := 10000;

                RentalLine.Init();
                RentalLine."Contract Type" := Rec."Contract Type";
                RentalLine."Contract No." := Rec."Contract No.";
                RentalLine."Line No." := LineNo;
                RentalLine.Type := RentalLine.Type::"G/L Account";
                RentalLine."No." := GLSetup."I2I Transp. Rev. G/L Acc";
                RentalLine."Rental Sale" := true;
                if GLAccount.Get(GLSetup."I2I Transp. Rev. G/L Acc") then
                    RentalLine.Description := GLAccount.Name;
                RentalLine.Validate(Quantity, 1);
                RentalLine."Gen. Prod. Posting Group" := GLAccount."Gen. Prod. Posting Group";
                RentalLine."Shipment Date" := WorkDate();
                RentalLine."Location Code" := "Location Code";
                RentalLine."I2I External Document No." := Rec."External Document No.";
                RentalLine."Customer Project" := Rec."Customer Project";
                RentalLine.Insert(true);
            end;
        }
        field(60001; "I2I Delivery Date"; Date)
        {
            Caption = 'Delivery Date';
            DataClassification = ToBeClassified;
        }
        modify("Shipment Date")
        {
            trigger OnAfterValidate()
            begin
                if Rec."Shipment Date" <> 0D then begin
                    Rec."I2I Delivery Date" := Rec."Shipment Date";
                end;
            end;
        }
        modify("Location Code")
        {
            trigger OnAfterValidate()
            var
                RentalLine: Record "EQM Rental Line";
                Confirmed: Boolean;
            begin
                // Ignore blank
                if Rec."Location Code" = '' then
                    exit;

                // Filter lines for current document
                RentalLine.Reset();
                RentalLine.SetRange("Contract Type", Rec."Contract Type");
                RentalLine.SetRange("Contract No.", Rec."Contract No.");
                if not RentalLine.FindFirst() then
                    exit;

                // Ask confirmation ONLY if lines exist
                Confirmed := Confirm('Do you want to update Location Code in all lines?', false);

                if not Confirmed then
                    exit;

                // Update all lines
                if RentalLine.FindSet() then begin
                    repeat
                        RentalLine.Validate("Location Code", Rec."Location Code");
                        RentalLine.Modify();
                    until RentalLine.Next() = 0;
                end;
            end;
        }
    }

    trigger OnInsert()
    begin
        if Rec."Shipment Date" <> 0D then
            Rec."I2I Delivery Date" := Rec."Shipment Date";
    end;
}

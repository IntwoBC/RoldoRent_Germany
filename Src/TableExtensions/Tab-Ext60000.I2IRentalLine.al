tableextension 60000 "I2I Rental Line" extends "EQM Rental Line"
{
    fields
    {
        field(60000; "I2I External Document No."; Code[35])
        {
            Caption = 'External Document No.';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                CheckLine: Record "EQM Rental Line";
            begin
                if Rec."I2I External Document No." = '' then
                    exit;

                CheckLine.Reset();
                CheckLine.SetCurrentKey("I2I External Document No.");
                CheckLine.SetRange("I2I External Document No.", Rec."I2I External Document No.");
                CheckLine.SetFilter("Contract No.", '<>%1', Rec."Contract No.");
                if CheckLine.FindFirst() then
                    Error('External Document No. %1 is already used in Contract %2.', CheckLine."I2I External Document No.", CheckLine."Contract No.");
            end;
        }
    }
    trigger OnAfterInsert()
    var
        RentalContract: Record "EQM Rental Header";
    begin
        RentalContract.SetRange("Contract Type", Rec."Contract Type");
        RentalContract.SetRange("Contact No.", Rec."Contract No.");
        if RentalContract.FindFirst() then begin
            "Shipment Date" := RentalContract."Shipment Date";
            "On-Rent Date" := RentalContract."Shipment Date";
        end;
    end;
}

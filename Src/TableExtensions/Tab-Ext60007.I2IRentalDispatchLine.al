tableextension 60007 "I2I Rental Dispatch Line" extends "EQM Rental Dispatch Line"
{
    fields
    {
        field(60000; "I2I External Document No."; Code[35])
        {
            Caption = 'External Document No.';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                RentalHeader: Record "EQM Rental Dispatch Header";
                PostedHeader: Record "EQM Rental Posted Coll. Header";
                Line: Record "EQM Rental Dispatch Line";
            begin
                if Rec."I2I External Document No." = '' then
                    exit;

                // 🔍 Check in Open Headers
                RentalHeader.Reset();
                RentalHeader.SetRange("I2I External Document No.", Rec."I2I External Document No.");
                RentalHeader.SetFilter("Document Type", '<>%1', Rec."Document Type");
                RentalHeader.SetFilter("No.", '<>%1', Rec."Document No.");
                if RentalHeader.FindFirst() then
                    Error(
                        'External Document No. %1 is already used in another Document %2.',
                        RentalHeader."I2I External Document No.",
                        RentalHeader."No.");

                // 🔍 Check in Posted Headers
                PostedHeader.Reset();
                PostedHeader.SetRange("I2I External Document No.", Rec."I2I External Document No.");
                if PostedHeader.FindFirst() then
                    Error(
                        'External Document No. %1 is already used in Posted Document %2.',
                        PostedHeader."I2I External Document No.",
                        PostedHeader."No.");

                // 🔄 Sync to Other Lines
                Line.Reset();
                Line.SetRange("Document Type", Rec."Document Type");
                Line.SetRange("Document No.", Rec."Document No.");
                if Line.FindSet() then
                    repeat
                        if Line."Line No." <> Rec."Line No." then
                            if Line."I2I External Document No." <> Rec."I2I External Document No." then begin
                                Line."I2I External Document No." := Rec."I2I External Document No.";
                                Line.Modify();
                            end;
                    until Line.Next() = 0;
            end;
        }
    }
}

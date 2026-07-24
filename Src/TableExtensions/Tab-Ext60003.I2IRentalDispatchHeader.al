tableextension 60003 "I2I Rental Dispatch Header" extends "EQM Rental Dispatch Header"
{
    fields
    {
        field(60005; "I2I Transportation Charges"; Boolean)
        {
            InitValue = false;
            Caption = 'Transportation Charges';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                if not Rec."I2I Transportation Charges" then
                    Rec."I2I Transportation Cost" := 0;
            end;
        }
        field(60001; "I2I Transportation Cost"; Decimal)
        {
            Caption = 'Transportation Cost';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                if Rec."I2I Transportation Charges" then
                    if Rec."I2I Transportation Cost" <= 0 then
                        Error('Transportation Cost must be greater than 0');
            end;
        }
        field(60002; "I2I Handling Fee"; Boolean)
        {
            Caption = 'Handling Fee(Applicable).';
            DataClassification = ToBeClassified;
            InitValue = false;
        }
        field(60003; "I2I Contact No."; Text[100])
        {
            Caption = 'Contact No.';
            OptimizeForTextSearch = true;
            //TableRelation = Contact."No." where("Company No." = field("Customer No."));
            trigger OnValidate()
            var
                Contact: Record Contact;
            begin
                Clear("I2I Contact E-Mail");
                if Contact.Get("I2I Contact No.") then begin
                    "I2I Contact Name" := Contact.Name;
                    "I2I Contact E-Mail" := Contact."E-Mail";
                end;
            end;

            trigger OnLookup()
            begin
                LookupContactList();
            end;
        }
        field(60004; "I2I Contact E-Mail"; Text[100])
        {
            Caption = 'Contact E-Mail';
        }
        field(60000; "I2I External Document No."; Code[35])
        {
            Caption = 'External Document No.';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                RentalHeader: Record "EQM Rental Dispatch Header";
                PostedHeader: Record "EQM Rental Posted Coll. Header";
                Line: Record "EQM Rental Dispatch Line";
                ConfirmUpdate: Boolean;
            begin
                if Rec."I2I External Document No." = '' then
                    exit;

                // 🔍 Check in Open Headers
                RentalHeader.Reset();
                RentalHeader.SetRange("I2I External Document No.", Rec."I2I External Document No.");
                RentalHeader.SetFilter("Document Type", '<>%1', Rec."Document Type");
                RentalHeader.SetFilter("No.", '<>%1', Rec."No.");
                if RentalHeader.FindFirst() then
                    Error(
                        'External Document No. %1 is already used in Document %2.',
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

                // // 🔍 Check if lines exist that will be updated
                // Line.Reset();
                // Line.SetRange("Document Type", Rec."Document Type");
                // Line.SetRange("Document No.", Rec."No.");
                // if Line.FindFirst() then begin
                //     ConfirmUpdate := Confirm(
                //         'Do you want to update External Document No. in all lines?',
                //         true);

                //     if not ConfirmUpdate then
                //         exit;
                // end;

                // // 🔄 Sync to Lines
                // if Line.FindSet() then
                //     repeat
                //         if Line."I2I External Document No." <> Rec."I2I External Document No." then begin
                //             Line.Validate("I2I External Document No.", Rec."I2I External Document No.");
                //             Line.Modify();
                //         end;
                //     until Line.Next() = 0;
            end;
        }
        field(60006; "I2I Collection Date"; Date)
        {
            Caption = 'Collection Date';
            DataClassification = ToBeClassified;
        }
        field(60007; "I2I Contact Name"; Text[100])
        {
            Caption = 'Contact Name';
            DataClassification = ToBeClassified;
        }
        modify("Return Date")
        {
            trigger OnAfterValidate()
            var
                Line: Record "EQM Rental Dispatch Line";
                LineCount: Integer;
                ConfirmUpdate: Boolean;
            begin
                // Exit if empty
                if Rec."Return Date" = 0D then
                    exit;

                // 🔹 Sync other header fields (if required)
                Rec."Off-Rent Date" := Rec."Return Date";
                Rec."I2I Collection Date" := Rec."Return Date";

                // 🔹 Get related lines
                Line.Reset();
                Line.SetRange("Document No.", Rec."No.");

                if not Line.FindSet() then
                    exit;

                // 🔹 Count lines
                LineCount := Line.Count;

                // 🔹 Ask confirmation
                ConfirmUpdate := Confirm('Return Date will update %1 lines. Do you want to continue?', true,
                    LineCount);

                if not ConfirmUpdate then
                    exit;

                // 🔹 Update all lines
                repeat
                    if Line."Return Date" <> Rec."Return Date" then begin
                        Line.Validate("Return Date", Rec."Return Date");
                        Line.Modify();
                    end;
                until Line.Next() = 0;
            end;
        }
    }
    procedure LookupContactList()
    var
        ContactBusinessRelation: Record "Contact Business Relation";
        ContactForLookup: Record Contact;
    begin
        // Apply filter based on Customer No.
        if ContactBusinessRelation.FindByRelation(
            ContactBusinessRelation."Link to Table"::Customer,
            Rec."Customer No.") then
            ContactForLookup.SetRange("Company No.", ContactBusinessRelation."Contact No.")
        else
            ContactForLookup.SetRange("Company No.", '');

        // (Optional) Show only Person contacts
        ContactForLookup.SetRange(Type, ContactForLookup.Type::Person);

        // Open lookup page
        if Page.RunModal(Page::"Contact List", ContactForLookup) = Action::LookupOK then begin
            Rec.Validate("I2I Contact No.", ContactForLookup."No.");
        end;
    end;

    trigger OnInsert()
    begin
        Rec."Return Date" := Rec."Off-Rent Date";
        Rec."I2I Collection Date" := Rec."Return Date";
    end;
}

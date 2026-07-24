namespace RoldoRent.RoldoRent;

using Microsoft.Finance.GeneralLedger.Ledger;
using Microsoft.Sales.Customer;
using Microsoft.FixedAssets.FixedAsset;
using Microsoft.Bank.BankAccount;
using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Purchases.Vendor;

pageextension 60026 "I2I General Ledger Ent." extends "General Ledger Entries"
{
    layout
    {
        addafter("Bal. Account No.")
        {
            field("Bal. Account Name"; I2IBalAccountName)
            {
                ApplicationArea = All;
                Caption = 'Bal. Account Name';
            }
        }
        addafter(Description)
        {
            field("I2ISource No."; Rec."Source No.")
            {
                ApplicationArea = All;
                Caption = 'Source No.';
            }
            field("Source Name"; I2ISourceName)
            {
                ApplicationArea = All;
                Caption = 'Source Name';
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        I2IBalAccountName := UpdateBalAccountName();
        I2ISourceName := UpdateSourceName();
    end;

    local procedure UpdateBalAccountName(): Text;
    var
        Customer: Record Customer;
        Vendor: Record Vendor;
        GLAccount: Record "G/L Account";
        BankAccount: Record "Bank Account";
        FixedAsset: Record "Fixed Asset";
    begin
        case Rec."Bal. Account Type" of
            Rec."Bal. Account Type"::Customer:
                if Customer.Get(Rec."Bal. Account No.") then
                    exit(Customer.Name);

            Rec."Bal. Account Type"::Vendor:
                if Vendor.Get(Rec."Bal. Account No.") then
                    exit(Vendor.Name);

            Rec."Bal. Account Type"::"G/L Account":
                if GLAccount.Get(Rec."Bal. Account No.") then
                    exit(GLAccount.Name);

            Rec."Bal. Account Type"::"Bank Account":
                if BankAccount.Get(Rec."Bal. Account No.") then
                    exit(BankAccount.Name);

            Rec."Bal. Account Type"::"Fixed Asset":
                if FixedAsset.Get(Rec."Bal. Account No.") then
                    exit(FixedAsset.Description);
        end;
    end;

    local procedure UpdateSourceName(): Text
    var
        Customer: Record Customer;
        Vendor: Record Vendor;
        BankAccount: Record "Bank Account";
        FixedAsset: Record "Fixed Asset";
    begin
        if Rec."Source No." = '' then
            exit('');

        if Customer.Get(Rec."Source No.") then
            exit(Customer.Name);

        if Vendor.Get(Rec."Source No.") then
            exit(Vendor.Name);

        if BankAccount.Get(Rec."Source No.") then
            exit(BankAccount.Name);

        if FixedAsset.Get(Rec."Source No.") then
            exit(FixedAsset.Description);

        exit('');
    end;

    var
        I2IBalAccountName: Text[100];
        I2ISourceName: Text[100];
}

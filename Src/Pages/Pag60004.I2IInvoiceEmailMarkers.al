page 60004 "I2I Invoice Email Markers"
{
    PageType = List;
    SourceTable = "Record Link";
    Caption = 'Invoice Email Markers';
    ApplicationArea = All;
    UsageCategory = Lists;
    Permissions = tabledata "Record Link" = R;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Link ID"; Rec."Link ID")
                {
                    ApplicationArea = All;
                }
                field("Record ID"; Rec."Record ID")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(URL1; Rec.URL1)
                {
                    ApplicationArea = All;
                }
                field(Created; Rec.Created)
                {
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                }
                field(Company; Rec.Company)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(BackfillFromSentEmails)
            {
                Caption = 'Backfill From Sent Emails';
                ApplicationArea = All;
                Image = UpdateDescription;
                ToolTip = 'Create missing invoice email markers for posted invoices that already have sent email history.';

                trigger OnAction()
                var
                    ManualEmailMarkerSub: Codeunit "I2I Manual Email Marker Sub";
                    CheckedCount: Integer;
                    AddedCount: Integer;
                begin
                    ManualEmailMarkerSub.BackfillMissingInvoiceMarkersFromSentEmails(CheckedCount, AddedCount);
                    CurrPage.Update(false);
                    Message(BackfillResultMsgLbl, AddedCount, CheckedCount);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetRange(Type, Rec.Type::Link);
        Rec.SetRange(URL1, EmailQueuedMarkerUrlLbl);
    end;

    var
        EmailQueuedMarkerUrlLbl: Label 'bc://i2i/posted-sales-invoice/queued';
        BackfillResultMsgLbl: Label 'Backfill completed. Added markers: %1. Invoices checked: %2.';
}

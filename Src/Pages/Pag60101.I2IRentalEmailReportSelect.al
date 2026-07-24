page 60101 "I2I Rental Email Report Select"
{
    Caption = 'Select Reports';
    PageType = List;
    ApplicationArea = All;
    SourceTable = "I2I Rental Email Report Buffer";
    SourceTableTemporary = true;
    Editable = true;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Selected; Rec.Selected)
                {
                    ApplicationArea = All;
                    ToolTip = 'Select this report to include it as a PDF attachment.';
                }
                field("Report Name"; Rec."Report Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the report that will be generated and attached.';
                    Editable = false;
                }
                field("Report ID"; Rec."Report ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the object ID of the selected report.';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(AddReport)
            {
                Caption = 'Add Report';
                ApplicationArea = All;
                Image = Add;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                begin
                    AddReportToBuffer();
                    CurrPage.Update(false);
                end;
            }
            action(RemoveReport)
            {
                Caption = 'Remove Report';
                ApplicationArea = All;
                Image = RemoveLine;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                begin
                    RemoveCurrentReport();
                    CurrPage.Update(false);
                end;
            }
            action(SelectAll)
            {
                Caption = 'Select All';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                begin
                    UpdateSelection(true);
                    CurrPage.Update(false);
                end;
            }
            action(ClearSelection)
            {
                Caption = 'Clear Selection';
                ApplicationArea = All;
                Image = ClearFilter;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                begin
                    UpdateSelection(false);
                    CurrPage.Update(false);
                end;
            }
            action(DownloadSelected)
            {
                Caption = 'Download Selected';
                ApplicationArea = All;
                Image = Download;
                Visible = IsDownloadMode;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                begin
                    DownloadReportFromBuffer();
                end;
            }
        }
    }

    procedure SetDocumentTypeContext(IsRentalCollectionOrder: Boolean)
    begin
        if IsRentalCollectionOrder then
            CurrentDocumentType := CurrentDocumentType::"Rental Collection Order"
        else
            CurrentDocumentType := CurrentDocumentType::"Rental Contract";
    end;

    procedure SetReportBuffer(var TempBuffer: Record "I2I Rental Email Report Buffer" temporary)
    begin
        DownloadRequested := false;
        Rec.Reset();
        Rec.DeleteAll();

        if TempBuffer.FindSet() then
            repeat
                Rec := TempBuffer;
                Rec.Insert();
            until TempBuffer.Next() = 0;
    end;

    procedure SetDownloadMode(DownloadMode: Boolean)
    begin
        IsDownloadMode := DownloadMode;
    end;

    procedure WasDownloadRequested(): Boolean
    begin
        exit(DownloadRequested);
    end;

    procedure GetReportBuffer(var TempBuffer: Record "I2I Rental Email Report Buffer" temporary)
    begin
        TempBuffer.Reset();
        TempBuffer.DeleteAll();

        Rec.Reset();
        if Rec.FindSet() then
            repeat
                TempBuffer := Rec;
                TempBuffer.Insert();
            until Rec.Next() = 0;
    end;

    local procedure UpdateSelection(IsSelected: Boolean)
    begin
        Rec.Reset();
        if Rec.FindSet() then
            repeat
                Rec.Selected := IsSelected;
                Rec.Modify();
            until Rec.Next() = 0;
    end;

    local procedure AddReportToBuffer()
    var
        RentalDocEmailMgt: Codeunit "I2I Rental Doc. Email Mgt";
        AvailableReports: Record "I2I Rental Email Report Buffer" temporary;
        OptionsTxt: Text;
        OptionNo: Integer;
        CurrentNo: Integer;
    begin
        RentalDocEmailMgt.GetAvailableReportsForDocumentType(CurrentDocumentType, AvailableReports);
        FilterOutAddedReports(AvailableReports);

        if AvailableReports.IsEmpty() then
            Error(NoAdditionalReportsErrLbl);

        OptionsTxt := BuildOptionsText(AvailableReports);
        OptionNo := StrMenu(OptionsTxt, 1, SelectReportPromptLbl);
        if OptionNo = 0 then
            exit;

        CurrentNo := 0;
        AvailableReports.FindSet();
        repeat
            CurrentNo += 1;
            if CurrentNo = OptionNo then begin
                InsertReport(AvailableReports."Report ID", AvailableReports."Report Name");
                exit;
            end;
        until AvailableReports.Next() = 0;
    end;

    local procedure RemoveCurrentReport()
    begin
        if Rec.IsEmpty() then
            exit;

        Rec.Delete();
    end;

    local procedure FilterOutAddedReports(var AvailableReports: Record "I2I Rental Email Report Buffer" temporary)
    begin
        Rec.Reset();
        if not Rec.FindSet() then
            exit;

        repeat
            AvailableReports.SetRange("Report ID", Rec."Report ID");
            if AvailableReports.FindFirst() then
                AvailableReports.Delete();
            AvailableReports.SetRange("Report ID");
        until Rec.Next() = 0;
    end;

    local procedure BuildOptionsText(var AvailableReports: Record "I2I Rental Email Report Buffer" temporary): Text
    var
        OptionsTxt: Text;
    begin
        AvailableReports.Reset();
        if AvailableReports.FindSet() then
            repeat
                if OptionsTxt = '' then
                    OptionsTxt := AvailableReports."Report Name"
                else
                    OptionsTxt += ',' + AvailableReports."Report Name";
            until AvailableReports.Next() = 0;

        exit(OptionsTxt);
    end;

    local procedure InsertReport(ReportId: Integer; ReportName: Text)
    begin
        Rec.Init();
        Rec."Entry No." := GetNextEntryNo();
        Rec."Document Type" := CurrentDocumentType;
        Rec."Report ID" := ReportId;
        Rec."Report Name" := CopyStr(ReportName, 1, MaxStrLen(Rec."Report Name"));
        Rec.Selected := true;
        Rec.Insert();
    end;

    local procedure GetNextEntryNo(): Integer
    begin
        Rec.Reset();
        if Rec.FindLast() then
            exit(Rec."Entry No." + 1);

        exit(1);
    end;

    local procedure DownloadReportFromBuffer()
    begin
        Rec.Reset();
        Rec.SetRange(Selected, true);

        if not Rec.FindSet() then
            Error('Please select at least one report.');

        DownloadRequested := true;
        CurrPage.Close();
    end;

    var
        CurrentDocumentType: Enum "I2I Rental Email Doc. Type";
        IsDownloadMode: Boolean;
        DownloadRequested: Boolean;
        SelectReportPromptLbl: Label 'Select a report to add';
        NoAdditionalReportsErrLbl: Label 'All available reports are already added.';
}

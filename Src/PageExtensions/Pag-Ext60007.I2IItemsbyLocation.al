pageextension 60007 "I2I Items by Location" extends "Items by Location"
{
    layout
    {
        addafter(MATRIX_CaptionRange)
        {
            // field(ShowInTransit1; ShowInTransit)
            // {
            //     ApplicationArea = All;
            //     trigger OnValidate()
            //     begin
            //         ShowInTransitOnAfterValidate();
            //     end;
            // }

            // field(ShowColumnName1; ShowColumnName)
            // {
            //     ApplicationArea = All;
            //     trigger OnValidate()
            //     begin
            //         ShowColumnNameOnAfterValidate();
            //     end;
            // }

            field(ShowReservation; ShowReservation)
            {
                ApplicationArea = All;
            }

            field(ShowIncomplete; ShowIncomplete)
            {
                ApplicationArea = All;
            }

            field(DateFilter; DateFilter)
            {
                ApplicationArea = All;
            }

            field(ShowBlocked; ShowBlocked)
            {
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    ShowBlockedOnAfterValidate();
                end;
            }
        }
    }

    actions
    {
        addlast(processing)
        {
            action(ShowMatrix)
            {
                ApplicationArea = All;
                Image = ShowMatrix;

                trigger OnAction()
                var
                    ItemsByLocationMatrix: Page "Items by Location Matrix";
                begin
                    ItemsByLocationMatrix.Load(MATRIX_CaptionSet, MatrixRecords, MatrixRecord, MATRIX_CurrSetLength);
                    ItemsByLocationMatrix.SetRecord(Rec);
                    ItemsByLocationMatrix.RunModal();
                end;
            }

            action(PreviousSet)
            {
                ApplicationArea = All;
                trigger OnAction()
                begin
                    SetColumns(MATRIX_SetWanted::Previous);
                end;
            }

            action(NextSet)
            {
                ApplicationArea = All;
                trigger OnAction()
                begin
                    SetColumns(MATRIX_SetWanted::Next);
                end;
            }
        }
    }

    var
        MatrixRecord: Record "Location";
        MatrixRecords: ARRAY[32] OF Record 14;
        MatrixRecordRef: RecordRef;
        MATRIX_SetWanted: Enum "I2I Matrix SetWanted";
        ShowColumnName: Boolean;
        ShowInTransit: Boolean;
        MATRIX_CaptionSet: ARRAY[32] OF Text[1024];
        MATRIX_CaptionRange: Text[100];
        MATRIX_PKFirstRecInCurrSet: Text[100];
        MATRIX_CurrSetLength: Integer;
        ShowReservation: Boolean;
        ShowIncomplete: Boolean;
        DateFilter: Date;
        ShowBlocked: Boolean;
        MatrixMgt: Codeunit "Matrix Management";
        CaptionFieldNo: Integer;
        CurrentMatrixRecordOrdinal: Integer;

    PROCEDURE SetColumns(SetWanted: Enum "I2I Matrix SetWanted");
    VAR
        MatrixMgt: Codeunit "Matrix Management";
        CaptionFieldNo: Integer;
        CurrentMatrixRecordOrdinal: Integer;
    BEGIN
        MatrixRecord.SETRANGE("Use As In-Transit", ShowInTransit);
        //MatrixRecord.SETRANGE(Blocked, ShowBlocked);
        CLEAR(MATRIX_CaptionSet);
        CLEAR(MatrixRecords);
        CurrentMatrixRecordOrdinal := 1;

        MatrixRecordRef.GETTABLE(MatrixRecord);
        MatrixRecordRef.SETTABLE(MatrixRecord);

        IF ShowColumnName THEN
            CaptionFieldNo := MatrixRecord.FIELDNO(Name)
        ELSE
            CaptionFieldNo := MatrixRecord.FIELDNO(Code);

        MatrixMgt.GenerateMatrixData(MatrixRecordRef, SetWanted, ARRAYLEN(MatrixRecords), CaptionFieldNo, MATRIX_PKFirstRecInCurrSet,
          MATRIX_CaptionSet, MATRIX_CaptionRange, MATRIX_CurrSetLength);

        IF MATRIX_CurrSetLength > 0 THEN BEGIN
            MatrixRecord.SETPOSITION(MATRIX_PKFirstRecInCurrSet);
            MatrixRecord.FIND;
            REPEAT
                MatrixRecords[CurrentMatrixRecordOrdinal].COPY(MatrixRecord);
                CurrentMatrixRecordOrdinal := CurrentMatrixRecordOrdinal + 1;
            UNTIL (CurrentMatrixRecordOrdinal > MATRIX_CurrSetLength) OR (MatrixRecord.NEXT <> 1);
        END;
    END;

    LOCAL PROCEDURE ShowColumnNameOnAfterValidate();
    BEGIN
        SetColumns(MATRIX_SetWanted::Same);
    END;

    LOCAL PROCEDURE ShowInTransitOnAfterValidate();
    BEGIN
        SetColumns(MATRIX_SetWanted::Initial);
    END;

    LOCAL PROCEDURE ShowBlockedOnAfterValidate();
    BEGIN
        SetColumns(MATRIX_SetWanted::Initial);
    END;

    trigger OnOpenPage()
    begin
        ShowIncomplete := true;
        ShowReservation := true;
        DateFilter := WorkDate();

        SetColumns(MATRIX_SetWanted::Initial);
    end;
}
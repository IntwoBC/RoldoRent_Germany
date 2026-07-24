pageextension 60010 "I2I Purchase Order" extends "Purchase Order"
{
    layout
    {
        addlast(Content)
        {
            group(MemoTextGrp)
            {
                Caption = 'Inbound Memo';

                field(InboundMemoTxt; InboundMemoTxtVar)
                {
                    ApplicationArea = All;
                    MultiLine = true;

                    trigger OnValidate()
                    var
                        OutStr: OutStream;
                    begin
                        Rec."I2I Inbound Memo Text".CreateOutStream(OutStr);
                        OutStr.WriteText(InboundMemoTxtVar);
                        Rec.Modify();
                    end;
                }
            }
        }
    }
    var
        InboundMemoTxtVar: Text;

    trigger OnAfterGetRecord()
    var
        InStr: InStream;
        TempText: Text;
    begin
        InboundMemoTxtVar := '';
        if Rec."I2I Inbound Memo Text".HasValue then begin
            Rec."I2I Inbound Memo Text".CreateInStream(InStr);

            while not InStr.EOS do begin
                InStr.ReadText(TempText);
                InboundMemoTxtVar += TempText;
            end;
        end;
    end;
}

codeunit 60006 "I2I Email Body Sig. Inserter"
{
    procedure BuildEmailBodyWithSignature(BodyText: Text; SignatureTemplate: Text): Text
    var
        SignatureText: Text;
    begin
        SignatureText := BuildEmailSignature(SignatureTemplate);
        exit(AppendEmailSignature(BodyText, SignatureText));
    end;

    local procedure BuildEmailSignature(SignatureTemplate: Text): Text
    var
        PlaceholderValues: array[8] of Text;
    begin
        if SignatureTemplate = '' then
            exit('');

        GetSignaturePlaceholderValues(PlaceholderValues);
        exit(StrSubstNo(SignatureTemplate,
            PlaceholderValues[1],
            PlaceholderValues[2],
            PlaceholderValues[3],
            PlaceholderValues[4],
            PlaceholderValues[5],
            PlaceholderValues[6],
            PlaceholderValues[7],
            PlaceholderValues[8]));
    end;

    local procedure AppendEmailSignature(BodyText: Text; SignatureText: Text): Text
    begin
        if SignatureText = '' then
            exit(BodyText);

        SignatureText := NormalizeSignatureForHtml(SignatureText);
        if BodyText = '' then
            exit(SignatureText);

        if EndsWithHtmlBreak(BodyText) then
            exit(BodyText + SignatureText);

        exit(BodyText + '<br/>' + SignatureText);
    end;

    local procedure EndsWithHtmlBreak(Value: Text): Boolean
    var
        ValueLower: Text;
    begin
        ValueLower := LowerCase(Value.TrimEnd());
        exit(
            EndsWith(ValueLower, '<br>') or
            EndsWith(ValueLower, '<br/>') or
            EndsWith(ValueLower, '<br />'));
    end;

    local procedure EndsWith(Value: Text; Suffix: Text): Boolean
    begin
        if StrLen(Value) < StrLen(Suffix) then
            exit(false);

        exit(CopyStr(Value, StrLen(Value) - StrLen(Suffix) + 1) = Suffix);
    end;

    local procedure GetSignaturePlaceholderValues(var PlaceholderValues: array[8] of Text)
    var
        CompanyInfo: Record "Company Information";
        [NonDebuggable]
        User: Record User;
    begin
        PlaceholderValues[1] := UserId();
        if User.Get(UserSecurityId()) and (User."Full Name" <> '') then
            PlaceholderValues[1] := User."Full Name";

        if not CompanyInfo.Get() then
            exit;

        PlaceholderValues[2] := CompanyInfo.Name;
        PlaceholderValues[3] := CompanyInfo."E-Mail";
        PlaceholderValues[4] := BuildCompanyAddress(CompanyInfo);
        PlaceholderValues[5] := CompanyInfo."Phone No.";
        PlaceholderValues[6] := CompanyInfo."Home Page";
        PlaceholderValues[7] := '';
        PlaceholderValues[8] := '';
    end;

    local procedure BuildCompanyAddress(CompanyInfo: Record "Company Information"): Text
    var
        FullAddress: Text;
        CityLine: Text;
    begin
        AppendWithSeparator(FullAddress, CompanyInfo.Address, ', ');
        AppendWithSeparator(FullAddress, CompanyInfo."Address 2", ', ');

        if (CompanyInfo."Post Code" <> '') and (CompanyInfo.City <> '') then
            CityLine := StrSubstNo('%1 %2', CompanyInfo."Post Code", CompanyInfo.City)
        else
            if CompanyInfo."Post Code" <> '' then
                CityLine := CompanyInfo."Post Code"
            else
                CityLine := CompanyInfo.City;

        AppendWithSeparator(FullAddress, CityLine, ', ');
        AppendWithSeparator(FullAddress, CompanyInfo."Country/Region Code", ', ');

        exit(FullAddress);
    end;

    local procedure AppendWithSeparator(var BaseText: Text; ValueToAppend: Text; Separator: Text)
    begin
        if ValueToAppend = '' then
            exit;

        if BaseText = '' then
            BaseText := ValueToAppend
        else
            BaseText += Separator + ValueToAppend;
    end;

    local procedure NormalizeSignatureForHtml(SignatureText: Text): Text
    begin
        if LooksLikeGenericHtml(SignatureText) then
            exit(SignatureText);

        exit(StrSubstNo('<pre style="margin:0;font-family:inherit;">%1</pre>', SignatureText));
    end;

    local procedure LooksLikeGenericHtml(Value: Text): Boolean
    begin
        exit((StrPos(Value, '<') > 0) and (StrPos(Value, '>') > 0));
    end;
}

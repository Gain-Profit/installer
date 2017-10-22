library SetupGP;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  System.SysUtils,
  System.Classes,
  System.JSON,
  System.Hash,
  Data.DB,
  MyAccess;

{$R *.res}

function GetValue(ACon: string; ASql: string): string;
var
  LConnection : TMyConnection;
  LQuery: TMyQUery;
  LResult: string;
  LRoot, LData: TJSONObject;
  LArray: TJSONArray;
  LCol, Lrow: Integer;
begin
  LConnection := TMyConnection.Create(nil);
  try
    LCOnnection.ConnectString := ACon;

    LQUery := TMyQuery.Create(LConnection);
    LQuery.Connection := LConnection;
    LQuery.SQL.Text := ASql;

    try
      LQuery.Open;
      LQuery.First;

      LRoot := TJSONObject.Create;
      LRoot.AddPair('status', '1');
      LArray := TJSONArray.Create;

      for LRow := 0 to Pred(LQuery.RecordCount) do
      begin
        LData := TJSONObject.Create;
        for LCol := 0 to Pred(LQuery.FieldCount) do
        begin
          LData.AddPair(LQuery.Fields[LCol].FieldName, LQuery.Fields[LCol].AsString);
        end;
        LArray.Add(LData);

        LQuery.Next;
      end;

      LRoot.AddPair('data', LArray);

      LResult := LRoot.ToString;
      LRoot.Free;
    except on E: Exception do
      LREsult:= '{"status": "0", "error": "' + E.Message +'"}';
    end;

  finally
    LConnection.Free;
  end;

  Result := LResult;
end;

function SetValue(ACon: string; ASql: string): string;
var
  LConnection : TMyConnection;
  LQuery: TMyQUery;
  LResult: string;
begin
  LConnection := TMyConnection.Create(nil);
  try
    LCOnnection.ConnectString := ACon;

    LQUery := TMyQuery.Create(LConnection);
    LQuery.Connection := LConnection;
    LQuery.SQL.Text := ASql;

    try
      LQuery.ExecSQL;
      LREsult:= '{"status": "1", "data": "success"}';

    except on E: Exception do
      LREsult:= '{"status": "0", "error": "' + E.Message +'"}';
    end;

  finally
    LConnection.Free;
  end;

  Result := LResult;
end;

function GetSerial(AKode: string; APerusahaan: string): string;
var
  LSerial : string;
  Str1, Str2, Str3, Str4, Str5: string;
begin
  LSerial := THashSHA1.GetHashString('GAIN' + AKode + APerusahaan + 'PROFIT');
  Str1 := Copy(LSerial, 34, 5);
  Str2 := Copy(LSerial, 8, 6);
  Str3 := Copy(LSerial, 25, 3);
  Str4 := Copy(LSerial, 12, 4);
  Str5 := Copy(LSerial, 2, 5);

  LSerial := Format('%s-%s-%s-%s-%s', [Str1, Str2, Str3, Str4, Str5]);
  Result := UpperCase(LSerial);
end;

function GetText(AInput: PAnsiChar; Buffer: PChar; BufLen: Integer): integer; stdcall;
var
  LResult: String;
  LJsonValue : TJSONValue;
  LJsonObject : TJSONObject;
  LParam: array of string;
  I: Integer;
begin
  LJsonValue := TJSONObject.ParseJSONValue(AInput);
  if LJsonValue is TJSONObject then
    LJsonObject := LJsonValue as TJSONObject else
    LJsonObject := nil;

  SetLength(LParam, LJsonObject.Count);
  for I := 0 to Pred(LJsonObject.Count) do
  begin
    LParam[I] := LJsonObject.GetValue('param' + IntToStr(I)).Value;
  end;

  if (LParam[0] = '1') then
  begin
    LResult := GetValue(LParam[1], LParam[2]);
  end else
  if (LParam[0] = '2') then
  begin
    LResult := SetValue(LParam[1], LParam[2]);
  end else
  if (LParam[0] = '3') then
  begin
    LResult := GetSerial(LParam[1], LParam[2]);
  end;

  Result:= Length(LResult);
  if (Buffer <> nil) and (Result > 0) then
    Move(LResult[1], Buffer^, Result * SizeOf(Char));
end;

exports GetText;

begin

end.

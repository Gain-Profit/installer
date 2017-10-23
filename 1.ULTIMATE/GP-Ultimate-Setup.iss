; Script generated by the Inno Script Studio Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "Gain Profit"
#define MyAppVersion "17.10.16.1"
#define MyAppPublisher "Ngalah Developer"
#define MyAppURL "http://www.ngadep.com/"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{7A91E7D5-0DD9-4BD9-85FF-F4A9DF56F40E}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={pf}\{#MyAppName}
DisableDirPage=yes
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
LicenseFile=bahan\other\license.txt
OutputBaseFilename=GP-Ultimate-setup
Compression=lzma
SolidCompression=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "autobackup"; Description: "Install Auto Backup"; Flags: unchecked

[Dirs]
Name: "{commonappdata}\Gain Profit"
Name: "{app}\laporan"
Name: "{app}\tools"
Name: "{app}\tools\skins"

[Files]
Source: "bahan\other\SetupGP.dll"; DestDir: "{app}"; Flags: dontcopy
Source: "bahan\accounting.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "bahan\gudang.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "bahan\pos_server.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "bahan\kasir.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "bahan\payroll.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "bahan\laporan\*"; DestDir: "{app}\laporan"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "bahan\tools\koneksi.exe"; DestDir: "{app}\tools"; Flags: ignoreversion
Source: "bahan\tools\CheckClock.exe"; DestDir: "{app}\tools"; Flags: ignoreversion
Source: "bahan\tools\dump.exe"; DestDir: "{app}\tools"; Flags: ignoreversion; Tasks: autobackup
Source: "bahan\tools\mysqldump.exe"; DestDir: "{app}\tools"; Flags: ignoreversion; Tasks: autobackup
Source: "bahan\tools\gzip.exe"; DestDir: "{app}\tools"; Flags: ignoreversion; Tasks: autobackup
Source: "bahan\tools\FRDesign.exe"; DestDir: "{app}\tools"; Flags: ignoreversion
Source: "bahan\tools\FRShow.exe"; DestDir: "{app}\tools"; Flags: ignoreversion
Source: "bahan\tools\Skins\*"; DestDir: "{app}\tools\skins"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\{#MyAppName}\Akuntansi"; Filename: "{app}\accounting.exe"
Name: "{group}\{#MyAppName}\Gudang"; Filename: "{app}\gudang.exe"
Name: "{group}\{#MyAppName}\Server Pos"; Filename: "{app}\pos_server.exe"
Name: "{group}\{#MyAppName}\Kasir"; Filename: "{app}\kasir.exe"
Name: "{group}\{#MyAppName}\Penggajian"; Filename: "{app}\payroll.exe"
Name: "{group}\{#MyAppName}\Tools\Koneksi"; Filename: "{app}\Tools\koneksi.exe"
Name: "{group}\{#MyAppName}\Tools\Check Clock"; Filename: "{app}\Tools\CheckClock.exe"
Name: "{group}\{#MyAppName}\Tools\BackUp"; Filename: "{app}\Tools\dump.exe"
Name: "{group}\{#MyAppName}\Tools\Desain Laporan"; Filename: "{app}\Tools\FRDesign.exe"
Name: "{group}\{#MyAppName}\Tools\Lihat Laporan"; Filename: "{app}\Tools\FRShow.exe"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\Akuntansi"; Filename: "{app}\accounting.exe"; Tasks: desktopicon
Name: "{commondesktop}\Gudang"; Filename: "{app}\gudang.exe"; Tasks: desktopicon
Name: "{commondesktop}\Server Pos"; Filename: "{app}\pos_server.exe"; Tasks: desktopicon
Name: "{commondesktop}\Kasir"; Filename: "{app}\kasir.exe"; Tasks: desktopicon
Name: "{commondesktop}\Penggajian"; Filename: "{app}\payroll.exe"; Tasks: desktopicon

[INI]
Filename: "{commonappdata}\Gain Profit\gain.ini"; Section: "akun"; Key: "kd_perusahaan"; String: "{code:GetUser|Kode}"
Filename: "{commonappdata}\Gain Profit\gain.ini"; Section: "gudang"; Key: "kd_perusahaan"; String: "{code:GetUser|Kode}"
Filename: "{commonappdata}\Gain Profit\gain.ini"; Section: "toko"; Key: "kd_perusahaan"; String: "{code:GetUser|Kode}"
Filename: "{commonappdata}\Gain Profit\gain.ini"; Section: "kasir"; Key: "kd_perusahaan"; String: "{code:GetUser|Kode}"

[Registry]
Root: "HKLM"; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Run"; ValueType: string; ValueName: "GPDump"; ValueData: """{app}\Tools\dump.exe"""; Flags: createvalueifdoesntexist uninsdeletevalue; Tasks: autobackup

[Run]
Filename: "{app}\tools\dump.exe"; WorkingDir: "{app}\tools"; Flags: nowait; Description: "Menjalankan Auto Backup"; Tasks: autobackup

[InstallDelete]
Type: files; Name: "{app}\tools\koneksi.cbCon";
Type: files; Name: "{app}\tools\koneksi_root.cbCon"; Tasks: autobackup

[Code]
#include "env.iss"

var
  ConnectionPage: TInputQueryWizardPage;
  UserPage: TInputQueryWizardPage;

function GetText(AInput: string; Buffer: string; BufLen: Integer): integer;
external 'GetText@files:SetupGP.dll stdcall setuponly';

procedure InitializeWizard;
begin
  ConnectionPage := CreateInputQueryPage(wpPassword,
    'Koneksi Database', 'Masukkan Nama/IP Server Database',
    'Isi dengan localhost jika Server Database berada dalam satu Komputer dengan Aplikasi. ' +
    'Selain itu, isikan alamat IP Server Database');
  ConnectionPage.Add('Nama/IP Server:', False);
  
  ConnectionPage.Values[0] := GetPreviousData('Server', 'localhost');
  
  UserPage := CreateInputQueryPage(wpUserInfo,
    'Info Perusahaan', 'Info Perusahaan',
    'Isikan Kode dan Nama Perusahaan Serta Kode Serial, Kemudian Klik Next');
  UserPage.Add('Kode Perusahaan:', False);
  UserPage.Add('Perusahaan:', False);
  UserPage.Add('Kode Serial:', False);

  UserPage.Values[2] := GetPreviousData('Serial', '');

  UserPage.Edits[0].Enabled := False;
  UserPage.Edits[1].Enabled := False;
end;

procedure RegisterPreviousData(PreviousDataKey: Integer);
begin
  SetPreviousData(PreviousDataKey, 'Server', ConnectionPage.Values[0]);
  SetPreviousData(PreviousDataKey, 'Serial', UserPage.Values[2]);
end;

function GetHost: String;
begin
  Result := ConnectionPage.Values[0];
end;

function GetUser(Param: String): String;
begin
  if Param = 'Kode' then
    Result := UserPage.Values[0]
  else if Param = 'Perusahaan' then
    Result := UserPage.Values[1]
  else if Param = 'Serial' then
    Result := UserPage.Values[2];
end;

function Kunci(const s: string; CryptInt: Integer): string;
var
  i: integer;
  s2: string;
begin
  if not (Length(s) = 0) then
    for i := 1 to Length(s) do
      s2 := s2 + Chr(Ord(s[i]) + CrypTint);
  Result := s2;
end;

procedure SimpanKoneksiRoot;
var
  LKoneksi: string;
begin
  LKoneksi := Kunci(GetHost, 6) + #13#10 + 'vxuloz' + #13#10 + '996<<' + #13#10 + 
  'xuuz' + #13#10 + 'MFoteVx6l''zeiktzkxejgzghgyk';

  SaveStringToFile(ExpandConstant('{app}\tools\koneksi_root.cbCon'), LKoneksi , False);
end;

procedure SimpanKoneksi;
var
  LKoneksi : string;
begin
  LKoneksi := Kunci(GetHost, 6) + #13#10 + 'vxuloz' + #13#10 + '996<<' + #13#10 + 
  '{ykxevxuloz' + #13#10 + '{ykxevxuloz';

  SaveStringToFile(ExpandConstant('{app}\tools\koneksi.cbCon'), LKoneksi, False);
  SaveStringToFile(ExpandConstant('{app}\tools\SERIAL.reg'), GetUser('Serial'), False);
end;

function OpenSQL(ASQL: string): string;
var
  LOut : string;
begin
  Log('SQL: ' + ASQL);

  SetLength(LOut, 255);
  SetLength(LOut, GetText('{"param0": "1", "param1": "'+ Format(MyCon, [GetHost])
        +'", "param2": "' + ASQL + '"}', LOut, 255));
 
  Log('LOut: "' + LOut + '"');
  Result := LOut;
end;

function IsConnected: string;
var
  LKode, LNama: string;
  LData, LStatus, LCOunt: string;
begin
  LData := OpenSQL(SQL1);
  
  LStatus := Copy(LData, 12, 1);
  Log('LStatus: "' + LStatus + '"');
  
  if (LStatus = '1') then
  begin
    LCount := Copy(LData, 24, 1); 
    Log('LCount: "' + LCount + '"');
  
    if (LCount = '1') then
    begin
      LKode := Copy(LData, 53, 5);
      Log('LKode: "' + LKode + '"');
    
      LNama := Copy(LData, 76, Length(LData) - 79);
      Log('LNama: "' + LNama + '"');

      UserPage.Values[0] := LKode;
      UserPage.Values[1] := LNama;
      Result := '0';
    end else
    begin
      Result := 'Tidak Ada Perusahaan Yang Terdaftar';
    end;
  end else
  begin
    Result := Copy(LData, 24, Length(LData) - 25);;
  end;  
end;

function IsValidSerial: Boolean;
var
  Serial : string;
begin
  SetLength(Serial, 255);
  SetLength(Serial, GetText('{"param0": "3", "param1": "'+ GetUser('Kode') 
        +'", "param2": "' + GetUser('Perusahaan') + '"}', Serial, 255));
 
  Log('Serial: "' + Serial + '"');
  Result := CompareStr(Serial, GetUser('Serial')) = 0;
end;

function NextButtonClick(CurPageID: Integer): Boolean;
var
  LHasil : string;
begin
  Result := True;
  
  if CurPageID = ConnectionPage.ID then
  begin
    LHasil := IsConnected
    Log('LHasil: "' + LHasil + '"');
    Result := LHasil = '0';
    if not Result then
      MsgBox('Tidak Dapat Terhubung ke Server' + #13#10 + LHasil, mbError, MB_OK);
  end else
  if CurPageID = UserPage.ID then
  begin
    Result := IsValidSerial;
    if not Result then
      MsgBox('Kode Serial Tidak Sesuai', mbError, MB_OK);
  end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if ( CurStep = ssPostInstall ) then
  begin
    SimpanKoneksi;
    if (IsTaskSelected('autobackup')) then
      SimpanKoneksiRoot;
  end;
end;

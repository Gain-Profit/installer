; Script generated by the Inno Script Studio Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "GP Database"
#define MyAppVersion "3.0.2"
#define MyAppPublisher "Ngalah Developer"
#define MyAppURL "http://www.ngadep.com/"
#define OutputFile "GPServer"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{C909EEEE-992E-447A-9709-943E63D9973A}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName=C:\GP_Database
DisableDirPage=yes
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
LicenseFile=bahan\license.txt
OutputBaseFilename={#OutputFile}-{#MyAppVersion}
Compression=lzma
SolidCompression=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Icons]
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"

[Dirs]
Name: "{app}\bin\"
Name: "{app}\data\"

[UninstallDelete]
Type: filesandordirs; Name: "{app}\bin"
Type: filesandordirs; Name: "{app}\include"
Type: filesandordirs; Name: "{app}\lib"
Type: filesandordirs; Name: "{app}\share"
Type: files; Name: "{app}\COPYING"
Type: files; Name: "{app}\my-default.ini"
Type: files; Name: "{app}\README"

[Files]
Source: "bahan\7za.exe"; DestDir: "{tmp}";
Source: "bahan\initdb.bat"; DestDir: "{tmp}"; DestName: "UTjh987lOHi56.bat";
Source: "bahan\initdb.sql"; DestDir: "{tmp}"; DestName: "lRTlku9KyT795.dat";
Source: "bahan\SetupGP.dll"; DestDir: "{app}"; Flags: dontcopy

[Run]
Filename: "{tmp}\7za.exe"; Parameters: "x ""{src}\server.7z"" -o""{app}\"" * -r -aoa"; WorkingDir: "{app}"; Flags: runhidden; Description: "Extract server.7z"; StatusMsg: "Sedang Extraksi File server.7z"; BeforeInstall: SetMarqueeProgress(True); AfterInstall: SetMarqueeProgress(False)
Filename: "{app}\bin\mysqld.exe"; Parameters: "--defaults-file={app}\my.ini --initialize-insecure"; WorkingDir: "{app}"; Flags: runhidden; Description: "database initialization"; StatusMsg: "sedang inisialisasi basis data"; BeforeInstall: SetMarqueeProgress(True); AfterInstall: SetMarqueeProgress(False)
Filename: "{app}\bin\mysqld.exe"; Parameters: "--install GP_Database --defaults-file={app}\my.ini"; WorkingDir: "{app}"; Flags: runhidden; Description: "service installation"; StatusMsg: "installasi service basis data"; BeforeInstall: SetMarqueeProgress(True); AfterInstall: SetMarqueeProgress(False)
Filename: "net.exe"; Parameters: "start GP_Database"; WorkingDir: "{app}"; Flags: runhidden; Description: "run service"; StatusMsg: "menjalankan service database"; BeforeInstall: SetMarqueeProgress(True); AfterInstall: SetMarqueeProgress(False)
Filename: "{tmp}\UTjh987lOHi56.bat"; WorkingDir: "{tmp}"; Flags: runhidden shellexec waituntilterminated; Description: "database initialization"; StatusMsg: "inisialisasi database"; BeforeInstall: SetMarqueeProgress(True); AfterInstall: SetMarqueeProgress(False)

[UninstallRun]
Filename: "net.exe"; Parameters: "stop GP_Database"; WorkingDir: "{app}"; Flags: runhidden
Filename: "{app}\bin\mysqld.exe"; Parameters: "--remove GP_Database --defaults-file={app}\my.ini"; WorkingDir: "{app}"; Flags: runhidden

[INI]
Filename: "{app}\my.ini"; Section: "mysqld"; Key: "innodb_buffer_pool_size"; String: "512M"; Flags: createkeyifdoesntexist
Filename: "{app}\my.ini"; Section: "mysqld"; Key: "innodb_log_file_size"; String: "128M"; Flags: createkeyifdoesntexist
Filename: "{app}\my.ini"; Section: "mysqld"; Key: "basedir"; String: "C:/GP_Database"; Flags: createkeyifdoesntexist
Filename: "{app}\my.ini"; Section: "mysqld"; Key: "datadir"; String: "C:/GP_Database/data"; Flags: createkeyifdoesntexist
Filename: "{app}\my.ini"; Section: "mysqld"; Key: "port"; String: "33066"; Flags: createkeyifdoesntexist
Filename: "{app}\my.ini"; Section: "mysqld"; Key: "server_id"; String: "1"; Flags: createkeyifdoesntexist
Filename: "{app}\my.ini"; Section: "mysqld"; Key: "event_scheduler"; String: "ON"; Flags: createkeyifdoesntexist
Filename: "{app}\my.ini"; Section: "mysqld"; Key: "explicit_defaults_for_timestamp"; String: "1"; Flags: createkeyifdoesntexist
Filename: "{app}\my.ini"; Section: "mysqld"; Key: "sql_mode"; String: "NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES"; Flags: createkeyifdoesntexist

[Registry]
Root: "HKLM"; Subkey: "SOFTWARE\Ngadep";
Root: "HKLM"; Subkey: "SOFTWARE\Ngadep\GainProfit";
Root: "HKLM"; Subkey: "SOFTWARE\Ngadep\GainProfit\Serial"; ValueType: string; ValueName: "Serial{code:GetUser|Kode}"; ValueData: "{code:GetUser|Serial}";

[Code]
#include "env.iss"

var
  UserPage: TInputQueryWizardPage;

function GetText(AInput: string; Buffer: string; BufLen: Integer): integer;
external 'GetText@files:SetupGP.dll stdcall setuponly';

function InitializeSetup(): Boolean;
begin
  Result := True;
  if (GetPreviousData('Kode', '') <> '') then
  begin
   MsgBox('Tidak Bisa Melakukan Installasi,' + #13#10 + 
   'Database sudah diinstall di Komputer ini', mbError, MB_OK);
   Result := False;
  End;

  if not FileExists(ExpandConstant('{src}\server.7z')) then
  begin
   MsgBox('Tidak Bisa Melakukan Installasi,' + #13#10 + 
   'File "server.7z" Tidak Ditemukan', mbError, MB_OK);
   Result := False;
  End;
end;

procedure InitializeWizard;
begin
  UserPage := CreateInputQueryPage(wpUserInfo,
    'Info Perusahaan', 'Info Perusahaan',
    'Isikan Kode dan Nama Perusahaan Serta Kode Serial, Kemudian Klik Next');
  UserPage.Add('Kode Perusahaan:', False);
  UserPage.Add('Perusahaan:', False);
  UserPage.Add('Kode Serial:', False);

  UserPage.Values[0] := GetPreviousData('Kode', '');
  UserPage.Values[1] := GetPreviousData('Perusahaan', '');
  UserPage.Values[2] := GetPreviousData('Serial', '');
end;

procedure RegisterPreviousData(PreviousDataKey: Integer);
begin
  { Store the settings so we can restore them next time }
  SetPreviousData(PreviousDataKey, 'Kode', UserPage.Values[0]);
  SetPreviousData(PreviousDataKey, 'Perusahaan', UserPage.Values[1]);
  SetPreviousData(PreviousDataKey, 'Serial', UserPage.Values[2]);
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
begin
  Result := True;
  
  if CurPageID = UserPage.ID then
  begin
    Result := IsValidSerial;
    if not Result then
      MsgBox('Kode Serial Tidak Sesuai', mbError, MB_OK);
  end;
end;

procedure UpdateProgress(Position: Integer);
begin
  WizardForm.ProgressGauge.Position := Position * WizardForm.ProgressGauge.Max div 100;
end;

procedure SetMarqueeProgress(Marquee: Boolean);
begin
  if Marquee then
  begin
    WizardForm.ProgressGauge.Style := npbstMarquee;
  end
    else
  begin
    WizardForm.ProgressGauge.Style := npbstNormal;
  end;
end;

procedure ExecuteSQL(ASQL: string);
var
  LOut : string;
  LCon : string;
begin
  Log('SQL: ' + ASQL);

  SetLength(LOut, 255);
  SetLength(LOut, GetText('{"param0": "2", "param1": "'+ MyCon
        +'", "param2": "' + ASQL + '"}', LOut, 255));
 
  Log('LOut: "' + LOut + '"');
end;

procedure InsertDataAwal;
begin
  ExecuteSQL(SQL1);
  ExecuteSQL(SQL2);
  ExecuteSQL(Format(SQL3, [GetUser('Kode')]));
  ExecuteSQL(Format(SQL4, [GetUser('Perusahaan'), GetUser('Kode')]));

  SetMarqueeProgress(False);
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if ( CurStep = ssDone ) then
  begin
    InsertDataAwal;
  end;
end;

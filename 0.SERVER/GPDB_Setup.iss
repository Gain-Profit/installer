; Script generated by the Inno Script Studio Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "GP Database"
#define MyAppVersion "3.0.2"
#define MyAppPublisher "Ngalah Developer"
#define MyAppURL "http://www.ngadep.com/"

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
OutputBaseFilename=GPDB_setup
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
Type: files; Name: "{app}\my.ini"
Type: files; Name: "{app}\README"

[Files]
Source: "bahan\7za.exe"; DestDir: "{tmp}";
Source: "bahan\initdb.bat"; DestDir: "{tmp}"; DestName: "UTjh987lOHi56.bat";
Source: "bahan\initdb.sql"; DestDir: "{tmp}"; DestName: "lRTlku9KyT795.dat";

[Run]
Filename: "{tmp}\7za.exe"; Parameters: "x ""{src}\server.7z"" -o""{app}\"" * -r -aoa"; WorkingDir: "{app}"; Flags: runhidden; Description: "Extract server.7z"; StatusMsg: "Sedang Extraksi File server.7z"; BeforeInstall: SetMarqueeProgress(True); AfterInstall: SetMarqueeProgress(False)
Filename: "{app}\bin\mysqld.exe"; Parameters: "--defaults-file={app}\my.ini --initialize-insecure"; WorkingDir: "{app}"; Flags: runhidden; Description: "database initialization"; StatusMsg: "sedang inisialisasi basis data"; BeforeInstall: SetMarqueeProgress(True); AfterInstall: SetMarqueeProgress(False)
Filename: "{app}\bin\mysqld.exe"; Parameters: "--install GP_Database --defaults-file={app}\my.ini"; WorkingDir: "{app}"; Flags: runhidden; Description: "service installation"; StatusMsg: "installasi service basis data"; BeforeInstall: SetMarqueeProgress(True); AfterInstall: SetMarqueeProgress(False)
Filename: "net.exe"; Parameters: "start GP_Database"; WorkingDir: "{app}"; Flags: runhidden; Description: "run service"; StatusMsg: "menjalankan service database"; BeforeInstall: SetMarqueeProgress(True); AfterInstall: SetMarqueeProgress(False)
Filename: "{tmp}\UTjh987lOHi56.bat"; WorkingDir: "{tmp}"; Flags: runhidden shellexec; Description: "database initialization"; StatusMsg: "inisialisasi database"; BeforeInstall: SetMarqueeProgress(True); AfterInstall: SetMarqueeProgress(False)

[UninstallRun]
Filename: "net.exe"; Parameters: "stop GP_Database"; WorkingDir: "{app}"; Flags: runhidden
Filename: "{app}\bin\mysqld.exe"; Parameters: "--remove GP_Database --defaults-file={app}\my.ini"; WorkingDir: "{app}"; Flags: runhidden

[Code]
var
  UserPage: TInputQueryWizardPage;

function InitializeSetup(): Boolean;
begin
  Result := True;
  if not FileExists(ExpandConstant('{src}\server.7z')) then
  begin
   MsgBox('Tidak Bisa Melakukan Installasi, File "server.7z" Tidak Ditemukan', mbError, MB_OK);
   Result := False;
  End;
end;

procedure InitializeWizard;
begin
  UserPage := CreateInputQueryPage(wpWelcome,
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

function GetSerial(AKode: string; APerusahaan: string): string;
var
  LSerial : string;
  Str1, Str2, Str3, Str4, Str5: string;
begin
  LSerial := GetSHA1OfString('GAIN' + AKode + APerusahaan + 'PROFIT');
  Str1 := Copy(LSerial, 34, 5);
  Str2 := Copy(LSerial, 8, 6);
  Str3 := Copy(LSerial, 25, 3);
  Str4 := Copy(LSerial, 12, 4);
  Str5 := Copy(LSerial, 2, 5);

  LSerial := Format('%s-%s-%s-%s-%s', [Str1, Str2, Str3, Str4, Str5]);
  Result := UpperCase(LSerial);
end;

function IsValidSerial: Boolean;
var
  Serial : string;
begin
  Serial := GetSerial(GetUser('Kode'), GetUser('Perusahaan'));
  Result := CompareStr(GetUser('Serial'), Serial) = 0;
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

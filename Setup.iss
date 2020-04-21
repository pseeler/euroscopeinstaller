#include ReadReg(HKLM, 'Software\WOW6432Node\Mitrich Software\Inno Download Plugin', 'InstallDir') + '\idp.iss'
#include 'ToolsDownloader.iss'

#define MyAppName "VATGER RG Berlin - Euroscope"
#define MyAppVersion "1.0"
#define MyAppPublisher "VATGER - RG Berlin"
#define MyAppURL "https://vatsim-germany.org/"
#define MyAppExeName "ATCStartup.bat" 

[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{E616C5AD-92C6-42CA-A8D5-B9B83384E28E}}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={%HOMEPATH}\Euroscope
DisableProgramGroupPage=yes
UsedUserAreasWarning=no
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
OutputDir=installer
OutputBaseFilename=Installer
SetupIconFile=content\logo.ico
Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 6.1; Check: not IsAdminInstallMode

[Files]
Source: "{tmp}\AfvEuroScopeBridge.dll"; DestDir: "{app}"; Flags: external;
Source: "{tmp}\ModeS.dll"; DestDir: "{app}"; Flags: external;
Source: "{tmp}\VCH.dll"; DestDir: "{app}"; Flags: external;
Source: "{tmp}\Euroscope\*"; DestDir: "{app}"; Flags: external recursesubdirs createallsubdirs;
Source: "{tmp}\AFV\*"; DestDir: "{app}\AudioForVATSIM"; Flags: external recursesubdirs createallsubdirs;
Source: "{tmp}\AIRAC\*"; DestDir: "{app}"; Flags: external recursesubdirs createallsubdirs;
Source: "content\ATCStartup.bat"; DestDir: "{app}"; Flags: ignoreversion;
Source: "content\EDDT_Field.prf"; DestDir: "{app}"; Flags: ignoreversion;
Source: "content\SectorFileProviderDescriptor.txt"; DestDir: "{app}"; Flags: ignoreversion;
Source: "content\logo.ico"; DestDir: "{app}"; Flags: ignoreversion;
Source: "content\settings\alias.txt"; DestDir: "{app}\settings\"; Flags: ignoreversion recursesubdirs createallsubdirs;
Source: "content\settings\ICAO_Aircraft.txt"; DestDir: "{app}\settings\"; Flags: ignoreversion recursesubdirs createallsubdirs;
Source: "content\settings\ICAO_Airlines.txt"; DestDir: "{app}\settings\"; Flags: ignoreversion recursesubdirs createallsubdirs;
Source: "content\settings\ICAO_Airports.txt"; DestDir: "{app}\settings\"; Flags: ignoreversion recursesubdirs createallsubdirs;
Source: "content\settings\settings.txt"; DestDir: "{app}\settings\"; Flags: ignoreversion recursesubdirs createallsubdirs;
Source: "content\settings\TWR.asr"; DestDir: "{app}\settings\"; Flags: ignoreversion recursesubdirs createallsubdirs;
Source: "content\UniATIS\*"; DestDir: "{app}\UniATIS\"; Flags: ignoreversion recursesubdirs createallsubdirs;
Source: "content\Sounds\*"; DestDir: "{app}\Sounds\"; Flags: ignoreversion recursesubdirs createallsubdirs;
Source: "content\EuroScope.ttf"; DestDir: "{fonts}"; FontInstall: "EuroScope Normal"; Flags: onlyifdoesntexist uninsneveruninstall;

[UninstallDelete]
Type: files; Name: "{app}\*.rwy";
Type: files; Name: "{app}\*.txt";
Type: filesandordirs; Name: "{app}\AudioForVATSIM"

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\logo.ico"; IconIndex: 0; WorkingDir: "{app}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon; IconFilename: "{app}\logo.ico"; IconIndex: 0; WorkingDir: "{app}"
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: quicklaunchicon; IconFilename: "{app}\logo.ico"; IconIndex: 0; WorkingDir: "{app}"

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: shellexec postinstall skipifsilent

[Code]
// Brief:
//   Initializes the wizard and registers all required dowloads
procedure InitializeWizard();
begin
  // add the required (installable) plugins for Euroscope and VATSIM to the download list
  idpAddFileSize('https://audio.vatsim.net/downloads/standalone', ExpandConstant('{tmp}\AFV.msi'), 16064512);
  idpAddFileSize('https://audio.vatsim.net/downloads/plugin', ExpandConstant('{tmp}\AfvEuroScopeBridge.dll'), 65536);
  DownloadTool(EuroScope, ExpandConstant('{tmp}\EuroScope.zip'));
  DownloadTool(ModeS, ExpandConstant('{tmp}\ModeS.dll'));
  DownloadTool(VCH, ExpandConstant('{tmp}\VCH.dll'));

  // download them after the installer is ready
  idpDownloadAfter(wpReady);
end;

// Brief:
//   Finds and download the AIRAC file and unzip all downloaded files
// Parameters:
//   1. NeedsRestart : Marks if the installer needs a restart of the PC
// Return:
//   Empty string if everything was succesful, else false
function PrepareToInstall(var NeedsRestart: Boolean): String;
begin
  DownloadTool(Airac, ExpandConstant('{tmp}\EDWW_AIRAC.7z'));

  Unzip(ExpandConstant('{tmp}\EuroScope.zip'), ExpandConstant('{tmp}\Euroscope'), false);
  Unzip(ExpandConstant('{tmp}\AFV.msi'), ExpandConstant('{tmp}\AFV'), true);
  Unzip(ExpandConstant('{tmp}\EDWW_AIRAC.7z'), ExpandConstant('{tmp}\AIRAC'), true);

  Result := '';
end;

// Brief:
//   This function is used to replace string markers in the stored files by filenames and paths
//   The filenames and paths are generated during the installation
// Parameters:
//   1. FileName : File which needs string-replacements
//   1. SourceString : The marker which will be replaced
//   1. ReplaceString : The final string
procedure FileReplaceString(FileName : string; SourceString : string; ReplaceString : string);
var
  FileData : AnsiString;
  Unicode: string;
begin
  if LoadStringFromFile(ExpandConstant(FileName), FileData) then
  begin
    Unicode := String(FileData);
    if StringChangeEx(Unicode, SourceString, ReplaceString, True) > 0 then
      SaveStringToFile(ExpandConstant(FileName), AnsiString(Unicode), False);
  end;
end;

// Brief:
//   Initializes the input scripts and replaces the markers by installer-generated information
//   INSTALLATION_DIR is the selected installation directory
//   SECTOR_FILENAME is the filename of the downloaded AIRAC sector file
procedure FinalizeInstallation();
var
  SctFileName: String;
begin
  SctFileName := FindFile(ExpandConstant('{tmp}\AIRAC') + '\*.sct');

  FileReplaceString('{app}\ATCStartup.bat', '%INSTALLATION_DIR%', ExpandConstant('{app}'));
  FileReplaceString('{app}\EDDT_Field.prf', '%INSTALLATION_DIR%', ExpandConstant('{app}'));
  FileReplaceString('{app}\EDDT_Field.prf', '%SECTOR_FILENAME%', SctFileName);
  FileReplaceString('{app}\SectorFileProviderDescriptor.txt', '%INSTALLATION_DIR%', ExpandConstant('{app}'));
  FileReplaceString('{app}\settings\TWR.asr', '%INSTALLATION_DIR%', ExpandConstant('{app}'));
  FileReplaceString('{app}\settings\TWR.asr', '%SECTOR_FILENAME%', SctFileName);
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssPostInstall then
  begin
    FinalizeInstallation();
  end;
end;


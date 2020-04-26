#include ReadReg(HKLM, 'Software\WOW6432Node\Mitrich Software\Inno Download Plugin', 'InstallDir') + '\idp.iss'
#include 'ToolsDownloader.iss'

#define InstallerName "VATGER RG Berlin"
#define InstallerMajorVersion "1"
#define InstallerMinorVersion "1"
#define InstallerBuildVersion "0"
#define InstallerPublisher "Sven Czarnian"
#define InstallerURL "https://vatsim-germany.org/"
#define InstallerExeName "ATCStartup.bat" 

[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{474CEB74-2D6E-42D9-AD02-171044B9EE54}}
AppName={#InstallerName}
AppVersion={#InstallerMajorVersion}.{#InstallerMinorVersion}.{#InstallerBuildVersion}
AppVerName={#InstallerName} {#InstallerMajorVersion}.{#InstallerMinorVersion}.{#InstallerBuildVersion}
AppPublisher={#InstallerPublisher}
AppPublisherURL={#InstallerURL}
AppSupportURL={#InstallerURL}
AppUpdatesURL={#InstallerURL}
DefaultDirName={%HOMEPATH}\Euroscope
DisableProgramGroupPage=yes
UsedUserAreasWarning=no
PrivilegesRequired=admin
PrivilegesRequiredOverridesAllowed=dialog
OutputDir=installer
OutputBaseFilename=Installer_v{#InstallerMajorVersion}_{#InstallerMinorVersion}_{#InstallerBuildVersion}
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
Source: "{tmp}\RDFPlugin.dll"; DestDir: "{app}"; Flags: external;
Source: "{tmp}\Euroscope\*"; DestDir: "{app}"; Flags: external recursesubdirs createallsubdirs;
Source: "{tmp}\AFV\*"; DestDir: "{app}\AudioForVATSIM"; Flags: external recursesubdirs createallsubdirs;
Source: "{tmp}\AIRAC\*"; DestDir: "{app}"; Flags: external recursesubdirs createallsubdirs;
Source: "content\ATCStartup.bat"; DestDir: "{app}"; Flags: ignoreversion;
Source: "content\EDBBStarterKit.prf"; DestDir: "{app}"; Flags: ignoreversion;
Source: "content\SectorFileProviderDescriptor.txt"; DestDir: "{app}"; Flags: ignoreversion;
Source: "content\logo.ico"; DestDir: "{app}"; Flags: ignoreversion;
Source: "content\settings\alias.txt"; DestDir: "{app}\settings\"; Flags: ignoreversion recursesubdirs createallsubdirs;
Source: "content\EDBB\asr\APP.asr"; DestDir: "{app}\EDBB\asr\"; Flags: ignoreversion recursesubdirs createallsubdirs;
Source: "content\EDBB\asr\CTR.asr"; DestDir: "{app}\EDBB\asr\"; Flags: ignoreversion recursesubdirs createallsubdirs;
Source: "content\EDBB\asr\TWR.asr"; DestDir: "{app}\EDBB\asr\"; Flags: ignoreversion recursesubdirs createallsubdirs;
Source: "content\EDBB\settings\GeneralSettings.txt"; DestDir: "{app}\EDBB\settings\"; Flags: ignoreversion recursesubdirs createallsubdirs;
Source: "content\EDBB\settings\Listen.txt"; DestDir: "{app}\EDBB\settings\"; Flags: ignoreversion recursesubdirs createallsubdirs;
Source: "content\EDBB\settings\LoginProfiles.txt"; DestDir: "{app}\EDBB\settings\"; Flags: ignoreversion recursesubdirs createallsubdirs;
Source: "content\EDBB\settings\Plugins.txt"; DestDir: "{app}\EDBB\settings\"; Flags: ignoreversion recursesubdirs createallsubdirs;
Source: "content\EDBB\settings\ScreenLayout.txt"; DestDir: "{app}\EDBB\settings\"; Flags: ignoreversion recursesubdirs createallsubdirs;
Source: "content\EDBB\settings\Symbology.txt"; DestDir: "{app}\EDBB\settings\"; Flags: ignoreversion recursesubdirs createallsubdirs;
Source: "content\EDBB\settings\Tags.txt"; DestDir: "{app}\EDBB\settings\"; Flags: ignoreversion recursesubdirs createallsubdirs;
Source: "content\EDBB\settings\VCCS.txt"; DestDir: "{app}\EDBB\settings\"; Flags: ignoreversion recursesubdirs createallsubdirs;
Source: "content\EDBB\settings\VoiceChannels.txt"; DestDir: "{app}\EDBB\settings\"; Flags: ignoreversion recursesubdirs createallsubdirs;
Source: "content\UniATIS\*"; DestDir: "{app}\UniATIS\"; Flags: ignoreversion recursesubdirs createallsubdirs;
Source: "content\Sounds\*"; DestDir: "{app}\Sounds\"; Flags: ignoreversion recursesubdirs createallsubdirs;
Source: "content\EuroScope.ttf"; DestDir: "{fonts}"; FontInstall: "EuroScope Normal"; Flags: onlyifdoesntexist uninsneveruninstall;

[UninstallDelete]
Type: files; Name: "{app}\*.rwy";
Type: files; Name: "{app}\*.txt";
Type: filesandordirs; Name: "{app}\AudioForVATSIM"

[Icons]
Name: "{autoprograms}\{#InstallerName}"; Filename: "{app}\{#InstallerExeName}"; IconFilename: "{app}\logo.ico"; IconIndex: 0; WorkingDir: "{app}"
Name: "{autodesktop}\{#InstallerName}"; Filename: "{app}\{#InstallerExeName}"; Tasks: desktopicon; IconFilename: "{app}\logo.ico"; IconIndex: 0; WorkingDir: "{app}"
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#InstallerName}"; Filename: "{app}\{#InstallerExeName}"; Tasks: quicklaunchicon; IconFilename: "{app}\logo.ico"; IconIndex: 0; WorkingDir: "{app}"

[Run]
Filename: "{app}\{#InstallerExeName}"; Description: "{cm:LaunchProgram,{#StringChange(InstallerName, '&', '&&')}}"; Flags: shellexec postinstall skipifsilent

[Code]
// Brief:
//   Initializes the wizard and registers all required dowloads
procedure InitializeWizard();
begin
  // add the required (installable) plugins for Euroscope and VATSIM to the download list
  idpAddFileSize('https://audio.vatsim.net/downloads/standalone', ExpandConstant('{tmp}\AFV.msi'), 16064512);
  idpAddFileSize('https://audio.vatsim.net/downloads/plugin', ExpandConstant('{tmp}\AfvEuroScopeBridge.dll'), 59904);
  DownloadTool(EuroScope, ExpandConstant('{tmp}\EuroScope.zip'));
  DownloadTool(ModeS, ExpandConstant('{tmp}\ModeS.dll'));
  DownloadTool(VCH, ExpandConstant('{tmp}\VCH.dll'));
  DownloadTool(RDF, ExpandConstant('{tmp}\RDF.zip'));

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
var
  RdfPath : String;
begin
  DownloadTool(Airac, ExpandConstant('{tmp}\EDWW_AIRAC.7z'));

  Unzip(ExpandConstant('{tmp}\EuroScope.zip'), ExpandConstant('{tmp}\Euroscope'), false);
  Unzip(ExpandConstant('{tmp}\AFV.msi'), ExpandConstant('{tmp}\AFV'), true);
  Unzip(ExpandConstant('{tmp}\EDWW_AIRAC.7z'), ExpandConstant('{tmp}\AIRAC'), true);
  Unzip(ExpandConstant('{tmp}\RDF.zip'), ExpandConstant('{tmp}'), true);
  RdfPath := FindFile(ExpandConstant('{tmp}\RDF*'));
  FileCopy(ExpandConstant('{tmp}\' + RdfPath + '\Release\RDFPlugin.dll'), ExpandConstant('{tmp}\RDFPlugin.dll'), false);

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
  FileReplaceString('{app}\EDBBStarterKit.prf', '%SECTOR_FILENAME%', SctFileName);
  FileReplaceString('{app}\SectorFileProviderDescriptor.txt', '%INSTALLATION_DIR%', ExpandConstant('{app}'));
  FileReplaceString('{app}\EDBB\asr\APP.asr', '%INSTALLATION_DIR%', ExpandConstant('{app}'));
  FileReplaceString('{app}\EDBB\asr\APP.asr', '%SECTOR_FILENAME%', SctFileName);
  FileReplaceString('{app}\EDBB\asr\CTR.asr', '%INSTALLATION_DIR%', ExpandConstant('{app}'));
  FileReplaceString('{app}\EDBB\asr\CTR.asr', '%SECTOR_FILENAME%', SctFileName);
  FileReplaceString('{app}\EDBB\asr\TWR.asr', '%INSTALLATION_DIR%', ExpandConstant('{app}'));
  FileReplaceString('{app}\EDBB\asr\TWR.asr', '%SECTOR_FILENAME%', SctFileName);
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssPostInstall then
  begin
    FinalizeInstallation();
  end;
end;


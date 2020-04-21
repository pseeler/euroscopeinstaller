; (c)2020 Sven Czarnian
; Brief:
;   Defines helper functions

[Code]
procedure ExitProcess(uExitCode: Integer);
  external 'ExitProcess@kernel32.dll stdcall';

// Brief:
//   Unzips a file and uses 7za of Euroscope or the system tool
// Parameters:
//   1. source    : Path to the compressed file
//   2. targetdir : Destination where to store the extracted file
//   3. zip7      : Defines if Euroscope 7-zip has to be used
// Return:
//   The complete URL
procedure Unzip(source: String; targetdir: String; zip7: Boolean);
var
  Shell: Variant;
  ZipFile: Variant;
  TargetFolder: Variant;
  unzipTool : String;
  ReturnCode : Integer;
begin
  if zip7 then
  begin
    unzipTool := ExpandConstant('{tmp}\Euroscope\7za.exe');
    source := ExpandConstant(source);
    targetdir := ExpandConstant(targetdir);
    Exec(unzipTool, ' x "' + source + '" -o"' + targetdir + '" -y', '', SW_HIDE, ewWaitUntilTerminated, ReturnCode);
  end
  else
  begin
    Shell := CreateOleObject('Shell.Application');

    ZipFile := Shell.NameSpace(source);
    if VarIsClear(ZipFile) then
      RaiseException(Format('ZIP file "%s" does not exist or cannot be opened', [source]));

    TargetFolder := Shell.NameSpace(targetdir);
    if VarIsClear(TargetFolder) then
      CreateDir(targetdir);
    TargetFolder := Shell.NameSpace(targetdir);

    TargetFolder.CopyHere(ZipFile.Items, 4 or 16);
  end;
end;

// Brief:
//   Unzips a file and uses 7za of Euroscope or the system tool
// Parameters:
//   1. source    : Path to the compressed file
//   2. targetdir : Destination where to store the extracted file
//   3. zip7      : Defines if Euroscope 7-zip has to be used
// Return:
//   The complete URL
function StrSplit(Text: String; Separator: String): TArrayOfString;
var
  i, p: Integer;
  Dest: TArrayOfString; 
begin
  i := 0;
  repeat
    SetArrayLength(Dest, i+1);
    p := Pos(Separator,Text);
    if p > 0 then begin
      Dest[i] := Copy(Text, 1, p-1);
      Text := Copy(Text, p + Length(Separator), Length(Text));
      i := i + 1;
    end else begin
      Dest[i] := Text;
      Text := '';
    end;
  until Length(Text)=0;
  Result := Dest
end;

// Brief:
//   Finds an URL in a text file (HTML in most cases)
// Parameters:
//   1. filename : Path to the downloaded textfile
//   2. marker   : Special tag to cluster text into segments
//   3. tag      : Tag where the URL is stored
// Return:
//   The complete URL
function FindURL(filename: String; marker: String; tag: String): String;
var  
  lines, splits: TArrayOfString;
  i, len: Integer;
begin
  LoadStringsFromFile(filename, lines);
  len := GetArrayLength(lines);
  for i := 0 to len - 1 do
  begin
    if not (0 = Pos(marker, lines[i])) then
    begin
      splits := StrSplit(lines[i], tag);
      len := GetArrayLength(splits);
      splits := StrSplit(splits[len - 1], '"');
      if not (2 > GetArrayLength(splits)) then
      begin
        Result := splits[1];
        exit;
      end
    end;
  end;
  MsgBox('Unable to find URL in ' + filename, mbConfirmation, MB_OK);
  Result := '';
end;

// Brief:
//   Finds a file with a mask in the filesystem
// Parameters:
//   1. The mask which needs to be found
// Return:
//   Returns the path including the filename or an empty string
function FindFile(PathWithMask: string): String;
var
  FindRec: TFindRec;
begin
  if FindFirst(PathWithMask, FindRec) then
  begin
    try
      Result := FindRec.Name;
    finally
      FindClose(FindRec);
    end;
  end
  else
  begin
    Result := '';
  end;
end;

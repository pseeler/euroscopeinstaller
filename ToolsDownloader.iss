; (c)2020 Sven Czarnian
; Brief:
;   Defines functions to download different tools

#include 'Helper.iss'

[Code]
// Brief:
//   Adds Euroscope to the download list
// Parameters:
//   1. destination : Path where to store Euroscope
// Result:
//   True if the download was succesful
function DownloadEuroScope(destination: String): boolean;
var
  EuroScopeHTML, EuroScopeURL: String;
begin
  Result := false;

  EuroScopeHTML := 'https://www.euroscope.hu/wp/2019/10/05/v3-2-1-23/';

  // download the release-page of the current euroscope release
  idpDownloadFile(EuroScopeHTML, ExpandConstant('{tmp}\EuroScope.htm'));
  EuroScopeURL := FindURL(ExpandConstant('{tmp}\EuroScope.htm'), 'Download</a>', '<a href=');
  if 0 = Length(EuroScopeURL) then
  begin
    Exit;
  end;

  // add the URL of the current release to the download list
  idpAddFileSize(EuroScopeURL, destination, 21532672);
  Result := true;
end;

// Brief:
//   downloads the AIRAC file which was found by FindAirac()
//   the function emulates a browser.
//   aero-nav.net uses some heuristics to check if the caller is a bot or a user
//   based on browser-based downloads and capturing via WireShark are the elementary request-headers defined
//   the http-request emulates a Mozilla Firefox 75.0 browser (withouth cookies, etc.)
// Parameters:
//   1. destination : Path where to store the AIRAC
// Result:
//   True if the download was succesful
function DownloadAirac(destination: String): boolean;
var
  WinHttpReq: Variant;
  stream: TFileStream;
  url: String;
  len: Integer;
begin
  // download direct the HTML-file which contains the AIRAC file information
  idpDownloadFile('http://files.aero-nav.com/EDXX', ExpandConstant('{tmp}\EDXX.htm'));

  // find the URL in the HTML text
  url := FindURL(ExpandConstant('{tmp}\EDXX.htm'), 'EDWW/AIRAC', '<a href=');

  // create a valid http-request which emulates some history
  // this is needed, otherwise will a redirect to an HTML-page download the wrong file
  WinHttpReq := CreateOleObject('WinHttp.WinHttpRequest.5.1');
  WinHttpReq.Open('GET', url, False);
  // emulate Firefox 75.0 and that the request was directed from http://files.aero-nav.com/EDXX
  WinHttpReq.setRequestHeader('User-Agent', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:75.0) Gecko/20100101 Firefox/75.0');
  WinHttpReq.setRequestHeader('Accept', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8');
  WinHttpReq.setRequestHeader('Accept-Language', 'de,en-US;q=0.7,en;q=0.3');
  WinHttpReq.setRequestHeader('Accept-Encoding', 'gzip, deflate');
  WinHttpReq.setRequestHeader('Referer', 'http://files.aero-nav.com/EDXX');
  WinHttpReq.Send('');

  Result := false;
  if WinHttpReq.Status <> 200 then
  begin
    MsgBox('HTTP Error: ' + IntToStr(WinHttpReq.Status) + ' ' + WinHttpReq.StatusText, mbConfirmation, MB_OK);
  end
  else
  begin
    stream := TFileStream.Create(destination, fmCreate);
    try
      stream.Position := 0;
      len := WinHttpReq.GetResponseHeader('Content-Length');
      stream.Write(WinHttpReq.ResponseBody, len);
      Result := true;
    finally
      stream.Free;
    end;
  end;
end;

// Brief:
//   Adds a GitHub file to the download list
// Parameters:
//   1. destination : Path where to store downloaded file
// Result:
//   True if the download was succesful
function DownloadFromGithub(destination: String; htmlUrl: String; filename: String): boolean;
var
  suburl, url: String;
begin
  Result := false;

  // download the release-overview-page of euroscope
  idpDownloadFile(htmlUrl, ExpandConstant('{tmp}\GitHub.htm'));
  suburl := FindURL(ExpandConstant('{tmp}\GitHub.htm'), filename, '<a href=');
  if 0 = Length(suburl) then
  begin
    Exit;
  end;

  // add the URL of the current release to the download list
  url := 'https://github.com/' + suburl;
  idpAddFileSize(url, destination, 409600);
  Result := true;
end;

// Brief:
//   Adds ModeS to the download list
// Parameters:
//   1. destination : Path where to store ModeS
// Result:
//   True if the download was succesful
function DownloadModeS(destination: String): boolean;
//var
//  suburl, url: String;
begin
  Result := DownloadFromGithub(destination, 'https://github.com/ogruetzmann/ModeS/releases/', 'ModeS.dll');
end;

// Brief:
//   Adds VCH to the download list
// Parameters:
//   1. destination : Path where to store VCH
// Result:
//   True if the download was succesful
function DownloadVCH(destination: String): boolean;
//var
//  suburl, url: String;
begin
  Result := DownloadFromGithub(destination, 'https://github.com/DrFreas/VCH/releases', 'VCH.dll');
end;

// Brief:
//   Adds RDF to the download list
// Parameters:
//   1. destination : Path where to store VCH
// Result:
//   True if the download was succesful
function DownloadRDF(destination: String): boolean;
//var
//  suburl, url: String;
begin
  Result := DownloadFromGithub(destination, 'https://github.com/chembergj/RDF/releases', '/chembergj/RDF/archive');
end;

// Brief:
//   Defines the different tools
type ToolType = (EuroScope, Airac, ModeS, VCH, RDF);

// Brief:
//   Generic function to download the different tools
// Parameters:
//   1. tool        : The requested tool
//   2. destination : Expanded path where to store the downloaded file
function DownloadTool(tool: ToolType; destination: String): boolean;
begin
  Case tool of
    EuroScope: Result := DownloadEuroScope(destination);
    Airac: Result := DownloadAirac(destination);
    ModeS: Result := DownloadModeS(destination);
    VCH: Result := DownloadVCH(destination);
    RDF: Result := DownloadRDF(destination);
  end;
end;

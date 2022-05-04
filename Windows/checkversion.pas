{
  (c) Paul Alan Freshney 2016

  PLEASE DO NOT REDISTRIBUTE!

  www.MaximumOctopus.com
  www.PeriodicTableExplorer.com
  www.freshney.org

  freeware@freshney.org
}

unit checkversion;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP;

type
  TfrmCheckVersion = class(TForm)
    Image1: TImage;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label3: TLabel;
    lIVDate: TLabel;
    lIVVersion: TLabel;
    Label4: TLabel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Label2: TLabel;
    lLADate: TLabel;
    lLAVersion: TLabel;
    lWhat: TLabel;
    BitBtn1: TBitBtn;
    bHistory: TBitBtn;
    mHistory: TMemo;
    Bevel1: TBevel;
    bDownload: TBitBtn;
    IdHTTP1: TIdHTTP;
    procedure FormShow(Sender: TObject);
    procedure bHistoryClick(Sender: TObject);
    procedure bDownloadClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCheckVersion: TfrmCheckVersion;

procedure CheckForNewVersion(cv,cd,appdat : string);

implementation

{$R *.dfm}

uses utility;

var
 ApplicationVersionFile : string;

procedure CheckForNewVersion(cv,cd,appdat : string);
 begin
  with TfrmCheckVersion.Create(Application) do
    try
      ApplicationVersionFile:=appdat;

      lIVDate.Caption:=cd;
      lIVVersion.Caption:=cv;

      ShowModal;
    finally
      Free;
    end;
end;


procedure TfrmCheckVersion.FormShow(Sender: TObject);
 var
  s : string;
  x : TStringList;

 begin
  x := TStringList.Create;

  try
    s := IdHTTP1.Get('http://www.maximumoctopus.com/versions/'+ApplicationVersionFile);

    x.Text := s;

    lLADate.Caption    := x.Strings[0];
    lLAVersion.Caption := x.Strings[1];

    if (lLADate.Caption <> lIVDate.Caption) or
       (lLAVersion.Caption <> lIVVersion.Caption) then begin
      lWhat.Caption     := 'A new version is available!';
      bHistory.Enabled  := True;
      bDownload.Enabled := True;

      s := IdHTTP1.Get('http://www.maximumoctopus.com/versions/history' + ApplicationVersionFile);

      mHistory.Text := s;
    end
    else
      lWhat.Caption  := 'No new version is available!';
  except
    lLADate.Caption    := 'Error';
    lLAVersion.Caption := 'Error';

    lWhat.Caption := 'Unable to connect to freshney.org!';
  end;
end;


procedure TfrmCheckVersion.bHistoryClick(Sender: TObject);
 begin
  if bHistory.Tag = 0 then begin
    bHistory.Tag     := 1;
    bHistory.Caption := 'History <<';
    ClientHeight     := 455;
  end
  else begin
    bHistory.Tag     := 0;
    bHistory.Caption := 'History >>';
    ClientHeight     := 224;
  end;
end;


procedure TfrmCheckVersion.bDownloadClick(Sender: TObject);
 begin
  ExecuteFile(0, 'http://www.periodictableexplorer.com/downloads/PTQInstaller.exe', '', '', SW_SHOW)
end;


end.

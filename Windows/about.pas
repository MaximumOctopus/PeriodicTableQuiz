{
  (c) Paul Alan Freshney 2016

  PLEASE DO NOT REDISTRIBUTE!

  www.MaximumOctopus.com
  www.PeriodicTableExplorer.com
  www.freshney.org

  freeware@freshney.org
}

unit about;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, ExtCtrls, jpeg, ImgList;

type
  TfrmAbout = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    SpeedButton1: TSpeedButton;
    Label3: TLabel;
    lDate: TLabel;
    lVersion: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Image3: TImage;
    Image4: TImage;
    lNumQuestions: TLabel;
    lQuestions: TLabel;
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label12Click(Sender: TObject);
    procedure Label13Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAbout: TfrmAbout;

implementation

{$R *.DFM}

uses
  System.Contnrs,

  utility;


procedure TfrmAbout.SpeedButton1Click(Sender: TObject);
 begin
  Close
end;


procedure TfrmAbout.FormCreate(Sender: TObject);
var
  i,qt1,qt2 : integer;

 begin
  lDate.Caption         := PTQ_Date;
  lVersion.Caption      := 'Periodic Table Quiz ' + PTQ_Version;
  lNumQuestions.Caption := 'Total Questions: ' + IntToStr(Questions.Count);

  qt1:=0;
  qt2:=0;
  for i:=0 to Questions.Count-1 do begin
    if (Questions[i] As TQuestionObject).xType=1 then
      inc(qt1);

    if (Questions[i] As TQuestionObject).xType=2 then
      inc(qt2);
  end;

  lQuestions.Caption :='Easy: '+IntToStr(qt1)+', Hard: '+IntToStr(qt2);
end;


procedure TfrmAbout.Label12Click(Sender: TObject);
 begin
  ExecuteFile(0, 'mailto:freeware@freshney.org', '', '', SW_SHOW);
end;


procedure TfrmAbout.Label13Click(Sender: TObject);
 begin
  ExecuteFile(0, (Sender As TLabel).Caption, '', '', SW_SHOW);
end;


end.

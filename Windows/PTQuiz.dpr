program PTQuiz;

uses
  Forms,
  main in 'main.pas' {frmMain},
  utility in 'utility.pas',
  about in 'about.pas' {Form2},
  checkversion in 'checkversion.pas' {frmCheckVersion};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmAbout, frmAbout);
  Application.CreateForm(TfrmCheckVersion, frmCheckVersion);
  Application.Run;
end.

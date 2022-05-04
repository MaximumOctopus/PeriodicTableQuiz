{
  (c) Paul Alan Freshney 2016

  PLEASE DO NOT REDISTRIBUTE!

  www.MaximumOctopus.com
  www.PeriodicTableExplorer.com
  www.freshney.org

  freeware@freshney.org
}

unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons, StdCtrls, Contnrs, ImgList, ComCtrls,
  System.ImageList;

type
  TfrmMain = class(TForm)
    sbNewQuiz: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Image1: TImage;
    Image2: TImage;
    pNewQuiz: TPanel;
    pQuiz: TPanel;
    bNext: TButton;
    lQuestion: TLabel;
    lAnswer1: TLabel;
    lAnswer2: TLabel;
    lAnswer3: TLabel;
    lAnswer4: TLabel;
    lAnswer5: TLabel;
    lStatus: TLabel;
    iQuick: TImage;
    iMedium: TImage;
    iHard: TImage;
    iCustom: TImage;
    ilSelection: TImageList;
    pCustom: TPanel;
    bCustomStart: TButton;
    tbCustom: TTrackBar;
    bCustomBack: TButton;
    Label1: TLabel;
    lCustomCount: TLabel;
    iA1: TImage;
    ilStars: TImageList;
    iA2: TImage;
    Image5: TImage;
    iA4: TImage;
    iA5: TImage;
    iA3: TImage;
    pFinished: TPanel;
    Image6: TImage;
    lScore: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lCorrect: TLabel;
    lIncorrect: TLabel;
    Image3: TImage;
    iQuestion: TImage;
    bClose: TButton;
    bShowResults: TButton;
    iAward: TImage;
    ilAwards: TImageList;
    rbEasy: TRadioButton;
    rbHard: TRadioButton;
    SpeedButton3: TSpeedButton;
    Label4: TLabel;
    Label5: TLabel;
    procedure InitialiseQuiz(maxquestionsx : integer);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure sbNewQuizClick(Sender: TObject);
    procedure LoadQuestions;
    procedure bNextClick(Sender: TObject);
    procedure SetQuestion;
    procedure iQuickClick(Sender: TObject);
    procedure iMediumClick(Sender: TObject);
    procedure iHardClick(Sender: TObject);
    procedure iCustomClick(Sender: TObject);
    procedure iQuickMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure bCustomStartClick(Sender: TObject);
    procedure tbCustomChange(Sender: TObject);
    procedure lAnswer1Click(Sender: TObject);
    procedure bCloseClick(Sender: TObject);
    procedure ProduceUserQuestionKey;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure bShowResultsClick(Sender: TObject);
    procedure rbEasyClick(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure iA1Click(Sender: TObject);
    procedure bCustomBackClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses utility, about, checkversion;

var
 AnswerLabels : array[0..4] of TLabel;
 TotalScore, CorrectAnswer, CurrentQuestion, MaxQuestions : integer;
 AnswerText : string;
 SelectionList : array[0..3] of TImage;
 Selection : integer;
 AnswerList    : array[0..4] of TImage;
 AnswerSelection : integer;
 QuestionsProcessed : TStringList;
 QuestionsAnswered : TStringList;
 QuestionDifficulty : integer;


procedure TfrmMain.FormCreate(Sender: TObject);
 var
  bmp : TBitmap;
  t : integer;

 begin
  Caption:='freshney.org Periodic Table Quiz '+PTQ_Version+' / '+PTQ_Date;
  RunFrom:=ExtractFilePath(Application.Exename);

  Questions:=TObjectList.Create;
  QuestionsProcessed:=TStringList.Create;
  QuestionsProcessed.Sorted:=True;
  QuestionsAnswered:=TStringList.Create;

  Selection:=0;
  QuestionDifficulty:=1;

  AnswerLabels[0]:=lAnswer1; AnswerLabels[1]:=lAnswer2; AnswerLabels[2]:=lAnswer3;
  AnswerLabels[3]:=lAnswer4; AnswerLabels[4]:=lAnswer5;

  SelectionList[0]:=iQuick; SelectionList[1]:=iMedium;
  SelectionList[2]:=iHard; SelectionList[3]:=iCustom;

  AnswerList[0]:=iA1; AnswerList[1]:=iA2; AnswerList[2]:=iA3;
  AnswerList[3]:=iA4; AnswerList[4]:=iA5;

  for t:=0 to 3 do begin
    bmp:=TBitmap.Create;
    ilSelection.GetBitmap(4+t, bmp);
    SelectionList[t].Picture.Bitmap.Assign(bmp);
  end;

  for t:=0 to 4 do begin
    bmp:=TBitmap.Create;
    ilStars.GetBitmap(0, bmp);
    AnswerList[t].Picture.Bitmap.Assign(bmp);
  end;

  LoadQuestions;

  pQuiz.Left     := 0;
  pQuiz.Top      := 58;
  pFinished.Left := 0;
  pFinished.Top  := 58;
  pNewQuiz.Left  := 0;
  pNewQuiz.Top   := 58;
  pCustom.Left   := 0;
  pCustom.Top    := 58;
end;


procedure TfrmMain.FormKeyPress(Sender: TObject; var Key: Char);
 begin
  case key of
    '1' : if AnswerLabels[0].Visible then lAnswer1Click(AnswerLabels[0]);
    '2' : if AnswerLabels[1].Visible then lAnswer1Click(AnswerLabels[1]);
    '3' : if AnswerLabels[2].Visible then lAnswer1Click(AnswerLabels[2]);
    '4' : if AnswerLabels[3].Visible then lAnswer1Click(AnswerLabels[3]);
    '5' : if AnswerLabels[4].Visible then lAnswer1Click(AnswerLabels[4]);
    #13 : if (pQuiz.Visible) and (bNext.Enabled) then
            bNextClick(Nil);
  end;
end;


procedure TfrmMain.iA1Click(Sender: TObject);
 var
  bmp : TBitmap;

 begin
  if AnswerSelection<>-1 then begin
    AnswerLabels[AnswerSelection].Font.Style:=[];

    bmp:=TBitmap.Create;
    ilStars.GetBitmap(0, bmp);
    AnswerList[AnswerSelection].Picture.Bitmap.Assign(bmp);
  end;

  AnswerSelection :=(Sender As TImage).Tag;
  AnswerText      :=AnswerLabels[AnswerSelection].Caption;

  AnswerLabels[AnswerSelection].Font.Style:=[fsBold];

  bmp:=TBitmap.Create;
  ilStars.GetBitmap(1, bmp);
  AnswerList[AnswerSelection].Picture.Bitmap.Assign(bmp);

  bNext.Enabled:=True;
end;


procedure TfrmMain.iCustomClick(Sender: TObject);
 begin
  pNewQuiz.Visible := False;
  pCustom.Visible  := True;
end;

procedure TfrmMain.InitialiseQuiz(maxquestionsx : integer);
 var
  t : integer;
  bmp : TBitmap;

 begin
  pNewQuiz.Visible  := False;
  sbNewQuiz.Enabled := False;
  pCustom.Visible   := False;
  pQuiz.Visible     := True;
  CurrentQuestion   := 1;
  MaxQuestions      := maxquestionsx;
  AnswerSelection   := -1;
  TotalScore        := 0;
  lStatus.Visible   := True;

  QuestionsProcessed.Clear;
  QuestionsAnswered.Clear;

  for t:=0 to 4 do begin
    bmp := TBitmap.Create;

    ilStars.GetBitmap(0, bmp);

    AnswerList[t].Picture.Bitmap.Assign(bmp);
    AnswerLabels[t].Font.Style := [];
  end;

  SetQuestion;
end;


procedure TfrmMain.bCloseClick(Sender: TObject);
 begin
  pFinished.Visible := False;

  iAward.Visible    := False;
end;


procedure TfrmMain.bCustomBackClick(Sender: TObject);
 begin
  pCustom.Visible := False;
end;


procedure TfrmMain.bCustomStartClick(Sender: TObject);
 begin
  InitialiseQuiz(tbCustom.Position);
end;


procedure TfrmMain.iHardClick(Sender: TObject);
 begin
  InitialiseQuiz(75);
end;


procedure TfrmMain.iMediumClick(Sender: TObject);
 begin
  InitialiseQuiz(50);
end;


procedure TfrmMain.iQuickClick(Sender: TObject);
 begin
  InitialiseQuiz(25);
end;


procedure TfrmMain.iQuickMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
 var
  bmp : TBitmap;

 begin
  if Selection <> (Sender As TImage).Tag then begin
    bmp := TBitmap.Create;
    ilSelection.GetBitmap(Selection+4, bmp);
    SelectionList[Selection].Picture.Bitmap.Assign(bmp);

    Selection := (Sender As TImage).Tag;

    bmp:=TBitmap.Create;
    ilSelection.GetBitmap(Selection, bmp);
    SelectionList[Selection].Picture.Bitmap.Assign(bmp);
  end;
end;


procedure TfrmMain.lAnswer1Click(Sender: TObject);
 var
  bmp : TBitmap;

 begin
  if AnswerSelection<>-1 then begin
    AnswerLabels[AnswerSelection].Font.Style:=[];

    bmp:=TBitmap.Create;
    ilStars.GetBitmap(0, bmp);
    AnswerList[AnswerSelection].Picture.Bitmap.Assign(bmp);
  end;

  AnswerSelection := (Sender As TLabel).Tag;
  AnswerText      := (Sender As TLabel).Caption;

  AnswerLabels[AnswerSelection].Font.Style:=[fsBold];

  bmp:=TBitmap.Create;
  ilStars.GetBitmap(1, bmp);
  AnswerList[AnswerSelection].Picture.Bitmap.Assign(bmp);

  bNext.Enabled:=True;
end;


procedure TfrmMain.sbNewQuizClick(Sender: TObject);
 begin
  pFinished.Visible :=False;
  pNewQuiz.Visible  :=True;
end;


procedure TfrmMain.bNextClick(Sender: TObject);
 var
  bmp : TBitmap;
  
 begin
  // check for correct answer
  if CorrectAnswer=AnswerSelection then
    inc(TotalScore);

  QuestionsAnswered.Add(IntToStr(lQuestion.Tag)+':'+AnswerText);

  if CurrentQuestion > MaxQuestions then begin
    pQuiz.Visible     :=False;
    pFinished.Visible :=True;
    lStatus.Visible   :=False;
    sbNewQuiz.Enabled :=True;

    lCorrect.Caption   :=IntToStr(TotalScore);
    lIncorrect.Caption :=IntToStr(MaxQuestions-TotalScore);

    lScore.Left   :=Width-lScore.Canvas.TextWidth(IntToStr(Round((TotalScore/MaxQuestions)*100))+'%')-5;

    lScore.Caption:=IntToStr(Round((TotalScore/MaxQuestions)*100))+'%';

    case Round((TotalScore/MaxQuestions)*100) of
       80..90 : begin
                   bmp:=TBitmap.Create;
                   ilAwards.GetBitmap(0, bmp);
                   iAward.Picture.Bitmap.Assign(bmp);
                   iAward.Visible:=True;
                end;
      91..100 : begin
                   bmp:=TBitmap.Create;
                   ilAwards.GetBitmap(1, bmp);
                   iAward.Picture.Bitmap.Assign(bmp);
                   iAward.Visible:=True;
                end;
    end;
  end
  else
    SetQuestion;
end;


procedure TfrmMain.bShowResultsClick(Sender: TObject);
 begin
  ProduceUserQuestionKey;
end;


procedure TfrmMain.SpeedButton2Click(Sender: TObject);
 begin
  frmAbout.ShowModal;
end;


procedure TfrmMain.SpeedButton3Click(Sender: TObject);
 begin
  CheckForNewVersion(PTQ_Version, PTQ_Date, 'ptq.dat');
end;


procedure TfrmMain.tbCustomChange(Sender: TObject);
 begin
  lCustomCount.Caption := IntToStr(tbCustom.Position);
end;


procedure TfrmMain.LoadQuestions;
 var
  tf : TextFile;
  s,x : string;
  i,q : integer;
  qo : TQuestionObject;

 begin
  if FileExists(RunFrom+'data\ptquiz\system\questions.dat') then begin
    AssignFile(tf, RunFrom+'data\ptquiz\system\questions.dat');
    Reset(tf);

    while not(eof(tf)) do begin
      Readln(tf, s);

      if s<>'' then begin
        qo:=TQuestionObject.Create;
        qo.Image       :='';
        qo.AnswerCount :=5;
        q:=1;
        x:='';

        for i:=1 to length(s) do begin
          if s[i]='#' then
            x:=''
          else if s[i]='~' then begin
            qo.xType:=StrToInt(x);

            x:='';
          end
          else if s[i]='^' then begin
            qo.Image:=x;

            x:='';
          end
          else if s[i]='$' then begin
            qo.Question:=TrimLeft(x);

            x:='';
          end
          else if s[i]='*' then begin
            x:=StringReplace(x, '?d?', #176, [rfReplaceAll]);

            qo.Answers[q]:=x;

            if (x='') and (qo.AnswerCount=5) then
              qo.AnswerCount:=q-1;

            x:='';

            inc(q);
          end
          else
            x:=x+s[i];
        end;

        Questions.Add(qo)
      end;
    end;
  end;
end;


procedure TfrmMain.SetQuestion;
 var
  i,t,z : integer;
  qo : TQuestionObject;
  bmp : TBitmap;

 begin
  bNext.Enabled:=False;

  Randomize;

  i:=Random(Questions.Count);
  while (QuestionsProcessed.IndexOf(IntToStr(i))<>-1) and ((Questions.Items[i] As TQuestionObject).xType<=QuestionDifficulty) do begin
    i:=Random(Questions.Count);
  end;

  qo:=(Questions.Items[i] As TQuestionObject);

  QuestionsProcessed.Add(IntToStr(i));

  lQuestion.Caption :=qo.Question;
  lQuestion.Tag     :=i;

  for t:=0 to 4 do begin
    AnswerLabels[t].Caption :='';
  end;

  for t:=1 to qo.AnswerCount do begin
    z:=Random(qo.AnswerCount);
    while AnswerLabels[z].Caption<>'' do begin
      z:=Random(qo.AnswerCount);
    end;

    AnswerLabels[z].Caption:=qo.Answers[t];

    if t=1 then
      CorrectAnswer:=z;
  end;

  if qo.AnswerCount<>5 then begin
     for t:=qo.AnswerCount to 4 do begin
       AnswerLabels[t].Visible :=False;
       AnswerList[t].Visible   :=False;
     end;
  end
  else begin
    for t:=0 to 4 do begin
      if Not(AnswerLabels[t].Visible) then begin
        AnswerLabels[t].Visible :=True;
        AnswerList[t].Visible   :=True;
      end;
    end;
  end;

  lStatus.Caption:='Question '+IntToStr(CurrentQuestion)+' of '+IntToStr(MaxQuestions);
  inc(CurrentQuestion);

  if qo.Image='' then
    iQuestion.Visible:=False
  else begin
    iQuestion.Picture.LoadFromFile(RunFrom+'data\ptquiz\images\'+qo.Image+'.jpg');

    if iQuestion.Picture.Width=281 then
      iQuestion.Left:=8
    else
      iQuestion.Left:=8+(281-iQuestion.Picture.Width);    

    iQuestion.Visible:=True;
  end;

  // ==========================================================================

  if AnswerSelection<>-1 then begin
    AnswerLabels[AnswerSelection].Font.Style:=[];

    bmp := TBitmap.Create;
    ilStars.GetBitmap(0, bmp);
    AnswerList[AnswerSelection].Picture.Bitmap.Assign(bmp);
  end;

  AnswerSelection := -1;
end;


procedure TfrmMain.ProduceUserQuestionKey;
 var
  tf : TextFile;
  t,i,qx : integer;

 begin
  AssignFile(tf, RunFrom + 'data\ptquiz\temp\ptquiz.txt');
  Rewrite(tf);

  for t := 0 to  QuestionsAnswered.Count-1 do begin
    i := Pos(':', QuestionsAnswered.Strings[t]);

    qx := StrToInt(Copy(QuestionsAnswered.Strings[t], 1, i - 1));

    Writeln(tf, (Questions.Items[qx] As TQuestionObject).Question);
    Writeln(tf, '     Your Answer: ' + Copy(QuestionsAnswered.Strings[t], i + 1, length(QuestionsAnswered.Strings[t]) - i));
    Writeln(tf, '  Correct Answer: ' + (Questions.Items[qx] As TQuestionObject).Answers[1]);
    Writeln(tf, '');

  end;

  CloseFile(tf);
  //
  ExecuteFile(0, RunFrom+'data\ptquiz\temp\ptquiz.txt', '', '', SW_SHOW);
end;


procedure TfrmMain.rbEasyClick(Sender: TObject);
 begin
  QuestionDifficulty := (Sender As TRadioButton).Tag;
end;


end.

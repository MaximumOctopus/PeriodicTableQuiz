unit uTestSqlite;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,SQLiteTable3, ExtCtrls, jpeg;

type
  TForm1 = class(TForm)
    btnTest: TButton;
    btnLoadImage: TButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    eCustomFormulaX: TEdit;
    lCompoundText: TLabel;
    Button4: TButton;
    Button5: TButton;
    procedure btnTestClick(Sender: TObject);
    procedure btnLoadImageClick(Sender: TObject);
    function Score(s : string; sx : integer): integer;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    function  ConvertFormula(formula : string): string;
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

const

  letterscores : array[1..2, 1..26] of integer = ((1,3,3,2,1,4,2,4,1,8,5,1,3,1,1,3,10,1,1,1,1,4,4,8,4,10), // scrabble
                                                  (1,2,1,1,1,3,1,2,1,5,3,1,1,1,1,2,5,1,1,1,1,4,4,5,3,5)); // literati


procedure TForm1.btnTestClick(Sender: TObject);
var
slDBpath: string;
sldb: TSQLiteDatabase;
sSQL: String;
s: String;
tf : textfile;

 begin
  slDBPath := ExtractFilepath(application.exename)+ 'test.db';

  sldb := TSQLiteDatabase.Create(slDBPath);
  try

    sSQL := 'CREATE TABLE swData ([swWord] VARCHAR (16) PRIMARY KEY);';
    sldb.execsql(sSQL);

  //sldb.execsql('CREATE INDEX TestTableName ON [testtable]([Name]);');

    AssignFile(tf, 'squarewordz.dat');
    Reset(tf);

    sldb.BeginTransaction;

    while not(eof(tf)) do begin
      readln(tf, s);

      sSQL := 'INSERT INTO swData (swWord) VALUES ('''+s+''');';
      sldb.ExecSQL(sSQL);
    end;

    //end the transaction
    sldb.Commit;

    CloseFile(tf);

  finally
    sldb.Free;
  end;
end;

function TForm1.Score(s : string; sx : integer): integer;
 var
  t : integer;

 begin
  Result:=0;

  if sx=3 then begin
    case length(s) of
      1,2   : Result:=0;
      3,4   : Result:=1;
      5     : Result:=2;
      6     : Result:=3;
      7     : Result:=5;
      8..99 : Result:=11;
    end;
  end
  else begin
    for t:=1 to length(s) do
      Result:=result+letterscores[sx][ord(s[t])-64];
  end;
end;

procedure TForm1.btnLoadImageClick(Sender: TObject);
var
slDBpath: string;
sldb: TSQLiteDatabase;
sSQL: String;
s: String;
tf : textfile;

 begin
  slDBPath := ExtractFilepath(application.exename)+ 'mw.db';

  sldb := TSQLiteDatabase.Create(slDBPath);
  try

    sSQL := 'CREATE TABLE mwData ([mwWord] VARCHAR (16) PRIMARY KEY, [b] INT, [l] INT, [s] INT);';
    sldb.execsql(sSQL);

  //sldb.execsql('CREATE INDEX TestTableName ON [testtable]([Name]);');

    AssignFile(tf, 'sowpods.dat');
    Reset(tf);

    sldb.BeginTransaction;

    while not(eof(tf)) do begin
      readln(tf, s);

      sSQL := 'INSERT INTO mwData (mwWord, b, l, s) VALUES ('''+s+''', '+IntToStr(Score(s, 3))+', '+IntToStr(Score(s, 2))+', '+IntToStr(Score(s, 1))+');';
      sldb.ExecSQL(sSQL);
    end;

    //end the transaction
    sldb.Commit;

    CloseFile(tf);

  finally
    sldb.Free;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
slDBpath: string;
sldb: TSQLiteDatabase;
sSQL: String;
s: String;
tf : textfile;
fx, xword, xlink, xtitle : string;
i,t : integer;

 begin
  slDBPath := ExtractFilepath(application.exename)+ 'pteIndex.db';

  sldb := TSQLiteDatabase.Create(slDBPath);
  try

    sSQL := 'CREATE TABLE pteIndex ([pteWord] VARCHAR, [pteLink] VARCHAR, [pteTitle] VARCHAR);';
    sldb.execsql(sSQL);

    sldb.execsql('CREATE INDEX wordIndex ON [pteIndex]([pteWord]);');

    AssignFile(tf, 'iphoneindex.dat');
    Reset(tf);

    sldb.BeginTransaction;

    while not(eof(tf)) do begin
      readln(tf, s);

      xword:='';
      xlink:='';
      xtitle:='';

      fx:='';
      i:=0;
      for t:=1 to length(s) do begin
        if s[t]='_' then begin
          case i of
            0 : xword:=fx;
            1 : xlink:=fx;
            2 : xtitle:=fx;
          end;

          fx:='';
          inc(i);
        end
        else
          fx:=fx+s[t];
      end;

      xtitle:=fx;

      if xtitle<>'' then
        sSQL := 'INSERT INTO pteIndex (pteWord, pteLink, pteTitle) VALUES ('''+xword+''', '''+xlink+''', '''+xtitle+''');'
      else
        showmessage(xword+' '+xlink);
        
      sldb.ExecSQL(sSQL);
    end;

    //end the transaction
    sldb.Commit;

    CloseFile(tf);

  finally
    sldb.Free;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
slDBpath: string;
sldb: TSQLiteDatabase;
sSQL: String;
s: String;
tf : textfile;
fx, a, b, c, d, e : string;
i,t : integer;

 begin
  slDBPath := ExtractFilepath(application.exename)+ 'pteConstants.db';

  sldb := TSQLiteDatabase.Create(slDBPath);
  try

    sSQL := 'CREATE TABLE pteContants ([pteName] VARCHAR PRIMARY KEY, [pteSymbol] VARCHAR, [pteValue] VARCHAR, [pteUnits] VARCHAR, [pteUncer] VARCHAR);';
    sldb.execsql(sSQL);

    AssignFile(tf, 'constants.dat');
    Reset(tf);

    sldb.BeginTransaction;

    while not(eof(tf)) do begin
      readln(tf, s);

      if length(s)>10 then begin
        a:='';
        b:='';
        c:='';
        d:='';
        e:='';

        fx:='';
        i:=0;
        for t:=1 to length(s) do begin
          if s[t]='_' then begin
            case i of
              0 : a:=fx;
              1 : b:=fx;
              2 : begin
                    fx:=StringReplace(fx, '{', '<sup>', [rfReplaceAll]);
                    fx:=StringReplace(fx, '}', '</sup>', [rfReplaceAll]);

                    c:=fx;
                  end;
              3 : begin
                    fx:=StringReplace(fx, '{', '<sup>', [rfReplaceAll]);
                    fx:=StringReplace(fx, '}', '</sup>', [rfReplaceAll]);

                    d:=fx;
                  end;
              4 : begin
                    fx:=StringReplace(fx, '{', '<sup>', [rfReplaceAll]);
                    fx:=StringReplace(fx, '}', '</sup>', [rfReplaceAll]);

                    e:=fx;
                  end;
            end;

            fx:='';
            inc(i);
          end
          else
            fx:=fx+s[t];
        end;

        fx:=StringReplace(fx, '{', '<sup>', [rfReplaceAll]);
        fx:=StringReplace(fx, '}', '</sup>', [rfReplaceAll]);
        e:=fx;

        sSQL := 'INSERT INTO pteContants (pteName, pteSymbol, pteValue, pteUnits, pteUncer) VALUES ('''+a+''', '''+b+''', '''+c+''', '''+d+''', '''+e+''');';
        sldb.ExecSQL(sSQL);
      end;
    end;

    //end the transaction
    sldb.Commit;

    CloseFile(tf);

  finally
    sldb.Free;
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
slDBpath: string;
sldb: TSQLiteDatabase;
sSQL: String;
s: String;
tf : textfile;
a, b, c : string;
o : array[1..6] of string;
i,t : integer;

 begin
  slDBPath := ExtractFilepath(application.exename)+ 'pteCompounds.db';

  sldb := TSQLiteDatabase.Create(slDBPath);
  try

    sSQL := 'CREATE TABLE pteCompound ([pteName] VARCHAR, [pteFormulaF] VARCHAR, [pteFormula] VARCHAR, [pteCAS] VARCHAR, [pteOther1] VARCHAR, [pteOther2] VARCHAR, [pteOther3] VARCHAR, [pteOther4] VARCHAR, [pteOther5] VARCHAR, [pteOther6] VARCHAR);';
    sldb.execsql(sSQL);

    AssignFile(tf, 'formulaetext.txt');
    Reset(tf);

    sldb.BeginTransaction;

    while not(eof(tf)) do begin
      readln(tf, s);

      if s<>'' then begin
      if s[1]='{' then begin
        a:='';
        b:='';
        c:='';
        for t:=1 to 6 do
          o[t]:='';

        i:=1;
      end
      else begin
        if s[1]='}' then begin
          sSQL := 'INSERT INTO pteCompound (pteName, pteFormulaF, pteFormula, pteCAS, pteOther1, pteOther2, pteOther3, pteOther4, pteOther5, pteOther6) VALUES ('''+a+''', '''+ConvertFormula(b)+''', '''+b+''', '''+c+''', '''+o[1]+''', '''+o[2]+''', '''+o[3]+''', '''+o[4]+''', '''+o[5]+''', '''+o[6]+''');';
          sldb.ExecSQL(sSQL);
        end;

        if s[1]='$' then a:=Copy(s, 2, length(s)-1);
        if s[1]='%' then b:=Copy(s, 2, length(s)-1);
        if s[1]='&' then c:=Copy(s, 2, length(s)-1);
        if s[1]='!' then begin
          if i<=6 then begin
            o[i]:=Copy(s, 2, length(s)-1);
            inc(i);
          end;
        end;
      end;
      end;
    end;

    //end the transaction
    sldb.Commit;

    CloseFile(tf);

  finally
    sldb.Free;
  end;
end;

function TForm1.ConvertFormula(formula : string): string;
var
  xpos,ypos,t : integer;
  supermode : boolean;
  submode   : boolean;
  fs : string;

 begin
  if formula<>'' then begin

    xpos:=10;
    ypos:=11;
    supermode:=False;
    submode:=False;
    fs:='';

    for t:=1 to length(formula) do begin
      if (Ord(formula[t])>=48) and (Ord(formula[t])<=57) then begin// check for subscripts
        if supermode then begin
            fs:=fs+formula[t]
        end
        else begin
          if (t=1) or (formula[t-1]='.') then begin
            if submode then begin
              fs:=fs+'</sub>';

              submode:=False;
            end;

            fs:=fs+formula[t]
          end
          else begin
            if submode then
              fs:=fs+formula[t]
            else
              fs:=fs+'<sub>'+formula[t];

            submode:=True;
          end;
        end;
      end
      else if (formula[t]='^') then begin// check for superscripts
        supermode:=True;

        if submode then begin
          submode:=False;

          fs:=fs+'</sub>';
        end;

        fs:=fs+'<sup>';
      end
      else begin
        if submode then begin
          fs:=fs+'</sub>';
          submode:=False;
        end;

        fs:=fs+formula[t];
      end;
    end;
  end;

  if supermode then
    fs:=fs+'</sup>';

  if submode then
    fs:=fs+'</sub>';

  Result:=fs;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
slDBpath: string;
sldb: TSQLiteDatabase;
sSQL: String;
s: String;
tf : textfile;
a, b, c : string;
o : array[1..6] of string;
i,t : integer;

 begin
  slDBPath := ExtractFilepath(application.exename)+ 'pteEquations.db';

  sldb := TSQLiteDatabase.Create(slDBPath);
  try

    sSQL := 'CREATE TABLE pteEquation ([pteName] VARCHAR, [pteTitle] VARCHAR);';
    sldb.execsql(sSQL);

    AssignFile(tf, 'equationtext.txt');
    Reset(tf);

    sldb.BeginTransaction;

    while not(eof(tf)) do begin
      readln(tf, s);

      if s<>'' then begin

        i:=Pos('/', s);

        if i<>-1 then begin
          a:=Copy(s, 1, i-1);

          b:=Copy(s, i+1, length(s)-i);

          showmessage(s+'  ::  '+a+'  ::  '+b);

          b:=StringReplace(b, '''', '''''', [rfReplaceAll]);

           sSQL := 'INSERT INTO pteEquation (pteName, pteTitle) VALUES ('''+a+''', '''+b+''');';
           sldb.ExecSQL(sSQL);
        end;
      end;
    end;

    //end the transaction
    sldb.Commit;

    CloseFile(tf);

  finally
    sldb.Free;
  end;
end;

procedure TForm1.Button5Click(Sender: TObject);
 var
  slDBpath: string;
  sldb: TSQLiteDatabase;
  sSQL: String;
  s: String;
  tf : textfile;
  qt, qq, qi, a1, a2, a3, a4, a5 : string;
  i,t,id : integer;

 begin
  slDBPath := ExtractFilepath(application.exename)+ 'ptQuiz.db';

  sldb := TSQLiteDatabase.Create(slDBPath);
  try

    sSQL := 'CREATE TABLE ptQuiz ([ptID] INT PRIMARY KEY, [ptType] VARCHAR, [ptQuestion] VARCHAR, [ptImage] VARCHAR, [ptAnswer1] VARCHAR, [ptAnswer2] VARCHAR, [ptAnswer3] VARCHAR, [ptAnswer4] VARCHAR, [ptAnswer5] VARCHAR);';
    sldb.execsql(sSQL);

    AssignFile(tf, 'questions4sql.txt');
    Reset(tf);

    sldb.BeginTransaction;

    id:=0;

    while not(eof(tf)) do begin
      readln(tf, s);

      if s<>'' then begin
        if s='{' then begin
          qt :='';
          qq :='';
          qi :='';
          a1 :='';
          a2 :='';
          a3 :='';
          a4 :='';
          a5 :='';

          i:=0;
        end;

        if s[1]='+' then begin
          if length(s)=1 then
            s:=''
          else
            s:=copy(s, 2, length(s)-1);

          case i of
            0 : qt:=s;
            1 : qq:=StringReplace(s, '''', '''''', [rfReplaceAll]);
            2 : qi:=s;
            3 : a1:=StringReplace(s, '''', '''''', [rfReplaceAll]);
            4 : a2:=StringReplace(s, '''', '''''', [rfReplaceAll]);
            5 : a3:=StringReplace(s, '''', '''''', [rfReplaceAll]);
            6 : a4:=StringReplace(s, '''', '''''', [rfReplaceAll]);
            7 : a5:=StringReplace(s, '''', '''''', [rfReplaceAll]);
          end;

          inc(i);
        end;

        if s='}' then begin

          sSQL := 'INSERT INTO ptQuiz (ptID, ptType, ptQuestion, ptImage, ptAnswer1, ptAnswer2, ptAnswer3, ptAnswer4, ptAnswer5) VALUES ('+IntToStr(id)+', '''+qt+''', '''+qq+''', '''+qi+''', '''+a1+''', '''+a2+''', '''+a3+''', '''+a4+''', '''+a5+''')';

          sldb.ExecSQL(sSQL);

          inc(id);
        end;
      end;
    end;

    //end the transaction
    sldb.Commit;

    CloseFile(tf);

  finally
    sldb.Free;
  end;
end;

end.

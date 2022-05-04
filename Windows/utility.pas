{
  (c) Paul Alan Freshney 2016

  PLEASE DO NOT REDISTRIBUTE!

  www.MaximumOctopus.com
  www.PeriodicTableExplorer.com
  www.freshney.org

  freeware@freshney.org
}

unit utility;

interface

uses shellAPI, sysutils, Contnrs;

type
  TQuestionObject = class(TObject)
  private
  public
    Question     : string;
    Image        : string;
    xType        : integer; //(1 = easy, 2 = hard)
    Answers      : array[1..5] of string;
    AnswerCount  : integer;
  end;

var
 RunFrom : string;
 Questions : TObjectList;

const
 PTQ_Version : string = '1.2';
 PTQ_Date    : string = 'November 18th 2016';

function ExecuteFile(bob : THandle; const FileName, Params, DefaultDir: string; ShowCmd: Integer): THandle;

implementation


function ExecuteFile(bob : THandle; const FileName, Params, DefaultDir: string; ShowCmd: Integer): THandle;
 var
  zFileName, zParams, zDir: array[0..254] of Char;

 begin
  Result := ShellExecute(bob, nil, StrPCopy(zFileName, FileName), StrPCopy(zParams, Params), StrPCopy(zDir, DefaultDir), ShowCmd);
end;


end.

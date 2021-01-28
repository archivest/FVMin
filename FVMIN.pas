uses
  Objects,
  Drivers,
  Views,
  Menus,
  App,
  Gadgets, { PClockView }
  MsgBox;  { ShowAboutBox }

const
  cmAbout = 1001;

type
  PFV = ^TFV;

  TFV = object(TApplication)
    Clock: PClockView;
    constructor Init;
    procedure Idle; virtual;
    procedure HandleEvent(var Event: TEvent); virtual;
    procedure InitMenuBar; virtual;
    procedure InitDesktop; virtual;
    procedure InitStatusLine; virtual;
    procedure ShowAboutBox;
  end;

constructor TFV.Init;
var
  R: TRect;
begin
  inherited Init;

  GetExtent(R);
  R.A.X := R.B.X -9;
  R.B.X := R.A.Y + 1;
  Clock := New(PClockView, Init(R));
  Insert(Clock);
end;

procedure TFV.Idle;
begin
  inherited Idle;

  Clock^.Update;
end;

procedure TFV.InitDesktop;
var
  R: TRect;
begin
  GetExtent(r);
  Inc(R.A.Y);
  Dec(R.B.Y);
  Desktop:= New(PDesktop, Init(R));
end;

procedure TFV.InitMenuBar;
var
  R: TRect;
begin
  GetExtent(R);
  R.B.Y := R.A.Y +1;
  MenuBar := New(PMenuBar, Init(R, NewMenu(
               NewSubMenu('~D~emo', 0, NewMenu(
                 NewItem('~A~bout','F1',kbF1, cmAbout, hcNoContext,
                 NewItem('Exit','',kbNoKey, cmQuit, hcNoContext,
                nil))),
              nil))));
end;

procedure TFV.InitStatusLine;
var
  R: TRect;
begin
  GetExtent(R);
  R.A.Y := R.B.Y - 1;
  New(StatusLine, Init(R,
    NewStatusDef(0, $EFFF,
      NewStatusKey('~F1~ About', kbF1, cmAbout,
      StdStatusKeys(nil)),
    nil)));
end;

procedure TFV.HandleEvent(var Event: TEvent);
begin
  inherited HandleEvent(Event);
  if (Event.What = evCommand) then
  begin
    case Event.Command of
      cmAbout: ShowAboutBox;
    else
      Exit;
    end;
  end;
  ClearEvent(Event);
end;

procedure TFV.ShowAboutBox;
begin
  MessageBox(#3'Minimal FV Demo'#13+
             #3'(www.freepascal.org)'#13,
             nil, mfInformation or mfOKButton);
end;

var
  FV: TFV;
begin
  FV.Init;
  FV.Run;
  FV.Done;
end.
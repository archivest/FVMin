# FVMin
A minimal Free Vision TUI program.

![Screenshot 2021-01-28 175757.gif](Screenshot%202021-01-28%20175757.gif)

![Screenshot 2021-01-28 175819.gif](Screenshot%202021-01-28%20175819.gif)

## Uses

```
uses
  Objects,
  Drivers,
  Views,
  Menus,
  App,
  Gadgets, { PClockView }
  MsgBox;  { ShowAboutBox }
```

`Gadgets` can be removed if clock is not needed.

`MsgBox` can be removed if About dialog box is not needed.

## Const

```
const
  cmAbout = 1001;
```

## Type

```
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
```

## Init

```
constructor TFV.Init;
var
  R: TRect;
begin
  inherited Init;

  GetExtent(R);
  R.A.X := R.B.X -9;
  R.B.Y := R.A.Y + 1;
  Clock := New(PClockView, Init(R));
  Insert(Clock);
end;
```

## Idle

```
procedure TFV.Idle;
begin
  inherited Idle;

  Clock^.Update;
end;
```

## InitDesktop

```
procedure TFV.InitDesktop;
var
  R: TRect;
begin
  GetExtent(R);
  Inc(R.A.Y);
  Dec(R.B.Y);
  Desktop:= New(PDesktop, Init(R));
end;
```

## InitMenuBar

```
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
```

## InitStatusLine

```
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
```

## HandleEvent

```
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
```

## ShowAboutBox

```
procedure TFV.ShowAboutBox;
begin
  MessageBox(#3'Minimal FV Demo'#13+
             #3'(www.freepascal.org)'#13,
             nil, mfInformation or mfOKButton);
end;
```

## Main 

```
var
  FV: TFV;
begin
  FV.Init;
  FV.Run;
  FV.Done;
end.
```


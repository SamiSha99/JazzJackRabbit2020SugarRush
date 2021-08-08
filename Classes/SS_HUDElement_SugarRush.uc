/**
*
* Copyright 2012-2015 Gears for Breakfast ApS. All Rights Reserved.
*/

class SS_HUDElement_SugarRush extends Hat_HUDElement;

struct JazzLettersData
{
    var Color Tint;
    var string Text;
    var bool reverse;
    var float offset;
    structdefaultproperties
    {
        Text = "";
        reverse = false;
        offset = 0;
    }
};

var Array<JazzLettersData> LettersList;
var Vector2D Position;
var float Duration, EndDuration;
const BlinkRate = 12;
const Offset = 0.017f;

function DrawLetter(HUD H, coerce string letter, Color tint, float posx, float posy)
{
    H.Canvas.SetDrawColor(tint.R, tint.G, tint.B, 255);
    H.Canvas.Font = class'Hat_FontInfo'.static.GetDefaultFont(letter);
    DrawBorderedText(H.Canvas, letter, PosX, PosY, H.Canvas.ClipX * 0.0005f, true, TextAlign_Center);
}

function OnOpenHUD(HUD H, optional String command)
{
    Super.OnOpenHUD(H, command);
    GetDuration(H);
}

function GetDuration(HUD H)
{
    local SS_StatusEffect_SugarRush se;
    se = SS_StatusEffect_SugarRush(Hat_Player(H.PlayerOwner.Pawn).GetStatusEffect(class'SS_StatusEffect_SugarRush', true)); 
    Duration = se != None ? se.Duration : 0.0f;
    EndDuration = GetWorldInfo().TimeSeconds + Duration;
}

function bool Tick(HUD H, float d)
{
    local WorldInfo wi;

	if (!Super.Tick(H, d)) return false;

	wi = GetWorldInfo();
    if(Duration >= 0)
    {
    	Duration = FMax(EndDuration - wi.TimeSeconds, 0);
        if (Duration <= 0 || wi.TimeSeconds >= EndDuration)
            CloseHUD(H, Class, true);
    }
	return true;
}

function bool Render(HUD H)
{
    local float posx, posy, digits;
    local int i, offsetAmount, textAmount, DurationInt;

    if(!super.Render(H) || Duration <= 2 && Sin(BlinkRate * Pi * Duration) <= 0) return false; // Blink warning of running out.

    DurationInt = Int(Duration);

    for(i = 0; i < LettersList.Length; i++)
        if(LettersList[i].Text != "digit")
            offsetAmount++;

    digits = GetDigitsAmount(DurationInt);
    textAmount = offsetAmount + digits;
    posx =  H.Canvas.ClipX * (Position.X - (Offset * textAmount) / 2);
    posy =  H.Canvas.ClipY * Position.Y;

    for(i = 0; i < textAmount; i++)
    {
        if(LettersList[i].Text != " ")
        {
            if(LettersList[i].Text ~= "digit")
                switch(digits)
                {
                    case 1:
                        DrawLetter(H, DurationInt, LettersList[i].Tint, GetRotationPartSin(posx, LettersList[i].offset, LettersList[i].reverse), GetRotationPartCos(posy, LettersList[i].offset));
                    break;

                    case 2:
                        DrawLetter(H, DurationInt / 10, LettersList[i].Tint, GetRotationPartSin(posx, LettersList[i].offset, LettersList[i].reverse), GetRotationPartCos(posy, LettersList[i].offset));
                        posx += AddOffset(H);
                        i++;
                        DrawLetter(H, DurationInt % 10, LettersList[i].Tint, GetRotationPartSin(posx, LettersList[i].offset, LettersList[i].reverse), GetRotationPartCos(posy, LettersList[i].offset));
                    break;
                }
            else
            {
                DrawLetter(H, LettersList[i].Text, LettersList[i].Tint, GetRotationPartSin(posx, LettersList[i].offset, LettersList[i].reverse), GetRotationPartCos(posy, LettersList[i].offset));
            }
        }
        posx += AddOffset(H);
    }
    return true;
}

function float GetRotationPartSin(float posx, optional float offsetstart, optional bool reverse = false)
{
    return posx + 7.5f * Sin(4 * GetWorldInfo().TimeSeconds + offsetstart * Pi) * (reverse ? -1.0f : 1.0f);
}

function float GetRotationPartCos(float posy, optional float offsetstart)
{
    return posy + 7.5f * Cos(4 * GetWorldInfo().TimeSeconds + offsetstart * Pi);
}

function float AddOffset(HUD H)
{
    return H.Canvas.ClipX * Offset;
}

function int GetDigitsAmount(int Value)
{
	if (Value < 10) return 1;
	if (Value < 100) return 2;
	if (Value < 1000) return 3;
	if (Value < 10000) return 4;
	return 5;
}

defaultproperties
{
    HideIfPaused = true;
    Duration = 20;
    EndDuration = 999999999; // alternative of Math.Infinity from unity, ew.
    Position = (X=0.5, Y=0.05);
    RealTime = true;
    
	LettersList(0) = (Tint=(R=212,G=225,B=253), Text = "S", reverse = false, offset = 0)
    LettersList(1) = (Tint=(R=0,G=226,B=173), Text = "U", reverse = true, offset = 0)
    LettersList(2) = (Tint=(R=199,G=241,B=2), Text = "G", reverse = false, offset = 0.75)
    LettersList(3) = (Tint=(R=255,G=26,B=1), Text = "A", reverse = false, offset = -0.75)
    LettersList(4) = (Tint=(R=56,G=156,B=239), Text = "R", reverse = true, offset = 0.25)
    LettersList(5) = (Tint=(R=255,G=255,B=255), Text = " ")
    LettersList(6) = (Tint=(R=255,G=221,B=22), Text = "R", reverse = false, offset = 1.5)
    LettersList(7) = (Tint=(R=255,G=108,B=154), Text = "U", reverse = true, offset = -1)
    LettersList(8) = (Tint=(R=250,G=241,B=205), Text = "S", reverse = false, offset = -1.5)
    LettersList(9) = (Tint=(R=183,G=199,B=224), Text = "H", reverse = true, offset = 1.75)
    LettersList(10) = (Tint=(R=255,G=255,B=255), Text = " ")
    LettersList(11) = (Tint=(R=0,G=221,B=162), Text = "digit", reverse = false, offset = 1.25)
    LettersList(12) = (Tint=(R=158,G=212,B=0), Text = "digit", reverse = false, offset = 1.666)
}
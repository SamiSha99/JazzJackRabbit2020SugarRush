class SS_GameMod_SugarRush extends GameMod;

var int CandyCollected, SugarRushRequirement;

var Class<Hat_Collectible> CandyClass, PonClass;
var Class<Hat_StatusEffect> CandySE;

const Default_Enabled = true;
const Default_Duration = 20.0;
const Default_Candy_Chance = 50;
const Default_Candy_Amount = 10;

var config int SugarRushEnabled; // Secondary enable, disabling this remove all candies and replace em back with an energy bit.
var config int SRDuration; // Duration
var config int CandyFrequency; // Chance to replace candy in the map
var config int CandyAmount; // How many candies we need so we can go into sugar rush.

event OnModLoaded()
{
    HookActorSpawn(class'Hat_Player', 'Hat_Player');
}

event OnModUnloaded()
{
    //GiveItems(false);
	
    Hat_HUD(Hat_PlayerController(GetALocalPlayerController()).myHUD).CloseHUD(class'SS_HUDElement_SugarRush');
}

function OnPostInitGame()
{
    
    if(!ShouldReplacePonsWithCandies()) return;
    ReplacePonsWithCandies();
}

event OnHookedActorSpawn(Object NewActor, Name Identifier)
{

}

function OnCollectedCollectible(Object InCollectible)
{
    local Hat_Player plyr;

	if (SS_Collectible_Candy(InCollectible) == None) return;
    
    CandyCollected++;
    
    if(CandyCollected < GetCandyAmount()) return;

    CandyCollected = 0;

    foreach DynamicActors(class'Hat_Player', plyr)
    {
        if(plyr == None) continue;
        plyr.GiveStatusEffect(CandySE);
    }
}

function ReplacePonsWithCandies()
{
    local Hat_Collectible_EnergyBit pon;
    local array<Hat_Collectible_EnergyBit> ponList;
    local Vector v;
    local Rotator r;
    local int SpawnAmount, EnergyBitsOnMap, PonsLeft, i;

    foreach AllActors(class'Hat_Collectible_EnergyBit', pon)
    {
        if(!pon.Enabled) continue;
        EnergyBitsOnMap++;
        ponList.AddItem(pon);
    }
    
    PonsLeft = EnergyBitsOnMap;

    while (ponList.Length != 0)
    {
        if (SpawnAmount >= GetCandyChance() / 100 * EnergyBitsOnMap && SpawnAmount >= GetCandyAmount() * 1.25f) break;
        i = Rand(PonsLeft);
        pon = ponList[i];
        ponList.Remove(i,1);
        PonsLeft--;
        v = pon.Location;
        r = pon.Rotation;
        Spawn(CandyClass,,,v,r);
        pon.Destroy();
        SpawnAmount++;
    }
}

function RestorePons()
{
    local SS_Collectible_Candy candy;
    local Vector v;
    local Rotator r;
    foreach AllActors(class'SS_Collectible_Candy', candy)
    {
        v = candy.Location;
        r = candy.Rotation;
        Spawn(PonClass,,,v,r);
        candy.Destroy();
    }
}

// BEGIN CONFIG FUNCTIONS

event OnConfigChanged(Name ConfigName)
{
    switch(ConfigName)
    {
        Case 'SugarRushEnabled':
            if(ShouldReplacePonsWithCandies())
                ReplacePonsWithCandies();
            else
                RestorePons();
        break;
    }
}

static function bool ShouldReplacePonsWithCandies()
{
	return class'SS_GameMod_SugarRush'.default.SugarRushEnabled == 0;
}

static function float GetCandyDuration()
{
	if (class'SS_GameMod_SugarRush'.default.SRDuration == 0)
		return Default_Duration;
	return class'SS_GameMod_SugarRush'.default.SRDuration;
}

static function float GetCandyChance()
{
	if (class'SS_GameMod_SugarRush'.default.CandyFrequency == 0)
		return Default_Candy_Chance;
    //else if (class'SS_GameMod_SugarRush'.default.CandyFrequency == 99)
		//return 100;
	return class'SS_GameMod_SugarRush'.default.CandyFrequency;
}

static function float GetCandyAmount()
{
	if (class'SS_GameMod_SugarRush'.default.CandyAmount == 0)
		return Default_Candy_Amount;
    else if (class'SS_GameMod_SugarRush'.default.CandyAmount == 99)
		return 100;
	return class'SS_GameMod_SugarRush'.default.CandyAmount;
}

static function Print(string s)
{
    class'WorldInfo'.static.GetWorldInfo().Game.Broadcast(class'WorldInfo'.static.GetWorldInfo(), s);
}

defaultproperties
{
    SugarRushRequirement = 10;
    CandyClass = class'SS_Collectible_Candy';
    CandySE = class'SS_StatusEffect_SugarRush';
    PonClass = class'Hat_Collectible_EnergyBit'
}
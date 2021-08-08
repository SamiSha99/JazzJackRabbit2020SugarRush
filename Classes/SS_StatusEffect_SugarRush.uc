class SS_StatusEffect_SugarRush extends Hat_StatusEffect;

var SoundCue SugarRushSound;
var AudioComponent SugarRushAudio;
var ParticleSystemComponent SugarRushParticle;
var Class<Hat_StatusEffect> Trail;
var transient Hat_MusicNodeBlend_Dynamic DynamicMusicNode;
function OnAdded(Actor a)
{
	local Hat_Player plyr;

	Super.OnAdded(a);
	Duration = class'SS_GameMod_SugarRush'.static.GetCandyDuration();
    Hat_HUD(Hat_PlayerController(Hat_PlayeR(a).Controller).myHUD).OpenHUD(class'SS_HUDElement_SugarRush');
	Hat_Player(a).AttachComponent(SugarRushParticle);
	ToggleSugarRushMusic(true);
	plyr = Hat_Player(a);
    if (plyr == None) return;
	
	plyr.ResetMoveSpeed();
	if (!plyr.HasStatusEffect(class'Hat_StatusEffect_RiftCollapse'))
		GiveStatusEffect(plyr, Trail);
}

simulated function OnRemoved(Actor a)
{
	local Hat_Player plyr;

	Hat_HUD(Hat_PlayerController(Hat_PlayeR(a).Controller).myHUD).CloseHUD(class'SS_HUDElement_SugarRush');

	ToggleSugarRushMusic(false);
	
	plyr = Hat_Player(a);
    if (plyr == None) return;
	
	plyr.SetMaterialScalarValue('RainbowOverlay', 0);
	
	plyr.ResetMoveSpeed();
	RemoveStatusEffect(plyr, Trail);
	Super.OnRemoved(a);
}

function bool Update(float d)
{
	local Hat_Pawn p;
	local Hat_Player plyr;
	
    if(Duration <= 0)
        RemoveStatusEffect(Owner, Class, true);
	Duration = FMax(Duration - d, 0);
	plyr = Hat_Player(Owner);

	// Sort status arrays, disallows lower speed from taking priority than this power speed.
	if (plyr.HasStatusEffect(class'Hat_StatusEffect_BadgeSprint', true) || plyr.HasStatusEffect(class'Hat_StatusEffect_BadgeScooter', true))
		plyr.StatusEffects.Sort(Sort_MoveStatusToEnd);

	if (plyr == None) return true;
	
	if (!plyr.IsHomingAttacking())
	{
		foreach plyr.CollidingActors(class'Hat_Pawn', p, 45,, true)
		{
			if (p == Owner) continue;
			if (p.IsA('Hat_Player')) continue;
			if (!p.IsA('Hat_Enemy')) continue;
			if (p.IsA('Hat_Enemy_Boss')) continue;
			if (!p.CanTakeDamage(false, Owner)) continue;
			if(p.bHidden) continue;
			p.TakeDamage(p.Health, Pawn(Owner).Controller, Owner.Location, vect(0,0,0), class'Hat_DamageType_Bump');
			GiveStatusEffect(Owner, class'Hat_StatusEffect_KickCan');
		}
	}
	plyr.SetMaterialScalarValue('RainbowOverlay', 1.4);
	`MusicManager.MusicTreeInstance.VolumeMultiplier = 0; // keep it muted, in case of time stop
	return true;
}

delegate int Sort_MoveStatusToEnd(Hat_StatusEffect A, Hat_StatusEffect B)
{
    if (A.IsA(Class.Name)) return -1; //Swap
    return 0; //Don't Swap
}

function ToggleSugarRushMusic(bool bPlay)
{
	if (bPlay)
	{
		SugarRushAudio = Hat_Player(Owner).CreateAudioComponent(SugarRushSound, true, true,,,true);
		SugarRushAudio.VolumeMultiplier = 0.75f;
		`MusicManager.MusicTreeInstance.VolumeMultiplier = 0;
	}
	else
	{
		`MusicManager.MusicTreeInstance.VolumeMultiplier = 1;
		if(SugarRushAudio != None)
			SugarRushAudio.FadeOut(0.5, 0);
		SugarRushAudio = None;
	}
}

function Print(string s)
{
    GetWorldInfo().Game.Broadcast(class'WorldInfo'.static.GetWorldInfo(), s);
}

function OnPreTakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local bool IsWorldInflicted;
	
	if (Hat_Player(Owner) == None) return;
	
	IsWorldInflicted = (DamageType == None || (InstigatedBy == None && DamageCauser == None)) ? true : DamageType.default.bCausedByWorld;
	if (Damage > 0 && IsWorldInflicted)
		Hat_Player(Owner).BlinkTime += 0.1;
}

function float GetSpeedMultiplier()
{
	return 2.315f;
}

function bool GetJumpHeight(out float JumpHeight)
{
    JumpHeight *= 3.75;    
    return true;
}

function bool CannotTakeDamage(bool world)
{
	return true;
}

defaultproperties
{
    SugarRushSound = SoundCue'JazzJackRabbit2020_Content.SoundCue.SUGAR_RUSH';
    Begin Object Class=ParticleSystemComponent Name=SugarRushParticle0
		Template = None;
		bAutoActivate = true;
	End Object
	SugarRushParticle = SugarRushParticle0;

	Duration = 20;
	Trail = class'SS_StatusEffect_Trial';
	PreventFallDamage = true;
}
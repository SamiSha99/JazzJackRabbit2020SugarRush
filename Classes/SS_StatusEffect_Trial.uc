class SS_StatusEffect_Trial extends Hat_StatusEffect_RiftCollapse;

const TimerInterval2 = 0.0625f; //0.125f;

defaultproperties
{
	OnlyActiveWhileMoving = false
	TrailClass = class'Hat_NPC_Player_RiftCollapse_Trail_Dance'
}

function OnAdded(Actor a)
{
    Super(Hat_StatusEffect).OnAdded(a);
}

simulated function OnRemoved(Actor a)
{
	local int i;
    Super(Hat_StatusEffect).OnRemoved(a);
	
	for (i = 0; i < ArrayCount(TrailActors); i++)
	{
		if (TrailActors[i] != None)
			TrailActors[i].Destroy();
	}
}

function bool Update(float delta)
{
	if (!Super(Hat_StatusEffect).Update(delta)) return false;
	
	TrailCloneTimer -= delta;
	if (TrailCloneTimer < 0)
	{
		TrailCloneTimer = TimerInterval2;
		DropTrailClone();
	}
	
	return true;
}

function DropTrailClone()
{
	if (Owner.WorldInfo.GetDetailMode() < DM_Medium) return;
	if (VSize(Owner.Velocity) <= 30 && OnlyActiveWhileMoving) return;
	if (TrailClass == None) return;
	
	if (TrailActors[TrailActorIndex] == None)
	{
		TrailActors[TrailActorIndex] = Owner.Spawn(TrailClass,Owner,, Owner.Location + vect(0,0,-1)*Pawn(Owner).GetCollisionHeight() + Vector(Owner.Rotation)*0, Owner.Rotation,,true);
		Hat_NPC_Player_RiftCollapse_Trail(TrailActors[TrailActorIndex]).PlayerOwner = PlayerController(Pawn(Owner).Controller);	//Fixes trail on P2!
		Hat_NPC_Player_RiftCollapse_Trail(TrailActors[TrailActorIndex]).UpdateVisuals();	//This appears to fix the weird glitch where trail actors would appear completely black for a split second when spawned.
		Hat_NPC_Player_RiftCollapse_Trail(TrailActors[TrailActorIndex]).Restart();	//Required to prevent P2 trail appearing on P1 when actor is initially spawned
	}
	else
	{
		Hat_NPC_Player_RiftCollapse_Trail(TrailActors[TrailActorIndex]).UpdateVisuals();	//Update to match player's current loadout
		Hat_NPC_Player_RiftCollapse_Trail(TrailActors[TrailActorIndex]).Restart();
	}
	TrailActorIndex = (TrailActorIndex + 1) % 15;
}
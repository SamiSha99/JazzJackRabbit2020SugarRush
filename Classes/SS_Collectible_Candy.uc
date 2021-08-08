/**
 *
 * Copyright 2012-2015 Gears for Breakfast ApS. All Rights Reserved.
 */

class SS_Collectible_Candy extends Hat_Collectible_EnergyBit
    placeable;

struct CandyData
{
	var StaticMesh Mesh;
	var Material Material;
	var float Scale;
};

var Array<CandyData> Candies;

event PostBeginPlay()
{
	local int i;
	local StaticMeshComponent SMC;
	i = Rand(Candies.Length);
	SMC = StaticMeshComponent(InnerItem);
	SMC.SetStaticMesh(Candies[i].Mesh);
	SMC.SetMaterial(0, Candies[i].Material);
	SMC.SetScale(Candies[i].Scale);
}

defaultproperties
{
	Begin Object Name=Sprite1
		Sprite=Texture2D'HatInTime_Items.Capsules.Textures.energy_bit_billboard';
	End Object
	
	Begin Object Name=Mesh1
		Materials(0)=Material'HatInTime_Characters.Materials.Invisible';
		Materials(1)=Material'HatInTime_Characters.Materials.Invisible';
	End Object

	Begin Object Name=Mesh2
		StaticMesh= StaticMesh'HatInTime_Levels_Boat_Z2.models.ship_food_cupcake_strawberry';
        Materials(0)= Material'JazzJackRabbit2020_Content.Materials.Candy_mat';
		Scale = 1;
		Translation=(Z=-2);
        Rotation = (Pitch = 4096);
	End Object

	Candies(0) = (Mesh = StaticMesh'HatInTime_Levels_Boat_Z2.models.ship_food_cupcake_strawberry', Material = Material'JazzJackRabbit2020_Content.Materials.Candy_mat', Scale = 3);
	Candies(1) = (Mesh = StaticMesh'HatInTime_Levels_Boat_Z2.models.ship_food_cupcake_yellow', Material = Material'JazzJackRabbit2020_Content.Materials.Candy_mat', Scale = 3);
	Candies(2) = (Mesh = StaticMesh'HatInTime_Levels_Boat_Z2.models.ship_food_cupcake_green', Material = Material'JazzJackRabbit2020_Content.Materials.Candy_mat', Scale = 3);
	Candies(3) = (Mesh = StaticMesh'HatInTime_Levels_Boat_Z2.models.ship_food_crabcake', Material = Material'JazzJackRabbit2020_Content.Materials.Food_Mat', Scale = 3);
	Candies(4) = (Mesh = StaticMesh'HatInTime_Levels_Boat_Z2.models.ship_food_cake_choco', Material = Material'JazzJackRabbit2020_Content.Materials.Candy_mat', Scale = 2.5)
	Candies(5) = (Mesh = StaticMesh'HatInTime_Levels_Boat_Z2.models.ship_food_cake_slice', Material = Material'JazzJackRabbit2020_Content.Materials.Candy_mat', Scale = 2.5)
	Candies(6) = (Mesh = StaticMesh'HatInTime_Levels_Boat_Z2.models.ship_food_cake_strawberry', Material = Material'JazzJackRabbit2020_Content.Materials.Candy_mat', Scale = 2)
	Candies(7) = (Mesh = StaticMesh'HatInTime_Levels_Cake_Trey.platform_cookie01', Material = Material'JazzJackRabbit2020_Content.Materials.Cookie_Mat', Scale = 0.08)
	Candies(8) = (Mesh = StaticMesh'HatInTime_Levels_Cake_Trey.platform_cookie01_bitten', Material = Material'JazzJackRabbit2020_Content.Materials.Cookie_Mat', Scale = 0.08)
	Candies(9) = (Mesh = StaticMesh'HatInTime_Levels_Metro_Z.models.metro_candy', Material = Material'JazzJackRabbit2020_Content.Materials.Candy_Mat_Metro', Scale = 3.25)
}
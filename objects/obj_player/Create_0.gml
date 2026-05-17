event_inherited()
//resources

//counters and tracking
iFrames = 0;
drawX = x
drawY = y

inventory = []
invSize = 15
for(var i = 0; i < invSize; i++)
{
	inventory[i] = -1	
}

weight =	0
weightclass  = 0
weightToNext = getWeightToNext(weightclass)
armorDisparity = 0
weaponDisparity = 0

max_hp =	getMaxhp(weightclass)
hp =		max_hp
baseDefense = 0
defense		= 0

baseDamage = 0
damage = 10

baseLifesteal = 0
baseEvasion = 0
baseFoodheal = 1

attackDelay = 1
moveDelay   = 1

waitTime = 0

asleep = false

global.player = self
global.fog = layer_tilemap_get_id("ts_fog")
layer_set_visible(layer_get_id("ts_fog"),1)
global.walls = layer_tilemap_get_id("ts_walls")
global.levelSeed = random_get_seed()
global.level = 0
global.cheat = parameter_count()==3&&string_count("GMS2TEMP",parameter_string(2))

defineParticles()

function defog(_tx,_ty)
{
	if(!layer_exists("ts_fog")) exit;
	checkFog(_tx,_ty)
	
	if(checkFog(_tx,_ty-1)) checkFog(_tx,_ty-2) //up
	if(checkFog(_tx,_ty+1)) checkFog(_tx,_ty+2) //down
	
	if(checkFog(_tx+1,_ty)) checkFog(_tx+2,_ty) //right
	if(checkFog(_tx-1,_ty)) checkFog(_tx-2,_ty) //left
	
	if(checkFog(_tx-1,_ty-1)) //up-left
	{ 
		checkFog(_tx-1,_ty-2) 
		checkFog(_tx-2,_ty-2) 
		checkFog(_tx-2,_ty-1) 
	}
	
	if(checkFog(_tx+1,_ty-1)) //up-right
	{ 
		checkFog(_tx+1,_ty-2) 
		checkFog(_tx+2,_ty-2) 
		checkFog(_tx+2,_ty-1) 
	}
	
	if(checkFog(_tx-1,_ty+1)) //down-left
	{ 
		checkFog(_tx-1,_ty+2) 
		checkFog(_tx-2,_ty+2) 
		checkFog(_tx-2,_ty+1) 
	}
	
	if(checkFog(_tx+1,_ty+1)) //down-right
	{ 
		checkFog(_tx+1,_ty+2) 
		checkFog(_tx+2,_ty+2) 
		checkFog(_tx+2,_ty+1) 
	}
	
}
function checkFog(_tx,_ty)
{
	if(_tx<0 || _tx >= global.mapSize[0] || _ty<0 || _ty >= global.mapSize[1]) return(false)
	
	tilemap_set(global.fog,0,_tx,_ty)
	return(!tilemap_get(global.walls,_tx,_ty))
}

takeDamage = function(_dam)
{
	if(_dam<0)
	{
		
		if(abs(_dam)>max_hp/5) 
		{
			soundRand(choose(death1,death2,death3),0.1)
			with(global.bigSprite) skeleton_animation_set("blockHeavy",0)
		}
		else 
		{
			soundRand(choose(ow1,ow2,ow3,ow4,ow5,ow6),0.1)
			with(global.bigSprite) skeleton_animation_set("blockLight",0)
		}
	}
	else
	{
		with(global.bigSprite) skeleton_animation_set("block",0)
	}
}
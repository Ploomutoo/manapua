event_inherited()
//resources

//counters and tracking
iFrames = 0;

inventory = []
invSize = 15
for(var i = 0; i < invSize; i++)
{
	inventory[i] = -1	
}

hp =		20
max_hp =	20
defense =	0
damage =	10
attackDelay = 1
moveDelay   = 1

asleep = false

global.player = self
global.fog = layer_tilemap_get_id("ts_fog")
layer_set_visible(layer_get_id("ts_fog"),1)
global.walls = layer_tilemap_get_id("ts_walls")

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
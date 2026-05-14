var _layer = layer_tilemap_get_id("ts_walls")
var _instlayer = layer_get_id("Instances")
global.cellSize = 64

var _roomRad = floor(room_width/2.5)
var _roomCenter = [room_width/2,room_height/2]

var _roomDimensions = 
[
	floor((_roomCenter[0]-_roomRad)/global.cellSize),
	floor((_roomCenter[1]-_roomRad)/global.cellSize),
	floor((_roomCenter[0]+_roomRad)/global.cellSize),
	floor((_roomCenter[1]+_roomRad)/global.cellSize)
]

nodesList = []
junctionList = []
nodesAmt = 50

var _ix,_iy,_desiredx,_desiredy,_diffx,_diffy,_breakout=false,_whatToPlace
var _placeableList = []
_placeableList[0] = [obj_enemy,100]
_placeableList[1] = [obj_gogre,25]
_placeableList[2] = [obj_item,130]
_placeableList[3] = [obj_stairs,10]

random_set_seed(global.levelSeed+global.level)
for(var _i = 0; _i <= nodesAmt; _i++)
{
	nodesList[_i] = [irandom_range(_roomDimensions[0],_roomDimensions[2]),irandom_range(_roomDimensions[1],_roomDimensions[3])]
	while(tilemap_get(_layer,nodesList[_i,0],nodesList[_i,1])=0)
	{
		nodesList[_i] = [irandom_range(_roomDimensions[0],_roomDimensions[2]),irandom_range(_roomDimensions[1],_roomDimensions[3])]
	}
	
	_ix = nodesList[_i,0]
	_iy = nodesList[_i,1]
	
	if(_i>0)
	{		
		_desiredx = nodesList[_i-1,0]
		_desiredy = nodesList[_i-1,1]
		
		while(_ix!=_desiredx || _iy!=_desiredy)
		{
			_diffx = _desiredx - _ix
			_diffy = _desiredy - _iy
			
			if(abs(_diffx)>0 && irandom(1))
			{
				repeat(irandom_range(1,min(5,_diffx)))
				{
					tilemap_set(_layer,0,_ix,_iy)
					_ix+=sign(_diffx)
					if(tilemap_get(_layer,_ix,_iy)=0 && irandom(1))
					{
						_breakout = true
						break;
					}
				}
				if(_breakout) 
				{
					//show_debug_message("Breakout X")
					array_push(junctionList,[_ix,_iy])
					_breakout = false
					break;
				}
			}
			else if(abs(_diffy)>0)
			{
				repeat(irandom_range(1,min(5,_diffy)))
				{
					tilemap_set(_layer,0,_ix,_iy)
					_iy+=sign(_diffy)
					if(tilemap_get(_layer,_ix,_iy)=0 && irandom(1))
					{
						_breakout = true
						break;
					}
				}
				if(_breakout) 
				{
					//show_debug_message("Breakout Y")
					array_push(junctionList,[_ix,_iy])
					_breakout = false
					break;
				}
			}
		}
		if(_i = nodesAmt)
		{
			_whatToPlace = obj_stairs
			show_debug_message("Guaranteed Stairs")
		}
		else _whatToPlace = weightedRoll(_placeableList)
		instance_create_layer(nodesList[_i,0]*global.cellSize,nodesList[_i,1]*global.cellSize,_instlayer,_whatToPlace)
	}
	else
	{
		tilemap_set(_layer,0,_ix,_iy)
	}
}
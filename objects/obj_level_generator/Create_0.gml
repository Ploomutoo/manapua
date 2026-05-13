var _layer = layer_tilemap_get_id("ts_walls")
var _instlayer = layer_get_id("Instances")
global.cellSize = 64

var _roomWidth = floor(room_width/global.cellSize)
var _roomHeight = floor(room_height/global.cellSize)

nodesList = []
nodesAmt = 100

var _ix,_iy,_desiredx,_desiredy,_diffx,_diffy,_breakout=false,_whatToPlace
random_set_seed(global.levelSeed+global.level)
for(var _i = 0; _i < nodesAmt; _i++)
{
	nodesList[_i] = [irandom_range(1,_roomWidth-1),irandom_range(1,_roomHeight-1)]
	
	_ix = nodesList[_i,0]
	_iy = nodesList[_i,1]
	
	if(_i>=1)
	{		
		_desiredx = nodesList[_i-1,0]
		_desiredy = nodesList[_i-1,1]
		
		while(_ix!=_desiredx || _iy!=_desiredy)
		{
			_diffx = _desiredx - _ix
			_diffy = _desiredy - _iy
			
			if(abs(irandom(_diffx))>abs(irandom(_diffy)))
			{
				repeat(irandom_range(1,5))
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
					_breakout = false
					break;
				}
			}
			else
			{
				repeat(irandom_range(1,5))
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
					_breakout = false
					break;
				}
			}
		}
		_whatToPlace = choose(obj_item,choose(obj_enemy,obj_gogre))
		instance_create_layer(nodesList[_i,0]*global.cellSize,nodesList[_i,1]*global.cellSize,_instlayer,_whatToPlace)
	}
	else
	{
		tilemap_set(_layer,0,_ix,_iy)
	}
}
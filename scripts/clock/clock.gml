function clock(_time)
{
	global.player.waitTime = _time
	global.player.alarm[0] = global.gameDelay
	global.player.alarmRecursions = 30
}

function tileDistObj(_o1,_o2)
{
	if(!instance_exists(_o1) || !instance_exists(_o2)) return(-1)
	
	var _out = abs(_o1.x - _o2.x)
	_out += abs(_o1.y - _o2.y)
	return(_out/64)
}

function canLine(_origin,_target)
{
	var _ix = _origin.x + global.cellSize/2
	var _iy = _origin.y + global.cellSize/2
	
	var _tx = _target.x + global.cellSize/2
	var _ty = _target.y + global.cellSize/2
	
	var _slope = [_ix-_tx,_iy-_ty]
	var _distance //number of iterations
	var _color = c_white
	
	if(abs(_slope[0])>abs(_slope[1])) //more x diff
	{
		_distance = ceil(abs(_slope[0]/global.cellSize))
		_slope[1] = _slope[1]*global.cellSize/_slope[0]
		_slope[0] = -sign(_slope[0])*global.cellSize
		
		//_color = c_aqua
		if(_slope[0]<0) 
		{
			_slope[1]*=-1
		}
	}
	else //more y diff
	{
		_distance = ceil(abs(_slope[1]/global.cellSize))
		_slope[0] = _slope[0]*global.cellSize/_slope[1]
		_slope[1] = -sign(_slope[1])*global.cellSize
		
		//_color = c_orange
		if(_slope[1]<0) 
		{
			//idk why this fixes it
			_slope[0]*=-1
		}
	}

	//show_debug_message("Slope of {0}",_slope)
	var _out = true
	while(_distance>0)
	{
		_ix += _slope[0]
		_iy += _slope[1]
		
		_distance--;
		if(tilemap_get_at_pixel(global.walls,_ix,_iy)>0) 
		{	
			_color = c_red
			_out = false
			break;
		}
	}
	
	/*instance_create_layer(x,y,"effects",obj_effect_tracer,
	{
		color : _color,
		decay : 0.8,
		girth : 5,
		points : 
		{
			x1 : _origin.x + global.cellSize/2,
			y1 : _origin.y + global.cellSize/2,
			x2 : _ix,
			y2 : _iy
		}
	})*/
	return(_out)
}

function inFog(_x,_y)
{
	//if(_x<0 || _x >= global.mapSize[0] || _y<0 || _y >= global.mapSize[1]) return(true)
	
	return(tilemap_get(global.fog,floor(_x/64),floor(_y/64)))
}
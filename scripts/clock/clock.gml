function clock(_time)
{
	global.player.waitTime = _time
	global.player.alarm[0] = 10
}

function tileDistObj(_o1,_o2)
{
	if(!instance_exists(_o1) || !instance_exists(_o2)) return(-1)
	
	var _out = abs(_o1.x - _o2.x)
	_out += abs(_o1.y - _o2.y)
	return(_out/64)
}

function inFog(_x,_y)
{
	//if(_x<0 || _x >= global.mapSize[0] || _y<0 || _y >= global.mapSize[1]) return(true)
	
	return(tilemap_get(global.fog,floor(_x/64),floor(_y/64)))
}
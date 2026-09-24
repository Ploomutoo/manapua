function tilemap_grab(_map,_x,_y)
{
	if(_x<0 || _x>=global.mapSize[0] || _y<0 || _y>=global.mapSize[1]) return(1)
	else return(tilemap_get(_map,_x,_y))
}

function checkTerrainLayer(_layer,_x,_y)
{
	var _get = layer_get_id(_layer)
	if(_get != -1 && tilemap_get_at_pixel(_get,_x,_y))
	{
		return(
		string_delete(_layer,1,3)
		)
	}
	return("x")
}

function checkTerrain(_x,_y){
	var _out = []
	var _checkableLayers = [
	"ts_dirt",
	"ts_grass",
	"ts_water",
	"ts_test"
	]
	
	var _grab
	for(var _i = 0; _i < array_length(_checkableLayers); _i++)
	{
		_grab = checkTerrainLayer(_checkableLayers[_i],_x,_y)
		if(_grab!="x") array_push(_out,_grab)
	}
	
	return(_out)
}
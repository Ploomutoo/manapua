function pullOther(_target)
{
	//soundRand(sndPull)
	if(tileDistObj(self,_target)<2) exit;
	
	var _validPlaces = findEmptyAdjacent()
	if(array_length(_validPlaces)>0)
	{
		var _i = irandom(array_length(_validPlaces)-1)
		
		_target.x = _validPlaces[_i][0]
		_target.y = _validPlaces[_i][1]
		
		soundRand(sndPull)
	}
	else
	{
		//show_debug_message("No valid pull positions")	
	}
}

function findEmptyAdjacent()
{
	var _cs = global.cellSize
	var _places = [
	[x+_cs,y],
	[x-_cs,y],
	[x,y+_cs],
	[x,y-_cs]]
	
	var _out = []
	for(var _i = 0; _i < array_length(_places); _i++)
	{
		if(tilemap_get_at_pixel(global.walls,_places[_i][0],_places[_i][1])=0 && instance_position(_places[_i][0],_places[_i][1],obj_enemy)=noone)
		{
			array_push(_out,_places[_i])
		}
	}
	return(_out)
}
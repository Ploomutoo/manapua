if(event_data[? "message"] = "boom")
{
	var _targets = []
	var _instance
	for(var _x = 0; _x < size; _x++)
	{
		for(var _y = 0; _y < size; _y++)
		{
			_instance = instance_position(x+_x*global.cellSize,y+_y*global.cellSize,obj_enemy)
			if(_instance != noone) array_push(_targets,_instance)
		}
	}
	
	for(var _i = 0; _i < array_length(_targets); _i++)
	{
		instance_destroy(_targets[_i])
	}
}
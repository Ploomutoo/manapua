if(event_data[? "message"] = "boom")
{
	var _targets = []
	var _instance = noone
	for(var _x = 0; _x < size; _x++)
	{
		for(var _y = 0; _y < size; _y++)
		{
			if(hitsPlayer)
			{
				_instance = instance_position(x+_x*global.cellSize,y+_y*global.cellSize,obj_player)
				if(_instance != noone) array_push(_targets,_instance)
			}
			_instance = instance_position(x+(_x+0.5)*global.cellSize,y+(_y+0.5)*global.cellSize,obj_enemy)
			if(_instance != noone) 
			{
				//show_debug_message("Goober detected")
				array_push(_targets,_instance)
			}
		}
	}
	
	for(var _i = 0; _i < array_length(_targets); _i++)
	{
		giveBuff(_targets[_i],"Confusion")
		//dealDamageInstance(damage,_targets[_i],caster,1,0,0,0)
		//instance_destroy(_targets[_i])
	}
}
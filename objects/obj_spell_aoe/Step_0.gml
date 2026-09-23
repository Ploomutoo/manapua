if(!fired && image_index>3)
{
	//show_debug_message("Damage is {0}",damage)
	
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
		if(outBuff.name != "")
		{
			giveBuff(_targets[_i],outBuff.name,outBuff.duration,outBuff.strength)
		}
		if(damage > 0) dealDamageInstance(damage,_targets[_i],caster,1,0,0,0,element)
		if(!selfSpecial && array_length(special)>0)
		{
			runArray(special,[_targets[_i]])	
		}
	}
	if(selfSpecial) runArray(special,[caster])
	fired = true
}
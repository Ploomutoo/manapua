//getting array of all sorted instances
inst_arr = [];
with(obj_depth_sort)
{
	array_push(other.inst_arr, id);
}

//sorting array according to position
array_sort(inst_arr, function(_elm1, _elm2)
{
	if(_elm1.y = _elm2.y)
	{
		return _elm1.z - _elm2.z;
	}
    return _elm1.y - _elm2.y;
}); 

//drawing objects
for(var i = 0; i < array_length(inst_arr); i++)
{
	with(inst_arr[i])
	{
		var old_x = x;
		var old_y = y;
		
		x = round(x);
		y = round(y-z);
		event_perform(ev_draw, 0);
		x = old_x;
		y = old_y;
	}
}

with(global.player)
{
	event_perform(ev_draw_end,0)	
}
function scaleSelf(_stat,_amt)
{
	var _percent = false
	var _overwrite = false
	var _firstChar = string_char_at(_stat,0)
	
	//show_debug_message("Scaling {0}'s {1} by {2}",effectiveStats.name,_stat,_amt)
	
	if(_firstChar="%")
	{
		_stat = string_delete(_stat,0,1)
		_percent = true
	}
	else if(_firstChar="=")
	{
		_stat = string_delete(_stat,0,1)
		_overwrite = true
	}	
	
	var _read = struct_get(baseStats, _stat)
	if (_read != undefined)
	{
		if(_overwrite)
		{
			if(is_real(_read)) _amt = real(_amt)
			struct_set(baseStats, _stat,_amt);
		}
		else if(is_real(_read)) 
		{
			if(_percent)
			{  
				_amt = real(_amt)
				struct_set(baseStats, _stat, ceil(_read * _amt));
			}
			else struct_set(baseStats, _stat, _read + _amt);
		}
		else show_debug_message("Requested stat amount "+_stat+" is not a number!")	
	}
	else
	{
		show_debug_message("Requested stat "+_stat+" not found!")	
	}
	calcEffectiveEnemy()
	show_debug_message("{0}'s {1} is now {2}!",effectiveStats.name,_stat,struct_get(effectiveStats,_stat))
}
function applyStat(_special,_amt)
{
	if(_special = "") exit;
	var _percent = false
	var _overwrite = false
	var _firstChar = string_char_at(_special,0)
	
	if(_firstChar="@")
	{
		_special = string_delete(_special,0,1) //Remove @
		var _func = string_split(_special,":")
		if(array_length(_func)>2) 
		{ 
			show_debug_message("Too many arguments in "+_special)
			exit;
		}
		
		var _read = struct_get(effectiveStats, _func[0])
		if (_read != undefined)
		{
			array_push(_read,_func[1])
			struct_set(effectiveStats,_func[0],_read)
		}
		else
		{
			show_debug_message("Trigger "+_func[0]+" not found")
		}
		exit;
	}
	else if(_firstChar="%")
	{
		_special = string_delete(_special,0,1)
		_percent = true
	}
	else if(_firstChar="=")
	{
		_special = string_delete(_special,0,1)
		_overwrite = true
	}	
	
	var _read = struct_get(effectiveStats, _special)
	if (_read != undefined)
	{
		if(_overwrite)
		{
			if(is_real(_read)) _amt = real(_amt)
			struct_set(effectiveStats, _special,_amt);
		}
		else if(is_real(_read)) 
		{
			if(_percent)
			{  
				struct_set(effectiveStats, _special, ceil(_read * _amt));
			}
			else struct_set(effectiveStats, _special, _read + _amt);
		}
		else show_debug_message("Requested stat amount "+_special+" is not a number!")	
	}
	else
	{
		show_debug_message("Requested stat "+_special+" not found!")	
	}
}

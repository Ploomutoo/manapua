function applyStat(_special,_amt)
{
	if(_special = "") exit;
	
	var _percent = false
	
	if(string_char_at(_special,0)="%")
	{
		_special = string_delete(_special,0,1)
		_percent = true
	}
	
	var _read = struct_get(effectiveStats, _special)
	if (_read != undefined)
	{
		if(is_real(_read)) 
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

function buff(_name = "",_tooltip = "",_icon = spr_buff_happy,_duration = 10,_affectedStat = "",_amount = 0,_expireFunc = expireExample) constructor 
{
	name = _name
	tooltip = _tooltip
	icon = _icon
	
	duration = _duration
	affectedStat = _affectedStat
	amount = _amount
	
	expireFunc = _expireFunc
	
	stacks = false 
	//False: Replaces existing instances of the buff consulting advanced stacking behavior
	//True: Adds additional instances of the buff
	stackBehavior = //Not currently implemented, effectively always on UseNew
	{
		//Keywords: UseNew, UseOld, Add, UseGreater, UseLesser
		duration : "UseNew",
		amount : "UseNew"
	}
}

function dotEffect(_name = "",_tooltip = "",_icon = spr_buff_sad,_duration = 10,_amount = 0) constructor 
{
	name = _name
	tooltip = _tooltip
	icon = _icon
	
	duration = _duration
	amount = _amount
}

function expireExample()
{
	//nothing lol
}

function giveBuff(_target,_debuffName,_duration = -1,_strength = -1)
{
	var _buff = new buff(_debuffName)	
	var _path = "Buffs/"+_debuffName+".ini"
	
	if(file_exists(_path))	ini_open(_path)
	else 
	{
		show_debug_message("{0} is not a valid file",_path)
		exit;
	}
	
	var _type = ini_read_string("Default","durationType","turnTerminated")
	var _enemyOnly = ini_read_real("Default","enemyOnly",0)
	
	var _iconString = ini_read_string("Default","icon","spr_buff_happy")
	var _iconSprite = asset_get_index(_iconString)
	if(sprite_exists(_iconSprite)) _buff.sprite = _iconSprite
	
	_buff.tooltip = ini_read_string("Default","tooltip","")
	
	if(_duration = -1) _buff.duration = ini_read_real("Default","duration",10)
	else _buff.duration = _duration //overwrite duration if one is given	
	
	_buff.affectedStat = ini_read_string("Default","affectedStat","")	
	_buff.amount = ini_read_string("Default","amount","")	
	
	var _expireString = ini_read_string("Default","expireFunc","")	
	var _expireFunc = asset_get_index(_expireString)
	if(is_callable(_expireFunc)) _buff.expireFunc = _expireFunc
	
	with(_target)
	{
		if(object_index = obj_player && _enemyOnly) exit;
		var _buffArray = struct_get(buffList,_type)
		if(_buffArray != undefined)
		{
			if(is_array(_buffArray))
			{
				if(!_buff.stacks)
				{
					var _findIndex = -1
					for(var _i = 0; _i < array_length(_buffArray); _i++)
					{
						if(_buffArray[_i].name = _buff.name) 
						{
							_findIndex = _i
							break;
						}
					}
					
					if(_findIndex = -1) array_push(_buffArray,_buff)
					else 
					{
						//show_debug_message("Replacing buff {0} with new instance",_buff.name)
						delete(_buffArray[_findIndex])
						_buffArray[_findIndex] = _buff
					}
				}
				else
				{
					array_push(_buffArray,_buff)
				}
				struct_set(buffList,_type,_buffArray)
			}
			else
			{
				show_debug_message("Buff type " + _type + " is not an array")	
			}
		}
		else
		{
			show_debug_message("Buff type " + _type + " not found")	
		}
		
		if(object_index = obj_player) calcEffectiveStats()
		else calcEffectiveEnemy()
	}
	
	delete _buff;
}

function decayBuff(_category,_amt = 1)
{
	var _buffArray = struct_get(buffList,_category)
	
	if(_buffArray != undefined)
	{
		for(var _i = array_length(_buffArray)-1; _i >= 0; _i--)
		{
			_buffArray[_i].duration -= _amt
			
			if(_buffArray[_i].duration<=0)
			{
				_buffArray[_i].expireFunc()
		
				delete _buffArray[_i]
				array_delete(_buffArray,_i,1)
			}
		}
	}
	else
	{
		show_debug_message("No such buff category as {0}!",_category)	
	}
	
	if(object_index = obj_player) calcEffectiveStats()
	else calcEffectiveEnemy()
}
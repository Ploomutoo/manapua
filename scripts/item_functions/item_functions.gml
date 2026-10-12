function Item() constructor
{
	//Accepts potion, weapon, armor, ring
	slot = ""
	name = "Placeholder"
	size = ""
	sprite = spr_item_placeholder
	defense = 0
	damage	= 0
	equipped	= false
	special = [""]
	specialAmt = [0]
	tooltip = ""
	funcUse = function()
	{
		toggleEquipped(global.player)
	}
}

function runArray(_array,_additionalParameters = [])
{
	if(array_length(_array)<1) exit;
	
	var _func
	var _funcName = ""
	var _funcArray = []
	for(var _i = 0; _i<array_length(_array); _i++)
	{
		_funcArray = string_split(_array[_i],":",true)
		
		_funcName = _funcArray[0]
		array_delete(_funcArray,0,1)
		
		_func = asset_get_index(_funcName)
		
		if(_func != -1) 
		{
			if(array_length(_funcArray)>0)
			{
				if(_funcArray[0] = "addParam") 
				{
					array_delete(_funcArray,0,1)
					_funcArray = array_concat(_additionalParameters,_funcArray)
				}
				
				method_call(_func,_funcArray)
			}
			else
			{
				//show_debug_message("Calling method {0} with no parameters ",_funcName)
				method_call(_func)
			}
		}
		else show_debug_message("Function {0} is not callable",_funcName)
	}
}

function findWieldedWeapon()
{
	for(var _i = 0; _i < array_length(inventory); _i++)
	{
		if(inventory[_i] != -1 && inventory[_i].equipped && inventory[_i].slot = "Weapon")
		{
			return(_i)
		}
	}
	show_debug_message("Could not find a wielded weapon!")
	return(-1)
}

function specialTooltip(_special,_amt)
{
	var _out = ""
	for(var _i = 0; _i < array_length(_special); _i++)
	{
		_out += "\n[spr_text_special] " + _special[_i] + " " + string(_amt[_i])
	}
	return(_out)
}

function generateTooltip(_item)
{
	var _tooltip = _item.name

	if(_item.slot = "Weapon")
	{
		_tooltip += "\n Size "+_item.weightclass
		_tooltip += "\n[spr_text_damage] "+ string(_item.damage)
		_tooltip += "\n[spr_text_interval] "+ string(_item.interval)
		if(_item.special[0]!="") _tooltip += specialTooltip(_item.special,_item.specialAmt)
		
	}
	else if(_item.slot = "Consumable")
	{
		_tooltip += "\n" + _item.description		
		if(_item.condition != "Fresh") _tooltip = _item.condition + " " + _tooltip
	}
	else if(_item.slot = "Armor")
	{
		_tooltip += "\n Size "+_item.weightclass
		_tooltip += "\n[spr_text_defense] "+ string(_item.defense)		
		if(_item.special[0]!="") _tooltip += specialTooltip(_item.special,_item.specialAmt)
	}
	else if(_item.slot = "Ring" || _item.slot = "Amulet")
	{
		if(_item.special[0]!="") _tooltip += specialTooltip(_item.special,_item.specialAmt)
	}
	else if(_item.slot = "Spellbook")
	{	
		for(var _i = 0; _i<array_length(_item.spells); _i++)
		{
			_tooltip += "\n[spr_text_basestats,6] "+_item.spells[_i]
		}
	}
	else if(_item.slot = "Spice")
	{
		_tooltip += "\n"+_item.description	
	}
	
	return(_tooltip)
}

function makeConsumable(_item,_index)
{
	_item.slot = "Consumable"

	_item.funcUse = eatFood
	_item.condition = "Fresh"
	_item.tags = string_split(global.itemSpawnList[# 4, _index],"|",true)
			
	//on eat
	_item.eatEffect = string_split(global.itemSpawnList[# 5, _index],"|",true)
	var _description = "",_split
	if(array_length(_item.eatEffect)>0)
	{
		_description += "When eaten "
		for(var _i = 0; _i < array_length(_item.eatEffect); _i++)
		{
			_split = string_split(_item.eatEffect[_i],":",true)
			switch(_split[0])
			{
				case "heal":
					_description += "heals for " + _split[1]
					break;
				case "tempHealth":
					_description += "gives " + _split[1] + " temp HP"
					break;
				default:
					_description += "gives " + _split[1] + " " + _split[0]
					break;
			}
			if(array_length(_item.eatEffect)-_i > 1) _description += " and "
			else _description += "\n"
		}
	}
	
	//in stomach
	var _stomachDuration = string_split(global.itemSpawnList[# 7, _index]," ",true)
	if(array_length(_stomachDuration) > 1) 
	{
		_description += "Digests over " + global.itemSpawnList[# 7, _index]
		
		var _stomachEffect = string_split(global.itemSpawnList[# 6, _index],"|",true)
		var _get,_stat = [],_amt = []
		if(array_length(_stomachEffect) > 0)
		{
			_description += " granting "
			for(var _i = 0; _i < array_length(_stomachEffect); _i++)
			{
				_get = string_split(_stomachEffect[_i],":",true)
				array_push(_stat,_get[0])
				array_push(_amt,_get[1])
				
				_description += _get[1] + " " + _get[0]
				if(array_length(_stomachEffect)-_i > 1) _description += " and "
			}
		}
	
		_item.stomachType = _stomachDuration[1]
		_item.stomachBuff = new eatBuff(_item.name,"Food buff",_item.sprite,real(_stomachDuration[0]),_stat,_amt)
		_description += "\n"
		
		//digested
		_item.stomachBuff.digestEffect = string_split(global.itemSpawnList[# 8, _index],"|",true)
		array_push(_item.stomachBuff.digestEffect,"gain:"+global.itemSpawnList[# 9, _index])
		
		_get  = ""
		_stat = []
		_amt  = []
		_description += "Then "
		for(var _i = 0; _i<array_length(_item.stomachBuff.digestEffect); _i++)
		{
			_get = string_split(_item.stomachBuff.digestEffect[_i],":",true)
			array_push(_stat,_get[0])
			array_push(_amt,_get[1])
			
			switch(_stat[_i])
			{
				case "heal":
					_description += "heals for " + _amt[_i]
					break;
				case "gain":
					_description += "gain " + _amt[_i] + " pounds"
					break;
				case "xtempHealth":
					break;
				default:
					_description += "gives " + _amt[_i] + " " + _stat[_i]
					break;
			}
			if(array_length(_item.stomachBuff.digestEffect)-_i > 1) _description += " and "
		}
	}
	else 
	{
		_description += "Digests instantly\n"
		_item.stomachType = "none"
	}
	
	//description
	_item.description = _description
	return(_item)
}

function drawItemText(_item,_x,_y)
{
	if(_item = -1) exit;
	
	var _text = _item.tooltip
	var _outlineColor = c_white
	
	if(_item.slot = "Weapon" && _item.minWeight > global.player.weightclass) 
	{
		var _disparity = _item.minWeight - global.player.weightclass
			
		if(_disparity>2) _text = "Very Heavy " + _text
		else _text = "Heavy " + _text
			
		_outlineColor = c_yellow
	}
	else if(_item.slot = "Armor")
	{
		if(global.player.weightclass < _item.minWeight)
		{
			_text = "Loose " + _text
			_outlineColor = c_yellow
		}
		else if(global.player.weightclass > _item.maxWeight)
		{
			_text = "Tight " + _text
			_outlineColor = c_yellow
		}
	}
	
	var _id   = "itemText"
	scribble(_text,_id).align(fa_left,fa_bottom)
	var _bbox = scribble(_text,_id).get_bbox(_x,_y)
	
	draw_set_alpha(0.5)
	draw_set_color(c_black)
	draw_rectangle(_bbox.x0,_bbox.y0,_bbox.x3,_bbox.y3,0)
	draw_set_alpha(1)
	draw_set_color(_outlineColor)
	draw_rectangle(_bbox.x0,_bbox.y0,_bbox.x3,_bbox.y3,1)
	draw_set_color(c_white)
	scribble(_text,_id).draw(_x,_y)
	delete _bbox
}

function heal(_amt,_target)
{
	if(_target.hp < _target.effectiveStats.max_hp) _target.hp = min(_target.effectiveStats.max_hp,_target.hp+_amt)
}

function hurt(_amt,_target)
{
	_target.hp += _amt
	//_target.takeDamage(_amt)
	
	textPopup(_target.x+32,_target.y,string(_amt))
	//soundRand(sndFireHiss)
	if(_target.hp<=0)
	{
		_target.onDeath()
		instance_destroy(_target)	
	}
}
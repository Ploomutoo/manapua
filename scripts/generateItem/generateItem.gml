function generateFloorItem(_floor,_rarityBonus = 0){
	
	var _out = new Item()
	var _weaponList
	
	switch(_floor)
	{
		case "Garden":
		default:
		
			_weaponList = load_csv("itempools.csv")
			break;
	}
		var _weights = []
	var _weightsOn = 0
	for(var _parser = 0; _parser < ds_grid_height(_weaponList); _parser++)
	{
		if(_weaponList[# 0, _parser] != "Name")
		{
			_weights[_weightsOn] = [_parser,real(_weaponList[# 1, _parser])]
			_weightsOn++
		}
	}
	var _type = weightedRoll(_weights,_rarityBonus)	
	
	_out.name = _weaponList[# 0, _type]
	if(_out.name = "Roll Potion" || _out.name = "Roll Scroll")
	{
		_out = generatePotion()
		return(_out)
	}
	
	_out.sprite = asset_get_index(_weaponList[# 3, _type])
	_out.slot	= _weaponList[# 2, _type]
	switch(_out.slot)
	{
		case "Weapon":
		
			_out.damage			= _weaponList[# 4, _type]
			_out.kineticdamage	= _weaponList[# 5, _type]
			_out.interval		= _weaponList[# 6, _type]
			_out.weightclass	= parseWeightclass(_weaponList[# 7, _type])
			_out.weightinterval	= _weaponList[# 8, _type]
			_out.special		= _weaponList[# 9, _type]
			_out.specialAmt		= _weaponList[# 10, _type]
			break;
			
		case "Armor":
			_out.defense		= _weaponList[# 4, _type]
			_out.weightclass	= parseWeightclass(_weaponList[# 5, _type])
			_out.special		= _weaponList[# 6, _type]
			_out.specialAmt		= _weaponList[# 7, _type]
			break;
			
		case "Ring":
			break;
	}
	_out.tooltip = generateTooltip(_out)
	return(_out)
}

function parseWeightclass(_class)
{
	if(is_real(_class)) //number given, return letter
	{
		if(_class>3)
		{
			return(string(_class-2)+"XL")	
		}
		else switch(_class)
		{
			case 0:
				return("S")
				break;
			case 1:
				return("M")
				break;
			case 2:
				return("L")
				break;
			case 3:
				return("XL")
				break;
		}
	}
	else if(is_string(_class)) //letter given, return number
	{
		switch(_class)
		{
			case "S":
			return(0)
			break;
			case "M":
			return(1)
			break;
			case "L":
			return(2)
			break;
			case "XL":
			return(3)
			break;
			default: //2XL+ parser, 2XL should return 4, 3XL: 5, 4XL: 6, etc.
			var xlAmt = real(string_digits(_class))
			return(2+xlAmt)
			break;
		}
	}
	else
	{
		return(-1)
	}
}

function weightedRoll(_array,_bonus = 0)
{
	var _maxRoll = 0
	for(var _i = 0; _i<array_length(_array); _i++)
	{
		_maxRoll += _array[_i,1]	
	}
		
	var _roll = irandom(_maxRoll)+_bonus
	var _outIndex = 0
	
	_i = _array[0,1]
	while(_i<_roll)
	{
		_outIndex++
		_i += _array[_outIndex,1]
	}
	//show_debug_message("Roll of "+string(_roll)+", "+_array[_outIndex,0])
	return(_array[_outIndex,0])
}

function potionAll()
{
	soundRand(sndQuaff)
	with(global.bigSprite) skeleton_animation_set("drink",false) 
}

function generatePotion()
{
	var _out = new Item()
	_out.consumable = true
	_out.sprite		= spr_item_potion_placeholder
	
	var _weights = []
	_weights[0] = ["curing",30]
	_weights[1] = ["healWounds",10]
	_weights[2] = ["strength",10]
	_weights[3] = ["mana",6]
	_weights[4] = ["haste",6]
	_weights[5] = ["divinity",1]
	var _type = weightedRoll(_weights)	
	switch(_type)
	{
		case "curing":
		_out.name = "Curing Potion"
		_out.funcUse = function()
		{
			potionAll()
			heal(15,global.player)
		}
		break;
		
		case "healWounds":
		_out.name = "Healing Potion"
		_out.funcUse = function()
		{
			potionAll()
			heal(45,global.player)
		}
		break;
		
		case "strength":
		_out.name = "Strength Potion"
		_out.funcUse = function()
		{
			potionAll()
		}
		break;
		
		case "mana":
		_out.name = "Mana Frenzy Potion"
		_out.funcUse = function()
		{
			potionAll()
		}
		break;
		
		case "haste":
		_out.name = "Haste Potion"
		_out.funcUse = function()
		{
			potionAll()
		}
		break;
		
		case "divinity":
		_out.name = "Divinity Potion"
		_out.funcUse = function()
		{
			potionAll()
		}
		break;
	}
	_out.tooltip = generateTooltip(_out)
	return(_out)
}

function generateWeapon()
{
	var _out = new Item()
	_out.slot = "Weapon"
	var _weaponList = load_csv("weps.csv")
	
	var _weights = []
	for(var _i = 1; _i < ds_grid_height(_weaponList); _i++)
	{
		_weights[_i-1] = [_i,real(_weaponList[# 1, _i])]
	}
	var _type = weightedRoll(_weights)	
	
	_out.name = _weaponList[# 0, _type]
	_out.damage = _weaponList[# 2, _type]
	_out.interval = _weaponList[# 3, _type]
	_out.reach = 1
	
	var _special = _weaponList[# 4, _type]
	switch(_special)
	{
		case "Sneak Stun":
		break;
		
		case "Sneak Stab":
		break;
		
		case "Reach Attack":
		_out.reach += _weaponList[# 5, _type]
		break;
		
		case "Cleave":		
		break;
		
		case "Flail":
		break;
		
		case "Multistrike":
		break;
		
		case "Riposte":
		break;
		
		default:
		break;
	}
	
	ds_grid_destroy(_weaponList)
	return(_out)
}

function generateScroll()
{
	var _out = new Item()
	
	_out.consumable = true
	
	return(_out)
}


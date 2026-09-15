function generateFloorItem(_floor,_rarityBonus = 0){
	
	var _out = new Item()
	static _weaponList = ds_grid_create(0,0)
	
	switch(_floor)
	{
		case "Garden":
		default:
		
			_weaponList = load_csv("items-test.csv")
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
		
			_out.damage			= real(_weaponList[# 4, _type])
			_out.kineticdamage	= real(_weaponList[# 5, _type])
			_out.interval		= real(_weaponList[# 6, _type])
			_out.weightclass	= parseWeightclass(_weaponList[# 7, _type])
			_out.weightinterval	= real(_weaponList[# 8, _type])
			
			_out = parseSpecials(_out,_weaponList[# 9, _type],_weaponList[# 10, _type])
			break;
			
		case "Armor":
			_out.defense		= real(_weaponList[# 4, _type])
			_out.weightclass	= parseWeightclass(_weaponList[# 5, _type])
			_out.skinName		= _weaponList[# 8, _type]
			
			_out = parseSpecials(_out,_weaponList[# 6, _type],_weaponList[# 7, _type])
			break;
			
		case "Ring":
		case "Amulet":
			_out = parseSpecials(_out,_weaponList[# 4, _type],_weaponList[# 5, _type])
			break;
			
		case "Consumable":
			_out.slot = "Consumable"
			_out.healing = _weaponList[# 4, _type]
			_out.weightgain = _weaponList[# 5, _type]
			_out.funcUse = eatFood
			_out = parseSpecials(_out,_weaponList[# 6, _type],_weaponList[# 7, _type])
			break;
	}
	_out.tooltip = generateTooltip(_out)
	return(_out)
}

function parseSpecials(_struct,_special,_amt)
{
	_struct.special	= string_split(_special,"|")
	if(_special = "") return(_struct)
	
	var _amtArrayIn = string_split(_amt,"|")
	_struct.specialAmt = []
	for(var _i = 0; _i < array_length(_amtArrayIn); _i++)
	{
		_struct.specialAmt[_i] = real(_amtArrayIn[_i])
	}
	
	return(_struct)
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
			case 1:
				return("M")
			case 2:
				return("L")
			case 3:
				return("XL")
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

function generatePotion()
{
	var _out = new Item()
	_out.consumable = true
	_out.slot		= "Potion"
	
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
		_out.sprite	= spr_potion_curing
		_out.funcUse = potionCure
		_out.tooltip = _out.name + "\nHeals for 15"
		_out.weightgain = 15
		break;
		
		case "healWounds":
		_out.name = "Healing Potion"
		_out.sprite	= spr_potion_healing
		_out.funcUse = potionHeal
		_out.tooltip = _out.name + "\nHeals for 45"
		_out.weightgain = 30
		break;
		
		case "strength":
		_out.name = "Strength Potion"
		_out.sprite	= spr_potion_might
		_out.funcUse = potionStrength
		_out.tooltip = _out.name + "\nTemporary double-damage"
		_out.weightgain = 30
		break;
		
		case "mana":
		_out.name = "Mana Frenzy Potion"
		_out.sprite	= spr_potion_mana_frenzy
		_out.funcUse = potionManaFrenzy
		_out.tooltip = _out.name + "\nDisables spell cooldown"
		_out.weightgain = 30
		break;
		
		case "haste":
		_out.name = "Haste Potion"
		_out.sprite	= spr_potion_haste
		_out.funcUse = potionHaste
		_out.tooltip = _out.name + "\nActions are twice as fast"
		_out.weightgain = 50
		break;
		
		case "divinity":
		_out.name = "Divinity Potion"
		_out.sprite	= spr_potion_divinity
		_out.funcUse = potionDivinity
		_out.tooltip = _out.name + "\nTemporary invulnerability"
		_out.weightgain = 50
	}
	
	_out.tooltip += "\nGain " + string(_out.weightgain) + "lbs"
	return(_out)
}

function generateScroll()
{
	var _out = new Item()
	
	_out.consumable = true
	
	return(_out)
}


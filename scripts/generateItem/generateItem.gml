function generateFloorItem(_floor,_rarityBonus = 0){
	var _out
	var _typeWeights = []
	_typeWeights[0] = ["potion",30]
	_typeWeights[1] = ["scroll",20]
	_typeWeights[2] = ["weapon",10]
	_typeWeights[3] = ["armor",10]
	_typeWeights[4] = ["ring",5]
		
	var _type = weightedRoll(_typeWeights)
	switch(_type)
	{
		case "potion":
		_out = generatePotion()
		_out.sprite = spr_item_potion_placeholder
		break;
		
		case "weapon":
		_out = generateWeapon()
		_out.sprite = spr_item_weapon_placeholder
		break;
		
		default:
		_out = new Item()
		break;
	}
	_out.tooltip = generateTooltip(_out)
	return(_out)
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
			soundRand(sndQuaff)
			heal(15,global.player)
		}
		break;
		
		case "healWounds":
		_out.name = "Healing Potion"
		_out.funcUse = function()
		{
			soundRand(sndQuaff)
			heal(45,global.player)
		}
		break;
		
		case "strength":
		_out.name = "Strength Potion"
		_out.funcUse = function()
		{
			soundRand(sndQuaff)
		}
		break;
		
		case "mana":
		_out.name = "Mana Frenzy Potion"
		_out.funcUse = function()
		{
			soundRand(sndQuaff)
		}
		break;
		
		case "haste":
		_out.name = "Haste Potion"
		_out.funcUse = function()
		{
			soundRand(sndQuaff)
		}
		break;
		
		case "divinity":
		_out.name = "Divinity Potion"
		_out.funcUse = function()
		{
			soundRand(sndQuaff)
		}
		break;
	}
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
	
	var _special = _weaponList[# 4, _type]
	switch(_special)
	{
		case "Sneak Stun":
		break;
		
		case "Sneak Stab":
		break;
		
		case "Reach Attack":
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


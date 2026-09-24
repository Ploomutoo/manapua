var _result = ds_map_find_value(async_load, "result")
if(_result = undefined || _result = "") exit;

switch(cheatInput)
{
	case "":
	//Nothing
	break;
	
	case "Set Stat":
	var _get = struct_get(baseStats,_result)
	if(_get != undefined)
	{
		if(is_real(_get))
		{
			get_integer_async("Setting "+_result,1)
		}
		else
		{
			get_string_async("Setting "+_result,"")
		}
		cheatInput = _result
		exit;
	}
	else
	{
		show_debug_message("No such thing as {0}",_result)	
	}
	break;
	
	case "Set Spell":
	spellCasting = new Spell(_result)
	break;
	
	case "Give Buff":
	giveBuff(self,_result)
	break;
	
	case "Set Weight":
	weightclass = real(_result)
	weight = 0
	weightToNext = getWeightToNext(weightclass)
	with(global.bigSprite) skeleton_animation_set("weightUp",0)
	break;
	
	case "Give Item":
	var _i = 0
	while(inventory[_i]!=-1)
	{
		_i++
		if(_i>=invSize) 
		{ //inventory full :(
			soundRand(choose(invFull1,invFull2),0.1)
			with(global.bigSprite) skeleton_animation_set("no",0)
			exit;	
		}
	}
	
	var _out = new Item()
	var _type
		
	for(_type = 0; _type < ds_grid_height(global.itemSpawnList); _type++)
	{
		if(global.itemSpawnList[# 0, _type] = _result) break;
	}
		
	_out.name = "Divine " + global.itemSpawnList[# 0, _type]
	_out.sprite = asset_get_index(global.itemSpawnList[# 3, _type])
	_out.slot	= global.itemSpawnList[# 2, _type]
	switch(_out.slot)
	{
		case "Weapon":
		
			_out.damage			= real(global.itemSpawnList[# 4, _type])
			_out.kineticdamage	= real(global.itemSpawnList[# 5, _type])
			_out.interval		= real(global.itemSpawnList[# 6, _type])
			_out.weightclass	= parseWeightclass(global.itemSpawnList[# 7, _type])
			_out.weightinterval	= real(global.itemSpawnList[# 8, _type])
			
			_out = parseSpecials(_out,global.itemSpawnList[# 9, _type],global.itemSpawnList[# 10, _type])
			break;
			
		case "Armor":
			_out.defense		= real(global.itemSpawnList[# 4, _type])
			_out.weightclass	= parseWeightclass(global.itemSpawnList[# 5, _type])
			_out.skinName		= global.itemSpawnList[# 8, _type]
			
			_out = parseSpecials(_out,global.itemSpawnList[# 6, _type],global.itemSpawnList[# 7, _type])
			break;
			
		case "Ring":
		case "Amulet":
			_out = parseSpecials(_out,global.itemSpawnList[# 4, _type],global.itemSpawnList[# 5, _type])
			break;
			
		case "Consumable":
			_out.slot = "Consumable"
			_out.healing = global.itemSpawnList[# 4, _type]
			_out.weightgain = global.itemSpawnList[# 5, _type]
			_out.funcUse = eatFood
			_out.condition = "Fresh"
			_out = parseSpecials(_out,global.itemSpawnList[# 6, _type],global.itemSpawnList[# 7, _type])
			break;
			
		case "Spellbook":
			_out.spells = string_split(global.itemSpawnList[# 4, _type],"|",true)
			break;
	}
	_out.tooltip = generateTooltip(_out)
	inventory[_i] = _out
		
	delete _out
	break;
	
	default:
	struct_set(baseStats,cheatInput,_result)
	calcEffectiveStats()
	break;
}

cheatInput = ""
keyboard_key_release(vk_shift)
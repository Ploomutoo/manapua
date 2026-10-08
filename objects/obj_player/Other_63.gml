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
	weightclass = parseWeightclass(_result)
	weight = 0
	weightToNext = getWeightToNext(weightclass)
	with(global.bigSprite) skeleton_animation_set("weight-gain",0)
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
	inventory[_i] = generateFloorItem(_result)
	break;
	
	default:
	struct_set(baseStats,cheatInput,_result)
	calcEffectiveStats()
	break;
}

cheatInput = ""
keyboard_key_release(vk_shift)
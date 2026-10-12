function eatFood()
{
	switch(condition)
	{
		case "Frozen":
		case "Deep Frozen":
		case "Skewered":
		return(false)
	}
	
	//run on-eat stuff
	var _split,_stat,_amt
	for(var _i = 0; _i < array_length(eatEffect); _i++)
	{
		_split = string_split(eatEffect[_i],":",true)
		_stat = _split[0]
		_amt = real(_split[1])
		switch(_stat)
		{
			case "heal":
				if(_amt>0)
				{
					heal(_amt,global.player)
				}
				else
				{
					hurt(_amt,global.player)	
				}
				break;
			case "tempHealth":
				//grant temp health
				break;
			default:
				//add stat
				var _grab = struct_get(global.player.baseStats,_stat)
				if(is_real(_grab))
				{
					struct_set(global.player.baseStats,_stat,_grab+_amt)
				}
				else show_debug_message("{0} is not a number!",_stat)
				break;
		}
	}
	
	//apply the buff
	switch(stomachType)
	{
		case "turn":
		case "turns":
			array_push(global.player.buffList.turnTerminated,stomachBuff)
			break;
		case "floor":
		case "floors":
			array_push(global.player.buffList.floorTerminated,stomachBuff)
			break;
		case "none":
			break;
		default:
			show_debug_message("Buff type not found")
			break;
	}
	
	with(global.bigSprite) skeleton_animation_set("eat-food",0)
	//global.player.weight += weightgain
	global.player.weight = max(0,global.player.weight)
	
	return(true)
}

function runDigest()
{
	var _get  = ""
	var _stat
	var _amt

	show_debug_message("Running digest {0}",name)
	for(var _i = 0; _i<array_length(digestEffect); _i++)
	{
		_get = string_split(digestEffect[_i],":",true)
		_stat = _get[0]
		_amt = _get[1]
			
		switch(_stat)
		{
			case "heal":
				heal(_amt,global.player)
				break;
			case "gain":
				global.player.weight += _amt
				global.player.weight = max(0,global.player.weight)
				break;
			case "xtempHealth":
				//remove temphealth
				
				break;
			default:
				var _grab = struct_get(global.player.baseStats,_stat)
				if(is_real(_grab))
				{
					struct_set(global.player.baseStats,_stat,_grab+_amt)
				}
				else show_debug_message("{0} is not a number!",_stat)
				break;
		}
	}
}
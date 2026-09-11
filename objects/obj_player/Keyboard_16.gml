if(!global.cheat) exit;

if(keyboard_check_pressed(ord("I")))
{
	if(keyboard_check(vk_control))
	{
		for(var i = 0; i < invSize; i++)
		{
			if(!inventory[i].equipped) inventory[i] = -1	
		}
		calcEffectiveStats()
	}
	else
	{
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
		inventory[_i] = generateFloorItem("Testing")
		soundRand(choose(get1,get2,get4,get5),0.1)
	}
}
else if(keyboard_check_pressed(ord("R")))
{
	room_goto(room)	
}
else if(keyboard_check_pressed(ord("F")))
{
	layer_set_visible("ts_fog",!layer_get_visible("ts_fog"))
}
else if(keyboard_check_pressed(ord("W")))
{
	weightclass = get_integer("Input Weight Class","")
	weight = 0
	weightToNext = getWeightToNext(weightclass)
	with(global.bigSprite) skeleton_animation_set("weightUp",0)
}
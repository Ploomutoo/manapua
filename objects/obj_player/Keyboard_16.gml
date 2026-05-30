if(!global.cheat) exit;

if(keyboard_check_pressed(ord("I")))
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
else if(keyboard_check_pressed(ord("R")))
{
	room_goto(room)	
}
else if(keyboard_check_pressed(ord("F")))
{
	layer_set_visible("ts_fog",!layer_get_visible("ts_fog"))
}
if(!global.cheat) exit;
if(cheatInput != "") exit;

if(keyboard_check_pressed(ord("I")))
{
	if(keyboard_check(vk_control)) //clear inventory
	{
		for(var i = 0; i < invSize; i++)
		{
			if(!inventory[i].equipped) inventory[i] = -1	
		}
		calcEffectiveStats()
	}
	else
	{
		get_string_async("O LORD GIVE","")
		cheatInput = "Give Item"
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
	get_integer_async("Input Weight Class","")
	cheatInput = "Set Weight"
}
else if(keyboard_check_pressed(ord("B")))
{
	get_string_async("Input Buff","")
	cheatInput = "Give Buff"
}
else if(keyboard_check_pressed(ord("M")))
{
	get_string_async("Set spell to","")
	cheatInput = "Set Spell"
}
else if(keyboard_check_pressed(ord("S")))
{
	get_string_async("Set what stat?","")
	cheatInput = "Set Stat"
}
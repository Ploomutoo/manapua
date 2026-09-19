if(holding != -1)
{
	if (mouse_x>0) draw_sprite(holding.sprite,0,mouse_x,mouse_y)
}
else
{
	if(mouseOn != noone)
	{
		
	}
}

with(global.player)
{
	//Spellcasting
	var _target

	if(spellCasting.selected != -1)
	{
		for(var _i = array_length(spellCasting.targets)-1; _i >= 0; _i--)
		{
			if(_i = spellCasting.selected || spellCasting.targetStyle = spellTargeting.allEnemy) draw_set_color(c_yellow)
			else draw_set_color(c_orange)
	
			_target = spellCasting.targets[_i]
			draw_rectangle(_target.bbox_left,_target.bbox_top,_target.bbox_right,_target.bbox_bottom,1)
		}
		draw_set_color(c_white)
	}	
}
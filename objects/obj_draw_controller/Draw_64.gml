draw_sprite(spr_sidebar,0,0,0)
draw_self()

var _topcorner = invCorner
var _invOn = 0

with(obj_player)
{
	scribble(string(hp)+"/"+string(max_hp)+" HP\n"
	+string(damage)+" Damage\n"+string(defense)+" Defense\n"
	+"Size "+string(weight)
	).draw(16,16)
	
	for(var _iy = 0; _iy < other.invSize[1]; _iy++)
	{
		for(var _ix = 0; _ix < other.invSize[0]; _ix++)
		{
			if(inventory[_invOn]=-1) 
			{
				//draw_sprite(spr_ui_box,0,_topcorner[0]+_ix*64,_topcorner[1]+_iy*64)
			}
			else
			{
				if(inventory[_invOn].equipped)
				{
					draw_sprite(spr_ui_box,0,_topcorner[0]+_ix*64,_topcorner[1]+_iy*64)
				}
				draw_sprite(inventory[_invOn].sprite,0,_topcorner[0]+_ix*64,_topcorner[1]+_iy*64)
			}
			_invOn++;
		}
	}
	
	if(other.invOn != -1) drawItemText(inventory[other.invOn],mouse_x+360,mouse_y)
	
}

if(holding != -1)
{
	draw_sprite(holding.sprite,0,window_mouse_get_x(),window_mouse_get_y())
	//draw_sprite(holding.sprite,0,mouse_x,mouse_y)
}
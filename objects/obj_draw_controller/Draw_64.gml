draw_sprite(spr_sidebar,0,0,0)
draw_self()

var _topcorner = invCorner
var _invOn = 0

with(obj_player)
{
	var _subimages = sprite_get_number(spr_clock)*waitTime/4
	draw_sprite(spr_clock,_subimages,360+16,16)
	scribble(string(waitTime)).draw(360+48,16)
	
	scribble(string(ceil(hp))+"/"+string(effectiveStats.max_hp)+" HP\n"
	+string(damage)+"[spr_text_damage] / "+ string(finalDelay) + "[spr_text_interval]\n"
	+"Size "+parseWeightclass(weightclass)+": "+string(weight)+"/"+string(weightToNext)
	//+"\n"+string(mouse_x)+", "+string(mouse_y)
	).draw(360+16,48)
	
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
				
				if(inventory[_invOn].slot = "Weapon" ||  inventory[_invOn].slot = "Armor") draw_sprite(spr_text_weight,inventory[_invOn].weightclass,_topcorner[0]+_ix*64,_topcorner[1]+_iy*64)
			}
			_invOn++;
		}
	}
	
	if(other.invOn != -1) drawItemText(inventory[other.invOn],mouse_x+360,mouse_y)
	
	#region draw buffs	
	var _i = 0, _ix = 360, _iy = 720-48
	draw_set_halign(fa_right)
	draw_set_valign(fa_bottom)
	for(_i = array_length( buffList.allBuffs); _i>0; _i--)
	{
		draw_sprite( buffList.allBuffs[_i-1].icon,0,_ix,_iy)
		draw_text(_ix+48,_iy+48,string(round( buffList.allBuffs[_i-1].duration)))		
		_ix += 48;
	}
	
	var _mx = window_mouse_get_x(), _my = window_mouse_get_y()
	if(_my>_iy) //tooltip display
	{
		var _buffCursor = floor((_mx-360)/48), _tooltipDir = 1
		if(_buffCursor >= 0 && _buffCursor < array_length( buffList.allBuffs))
		{
			var _text =  buffList.allBuffs[_buffCursor].name + "\n" +  buffList.allBuffs[_buffCursor].tooltip
			var _id   = "buffTooltip"
			scribble(_text,_id).align(fa_left,fa_bottom)
			var _bbox = scribble(_text,_id).get_bbox(_mx,_my)
	
			draw_set_alpha(0.5)
			draw_set_color(c_black)
			draw_rectangle(_bbox.x0,_bbox.y0,_bbox.x3,_bbox.y3,0)
			draw_set_alpha(1)
			draw_set_color(c_white)
			scribble(_text,_id).draw(_mx,_my)
			draw_rectangle(_bbox.x0,_bbox.y0,_bbox.x3,_bbox.y3,1)
			delete _bbox
		}
	}
	#endregion
	
	#region character panel
	if(characterPane.open)
	{
		var _padding = 24
		var _text =  "[c_white][spr_text_basestats,0]"+comparisonText(effectiveStats.max_hp,baseStats.max_hp)
					+"[c_white][spr_text_basestats,1]"+comparisonText(effectiveStats.dmgMod,baseStats.dmgMod)
					+"[c_white][spr_text_basestats,2]"+comparisonText(effectiveStats.defense,baseStats.defense)
					+"[c_white][spr_text_basestats,3]"+comparisonText(effectiveStats.dodge,baseStats.dodge)
					+"[c_white][spr_text_basestats,4]"+comparisonText(effectiveStats.lifesteal,baseStats.lifesteal)
					+"[c_white][spr_text_basestats,5]"+comparisonText(effectiveStats.thorns,baseStats.thorns)
					+"[c_white][spr_text_basestats,6]"+comparisonText(effectiveStats.intelligence,baseStats.intelligence)
					+"[c_white][spr_text_basestats,7]"+comparisonText(effectiveStats.critChance,baseStats.critChance)
					+"[c_white][spr_text_basestats,8]"+comparisonText(effectiveStats.critDamage,baseStats.critDamage)
					
		var _id   = "characterPane"
		scribble(_text,_id).align(fa_left,fa_top)
		var _bbox = scribble(_text,_id).get_bbox(characterPane.x,characterPane.y)
	
		draw_set_alpha(0.5)
		draw_set_color(c_black)
		draw_rectangle(_bbox.x0-_padding,_bbox.y0-_padding,_bbox.x3+_padding,_bbox.y3+_padding,0)
		draw_set_alpha(1)
		draw_set_color(c_white)
		scribble(_text,_id).draw(characterPane.x,characterPane.y)
		draw_rectangle(_bbox.x0-_padding,_bbox.y0-_padding,_bbox.x3+_padding,_bbox.y3+_padding,1)
		
		_text =  "[c_white][spr_text_elements,0]"+comparisonText(effectiveStats.rFire,baseStats.rFire)
				+"[c_white][spr_text_elements,1]"+comparisonText(effectiveStats.rIce,baseStats.rIce)
				+"[c_white][spr_text_elements,2]"+comparisonText(effectiveStats.rDark,baseStats.rDark)
				+"[c_white][spr_text_elements,3]"+comparisonText(effectiveStats.rPois,baseStats.rPois)
				+"[c_white][spr_text_elements,4]"+comparisonText(effectiveStats.rElec,baseStats.rElec)
					
		_id   = "characterPane2"
		scribble(_text,_id).align(fa_left,fa_top)
		var _panelRight = _bbox.x3+_padding*2+16
		_bbox = scribble(_text,_id).get_bbox(_panelRight,characterPane.y)
	
		draw_set_alpha(0.5)
		draw_set_color(c_black)
		draw_rectangle(_bbox.x0-_padding,_bbox.y0-_padding,_bbox.x3+_padding,_bbox.y3+_padding,0)
		draw_set_alpha(1)
		draw_set_color(c_white)
		scribble(_text,_id).draw(_panelRight,characterPane.y)
		draw_rectangle(_bbox.x0-_padding,_bbox.y0-_padding,_bbox.x3+_padding,_bbox.y3+_padding,1)
		
		delete _bbox
	}
	#endregion
}

if(holding != -1)
{
	if (mouse_x<0) draw_sprite(holding.sprite,0,mouse_x+360,mouse_y)
}
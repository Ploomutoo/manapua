if(hide) exit;

draw_sprite(sprite_index,0,drawX,drawY)
//draw_text(drawX,drawY,string(actionTimer))

if(asleep)
{
	draw_sprite(spr_sleeping,0,drawX,drawY)	
}
else
{
	draw_sprite(spr_attackMeter,meterAmt,drawX,drawY)	
}

if(hp!=effectiveStats.max_hp)
{
	var barLength = 64
	draw_set_color(c_black)
	draw_rectangle(x,y+64,x+barLength,y+70,0)
	
	barLength = 64*hp/effectiveStats.max_hp
	draw_set_color(c_red)
	draw_rectangle(x,y+64,x+barLength,y+70,0)
	
	draw_set_color(c_white)
}
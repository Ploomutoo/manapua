if(iFrames>10 && iFrames%5>3) {
	
	gpu_set_fog(1,c_white,1,1);
	draw_self();
	gpu_set_fog(0,0,0,0);
	
} else draw_sprite(sprite_index,image_index,drawX,drawY);

if(hp!=max_hp)
{
	var barLength = 64
	draw_set_color(c_black)
	draw_rectangle(x,y+64,x+barLength,y+70,0)
	
	barLength = 64*hp/max_hp
	draw_set_color(c_red)
	draw_rectangle(x,y+64,x+barLength,y+70,0)
	
	draw_set_color(c_white)
}
//getting array of all sorted instances
inst_arr = [];
with(obj_depth_sort)
{
	array_push(other.inst_arr, id);
}

//sorting array according to position
array_sort(inst_arr, function(_elm1, _elm2)
{
	if(_elm1.y = _elm2.y)
	{
		return _elm1.z - _elm2.z;
	}
    return _elm1.y - _elm2.y;
}); 

//drawing objects
for(var i = 0; i < array_length(inst_arr); i++)
{
	with(inst_arr[i])
	{
		var old_x = x;
		var old_y = y;
		
		x = round(x);
		y = round(y-z);
		event_perform(ev_draw, 0);
		x = old_x;
		y = old_y;
	}
}

if(!surface_exists(fogSurface)) fogSurface = makeFogSurface()
var _topLeft = global.camObj.topLeft

surface_set_target(fogSurface)
draw_clear_alpha($f1db8f,1)
gpu_set_blendmode(bm_add)
var skySprite = spr_clouds
var skyWidth = global.camObj.camWidth/sprite_get_width(skySprite)*2
var skyHeight = global.camObj.camHeight/sprite_get_height(skySprite)*2
draw_sprite_ext(skySprite,0,0.5 * -_topLeft[0]%sprite_get_width(skySprite),0.5 * -_topLeft[1]%sprite_get_height(skySprite),skyWidth,skyHeight,0,c_white,1)
draw_sprite_ext(skySprite,0,0.2 * -_topLeft[0]%sprite_get_width(skySprite),0.2 * -_topLeft[1]%sprite_get_height(skySprite),skyWidth,skyHeight,0,c_white,0.2)

gpu_set_blendmode_ext(bm_dest_color, bm_src_alpha);
draw_tilemap(layer_tilemap_get_id(layer_get_id("ts_fog_out")),-32-_topLeft[0],-32-_topLeft[1])
gpu_set_blendmode(bm_normal)

surface_reset_target()
shader_set(shader_boil)
shader_set_uniform_f(uniTime, current_time)
draw_surface(fogSurface,_topLeft[0],_topLeft[1])
shader_reset()
#macro scrnspace_width 1280

#macro playarea_start 360
#macro playarea_width 920
#macro playarea_half 820
#macro playarea_quarter 590

#macro inventory_width 360

if(instance_exists(obj_player)) {
	lookAt = obj_player;
	x = lookAt.x
	y = lookAt.y
} else lookAt = noone;

//camera = camera_create();
camWidth = 920
camHeight = 720;

mouseLastX = mouse_x;
mouseLastY = mouse_y;

global.camera = camera_create();
global.camObj = self
view_camera[0] = global.camera;

var vm = matrix_build_lookat(x,y,-10,x,y,0,0,1,0);
var pm = matrix_build_projection_ortho(camWidth,camHeight,1,3200);

camera_set_view_mat(global.camera,vm);
camera_set_proj_mat(global.camera,pm);

camFocus = true;
screenShake = 0;

bgSprite = spr_border;
bgTiles = 1+camHeight/sprite_get_height(bgSprite);

topLeft = [0,0]
invCorner = [19,515] //top corner of the inventory pane relative to top left
invSize = [5,3]

invOn = -1
holding = -1
holdingPrev = -1

displaysize = 0
queuesize = 0
	
global.bigSprite = self
global.tick24 = 0
x = 180
y = 260

mouseOn = noone

function makeFogSurface()
{
	return(surface_create(global.camObj.camWidth,global.camObj.camHeight))
}

fogSurface = -1
uniTime = shader_get_uniform(shader_boil,"time")

image_xscale = 0.5
image_yscale = 0.5

skeleton_animation_set("idle",1)
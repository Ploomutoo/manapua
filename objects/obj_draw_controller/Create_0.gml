invCorner = [19,515] //top corner of the inventory pane relative to top left
invSize = [5,3]

invOn = -1
holding = -1
holdingPrev = -1

displaysize = 0
queuesize = 0

global.bigSprite = self
x = 180
y = 240

mouseOn = noone

function makeFogSurface()
{
	return(surface_create(global.camObj.camWidth,global.camObj.camHeight))
}

fogSurface = -1
uniTime = shader_get_uniform(shader_boil,"time")


with(obj_level_generator)
{
	other.x = nodesList[0,0]*64
	other.y = nodesList[0,1]*64
}
layer_set_visible(layer_get_id("ts_fog"),1)
defog(x/global.cellSize,y/global.cellSize)
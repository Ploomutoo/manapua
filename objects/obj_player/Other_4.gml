global.level++

with(obj_level_generator)
{
	other.x = nodesList[0,0]*64
	other.y = nodesList[0,1]*64
}

drawX = x
drawY = y
			
calcEffectiveStats()

//layer_set_visible(layer_get_id("ts_fog"),1)
var _tx = x/global.cellSize, _ty = y/global.cellSize

defog(_tx,_ty,effectiveStats.viewRadius)
visibleEnemies = getAwake()
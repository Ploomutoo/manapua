function digTile()
{
	var _tx = floor(x/global.cellSize)
	var _ty = floor(y/global.cellSize)
	
	mp_grid_clear_cell(global.collisionMap,_tx,_ty)
	
	tilemap_set(global.walls,0,_tx,_ty)
	recalcDualtileArea("ts_walls_out",_tx,_ty)
	
	defog(_tx,_ty,1)
}

function recalcDualtileArea(_layer,_x1,_y1,_x2 = _x1+2,_y2 = _y1+2)
{
	var _out
	var _layerId = layer_tilemap_get_id(layer_get_id(_layer))
	var _collisionLayer = global.walls
	
	for(var _ix = _x1; _ix < _x2; _ix++)
	{
		for(var _iy = _y1; _iy < _y2; _iy++)
		{
			_out = 0
			if(tilemap_grab(_collisionLayer,_ix  ,_iy  )) _out += 1
			if(tilemap_grab(_collisionLayer,_ix-1,_iy  )) _out += 2
			if(tilemap_grab(_collisionLayer,_ix  ,_iy-1)) _out += 4
			if(tilemap_grab(_collisionLayer,_ix-1,_iy-1)) _out += 8
			
			/*if(_out != 0)
			{
				_randMax = tilesetDoesRandom(_layer)
				
				if(_randMax > 0)	_out+=16*irandom(_randMax)
			}*/
				
			tilemap_set(_layerId,_out,_ix,_iy)
		}
	}
}
function getValidRetreat(_target)
{
	var _targetx = floor(_target.x/global.cellSize)
	var _targety = floor(_target.y/global.cellSize)
	
	var _tx = floor(x/global.cellSize)
	var _ty = floor(y/global.cellSize)
	var _originalDist = abs(_targetx-_tx) + abs(_targety-_ty)
	
	var _out = []
	var _checkDist = 0
	
	var _check = [ [_tx+1,_ty], [_tx-1,_ty], [_tx,_ty+1], [_tx,_ty-1] ]
	for(var _i = 0; _i < array_length(_check); _i++)
	{
		if(tilemap_get(global.walls,_check[_i][0],_check[_i][1])>0) continue
		
		_checkDist = abs(_targetx-_check[_i][0]) + abs(_targety-_check[_i][1])
		if(_checkDist>_originalDist) array_push(_out,_check[_i])
	}
	
	if(array_length(_out)>0) return(_out[irandom(array_length(_out)-1)])
	else return(-1)
}
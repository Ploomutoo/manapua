function getWeightToNext(_size)
{
	return((_size+1)*50)
}

function textPopup(ix,iy,text) {

	var obj = instance_create_layer(ix,iy,"effects",oPopupText);
	obj.txt = scribble("[fa_center][scale,1.5]"+text);
	return(obj)
}

function defog(_tx,_ty,_iterations)
{
	if(!layer_exists("ts_fog")) exit;

	_iterations++ //One for the road :)
	
	var _width = 1+_iterations*2
	var _gridSize = power(_width,2)
	var _grid = array_create(_gridSize,0)
	var _x,_y
	
	var _center = _iterations + _iterations*_width
	var _toCheck = [_center]
	var _nextCheck = []
	
	for(var _i = 0; _i < _iterations; _i++)
	{
		//show_debug_message("Iteration {0}",_i)
		for(var _j = 0; _j < array_length(_toCheck); _j++)
		{
			_grid[_toCheck[_j]] = 1
			
			_x = _toCheck[_j]%_width-_iterations
			_y = floor(_toCheck[_j]/_width)-_iterations
			
			//show_debug_message("Checking index {0}, coordinate {1},{2}",_toCheck[_j],_x,_y)
			if(checkFog(_tx+_x,_ty+_y))
			{
				if(_grid[_toCheck[_j]+1] = 0) array_push(_nextCheck,_toCheck[_j]+1)
				if(_grid[_toCheck[_j]-1] = 0) array_push(_nextCheck,_toCheck[_j]-1)
				if(_grid[_toCheck[_j]+_width] = 0) array_push(_nextCheck,_toCheck[_j]+_width)
				if(_grid[_toCheck[_j]-_width] = 0) array_push(_nextCheck,_toCheck[_j]-_width)	
			}	
		}
		_toCheck = _nextCheck
		_nextCheck = []
	}
}

function getVisible(_tx,_ty,_iterations)
{
	_iterations++ //One for the road :)
	
	var _out = []
	var _entity = noone
	
	var _width = 1+_iterations*2
	var _gridSize = power(_width,2)
	var _grid = array_create(_gridSize,0)
	var _x,_y
	
	var _center = _iterations + _iterations*_width
	var _toCheck = [_center]
	var _nextCheck = []
	
	for(var _i = 0; _i < _iterations; _i++)
	{
		//show_debug_message("Iteration {0}",_i)
		for(var _j = 0; _j < array_length(_toCheck); _j++)
		{
			_grid[_toCheck[_j]] = 1
			
			_x = _tx + _toCheck[_j]%_width-_iterations
			_y = _ty + floor(_toCheck[_j]/_width)-_iterations
			
			_entity = instance_position(_x*global.cellSize,_y*global.cellSize,obj_enemy)
			if(_entity != noone && !inFog(_entity.x,_entity.y))
			{
				array_push(_out,_entity) 
			}
			//show_debug_message("Checking index {0}, coordinate {1},{2}",_toCheck[_j],_x,_y)
			if(!tilemap_get(global.walls,_x,_y))
			{
				if(_grid[_toCheck[_j]+1] = 0) array_push(_nextCheck,_toCheck[_j]+1)
				if(_grid[_toCheck[_j]-1] = 0) array_push(_nextCheck,_toCheck[_j]-1)
				if(_grid[_toCheck[_j]+_width] = 0) array_push(_nextCheck,_toCheck[_j]+_width)
				if(_grid[_toCheck[_j]-_width] = 0) array_push(_nextCheck,_toCheck[_j]-_width)	
			}	
		}
		_toCheck = _nextCheck
		_nextCheck = []
	}
	return(_out)
}

function checkFog(_tx,_ty)
{
	if(_tx<0 || _tx >= global.mapSize[0] || _ty<0 || _ty >= global.mapSize[1]) return(false)
	
	tilemap_set(global.fog,0,_tx,_ty)
	return(!tilemap_get(global.walls,_tx,_ty))
}

function comparisonText(_1,_2)
{
	if(_1 = _2)
	{
		return(string(_1)+"\n")
	}
	else
	{
		return(string(_1)+"[c_orange]("+string(_2)+")\n")
	}
}
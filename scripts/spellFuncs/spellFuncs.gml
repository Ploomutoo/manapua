enum spellTargeting
{
	singleEnemy,
	allEnemy,
	selfEnch,
	selfRadius,
	cursor
}

function canLos(_desx,_desy,_range)
{
	var _iterations = _range + 1 //One for the road :)
	
	var _width = 1+_iterations*2
	var _gridSize = power(_width,2)
	var _grid = array_create(_gridSize,0)
	var _x,_y
	
	var _tx = floor(x/global.cellSize),_ty = floor(y/global.cellSize)
	var _center = _iterations + _iterations*_width
	var _toCheck = [_center]
	var _nextCheck = []
	
	for(var _i = 0; _i < _iterations; _i++)
	{
		for(var _j = 0; _j < array_length(_toCheck); _j++)
		{			
			_grid[_toCheck[_j]] = 1
			
			_x = _tx + _toCheck[_j]%_width-_iterations
			_y = _ty + floor(_toCheck[_j]/_width)-_iterations
						
			if(_x*global.cellSize = _desx && _y*global.cellSize = _desy) return(true)
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
	return(false)
}

function cancelSpell()
{
	spellCasting.selected = -1
	with(obj_spell_cursor) instance_destroy()
	soundRand(sndSpellFail)	
}

function createCursor(_x,_y,_diameter=1)
{
	var _offset = floor((_diameter-1)/2)*global.cellSize
	
	_x -= _offset
	_y -= _offset

	var _cursor = instance_create_layer(_x,_y,layer,obj_spell_cursor)
	_cursor.image_xscale = _diameter
	_cursor.image_yscale = _diameter
	
	return(_cursor)
}
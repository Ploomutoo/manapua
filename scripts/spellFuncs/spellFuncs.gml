enum spellTargeting
{
	singleEnemy,
	allEnemy,
	selfEnch,
	selfRadius,
	cursor,
	directional,
	randomized
}

enum spellScalingSources
{
	int,
	wepDamage,
	weightclass,
	weight
}

function Spell(_name) constructor
{
	targets = []
	selected = -1
	
	var _spellGrid = load_csv("spell-index.csv")
	var _index = ds_grid_value_y(_spellGrid,0,0,0,ds_grid_height(_spellGrid)-1,_name)
	
	if(_index = -1)
	{
		show_debug_message("Could not find spell {0}",_name)
		_index = 1
	}

	name = _spellGrid[# 0,_index]
	switch(_spellGrid[# 1,_index])
	{
		case "singleEnemy":
			targetStyle = spellTargeting.singleEnemy
			break;
		case "allEnemy":
			targetStyle = spellTargeting.allEnemy
			break;
		case "selfEnch":
			targetStyle = spellTargeting.selfEnch
			break;
		case "selfRadius":
			targetStyle = spellTargeting.selfRadius
			break;
		case "cursor":
			targetStyle = spellTargeting.cursor
			break;
		case "directional":
			targetStyle = spellTargeting.directional
			break;
		case "random":
			targetStyle = spellTargeting.randomized
			break;
	}
	
	element = _spellGrid[# 2,_index]
	damage = processEval(_spellGrid[# 3,_index])
	
	if(_spellGrid[# 4,_index]!="") diameter = real(_spellGrid[# 4,_index])
	else diameter = 1
	
	if(_spellGrid[# 5,_index]!="") spellRange = real(_spellGrid[# 5,_index])
	else spellRange = 1
	
	valid = 
	{
		onPlayer : true,
		onWall : true,
		onEnemy : true
	}
	var _arrayValid = string_split(_spellGrid[# 6,_index]," ",true)
	for (var _i = 0; _i < array_length(_arrayValid); _i++)
	{
		switch(_arrayValid[_i])
		{
			case "noPlayer": valid.onPlayer = false
			break;
			case "noWall": valid.onWall = false
			break;
			case "noEnemy": valid.onEnemy = false
			break;
		}
	}
	
	outBuff =
	{
		name : "",
		duration : -1,
		strength : -1
	}
	if(_spellGrid[# 7,_index]!="")
	{
		outBuff.name = _spellGrid[# 7,_index]
		if(_spellGrid[# 8,_index]!="") outBuff.duration = processEval(_spellGrid[# 8,_index])
		if(_spellGrid[# 9,_index]!="") outBuff.strength = processEval(_spellGrid[# 9,_index])
	}
	
	selfBuff =
	{
		name : "",
		duration : 0,
		strength : 0
	}
	if(_spellGrid[# 10,_index]!="")
	{
		outBuff.name = _spellGrid[# 10,_index]
		if(_spellGrid[# 11,_index]!="") outBuff.duration = processEval(_spellGrid[# 11,_index])
		if(_spellGrid[# 12,_index]!="") outBuff.strength = processEval(_spellGrid[# 12,_index])
	}
	
	description = _spellGrid[# 13,_index]
	
	cooldown =
	{
		type : "turns",
		length : 10
	}
	if(_spellGrid[# 14,_index]!="")
	{
		cooldown.type = _spellGrid[# 14,_index]
		cooldown.length = real(_spellGrid[# 15,_index])
	}
	
	var _specialString = _spellGrid[# 16,_index]
	special = string_split(_specialString," ",true)
	
	
	selfSpecial = false
	if(array_length(special)>0)
	{
		//hacky but it works
		var _firstParam = string_split(special[0],":",true)		
		var _suffix = string_copy(_firstParam[0],string_length(_firstParam[0])-3,4)
		if(_suffix = "Self") selfSpecial = true
		//mshow_debug_message("{0} has a self special value of {1} in string {2}",name,selfSpecial,_suffix)	
	}
	
	var _multicastString = string_split(_spellGrid[# 17,_index],"|",true)
	if(array_length(_multicastString) < 2) multicast = [1,0]
	// [Cast times | Delay between]
	else 
	{
		multicast = [real(_multicastString[0]),real(_multicastString[1])]
	}
	
	ds_grid_destroy(_spellGrid)
}

function processEval(_string)
{
	if (_string = "") return([0])
	
	_string = string_split(_string," ",true)
	var _out = [real(_string[0])]
	var _split = []
	var _addOut = []
	
	for(var _i = 1; _i < array_length(_string); _i++)
	{
		_split = string_split(_string[_i],"*",true,2)
		switch(_split[0])
		{
			case "int":
			_addOut[0] = spellScalingSources.int
			break;
			case "wepDamage":
			_addOut[0] = spellScalingSources.wepDamage
			break;
			case "weightclass":
			_addOut[0] = spellScalingSources.weightclass
			break;
			case "weight":
			_addOut[0] = spellScalingSources.weight
			break;
		}
		_addOut[1] = real(_split[1])
		_out[_i] = _addOut
	}
	return(_out)
}

function evalSpellDamage(_array)
{
	var _out = _array[0]
	var _getStat = 0
	var _isEnemy = false
	if(object_index = obj_enemy) _isEnemy = true
	
	for(var _i = 1; _i < array_length(_array); _i++)
	{
		if(_isEnemy)
		{
			switch(_array[_i][0])
			{
				case spellScalingSources.int:			_getStat = effectiveStats.intelligence; break;
				case spellScalingSources.weightclass:	_getStat = 1; break;
				case spellScalingSources.weight:		_getStat = 50; break;
				case spellScalingSources.wepDamage:		_getStat = effectiveStats.damage; break;
			}
		}
		else
		{
			switch(_array[_i][0])
			{
				case spellScalingSources.int:			_getStat = effectiveStats.intelligence; break;
				case spellScalingSources.weightclass:	_getStat = weightclass; break;
				case spellScalingSources.weight:		_getStat = weight; break;
				case spellScalingSources.wepDamage:		_getStat = effectiveStats.wepDamage; break;
			}
		}
		//show_debug_message("Adding {0} damage",_getStat*_array[_i][1])
		_out += _getStat*_array[_i][1]
	}
	
	return(_out)
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

function aimRandom(_range,_validStruct)
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
	
	var _out = []
	
	for(var _i = 0; _i < _iterations; _i++)
	{
		for(var _j = 0; _j < array_length(_toCheck); _j++)
		{			
			_grid[_toCheck[_j]] = 1
			
			_x = _tx + _toCheck[_j]%_width-_iterations
			_y = _ty + floor(_toCheck[_j]/_width)-_iterations
						
			if( (_validStruct.onWall	|| !tilemap_get(global.walls,_x,_y)) 
			&&	(_validStruct.onPlayer	|| instance_position(_x*global.cellSize,_y*global.cellSize,obj_player)=noone)
			&&	(_validStruct.onEnemy	|| instance_position(_x*global.cellSize,_y*global.cellSize,obj_enemy)=noone))
			{
				array_push(_out,[_x*global.cellSize,_y*global.cellSize])
			}
						
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
	
	return(_out[irandom(array_length(_out)-1)])
}
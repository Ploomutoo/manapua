function pathYtoPercent(_path,_y)
{
	var _starty = path_get_point_y(_path,0)
	var _endy = path_get_point_y(_path,path_get_number(_path)-1)
	
	_y -= _starty
	_endy -= _starty
	
	return(_y/_endy)
}

function soundRand(play, pitch_variation = 0.4) {
	
	//audio_stop_sound(play);
	var inst = audio_play_sound(play,0,0);
	audio_sound_pitch(inst,1+random_range(-pitch_variation/2,pitch_variation/2));
	return(inst);
}

function barkRand() {
	
	if(argument_count<1) exit;
	if(argument_count=1) var play = argument[0];
	else var play = argument[irandom(argument_count-1)];
	
	for(var i = argument_count-1; i>=0; i--) {
		audio_stop_sound(argument[i])
	}
	//audio_sound_pitch(play,1+random_range(-0.2,0.2))
	audio_play_sound(play,0,0)
}

function approach(_start, _end, _shift)
{
	if (_start < _end)
	{
	    return min(_start + _shift, _end); 
	}
	else
	{
	    return max(_start - _shift, _end);
	}
}

function arrFindIndex(argArr, argVal)
{
	//show_debug_message("running function")
	for(var i = 0; i < array_length(argArr); i++)
	{
		if(argArr[i] = argVal)
		{
			return i;
		}
	}
	return -1;
}

/// @desc Load text data from file.
/// @param {String} path The path to load from.
/// @returns {String|undefined} Loaded text data, or undefined if file does not exist.
function loadText(path)
{
	var _file = file_text_open_read(path)
	if(_file = -1)
	{
		show_debug_message("loadText: Could not load file: {0}", _file);
		return undefined;
	}
	var _temp_buf = "";
	while(file_text_eof(_file))
	{
		_temp_buf += file_text_read_string(_file);
		file_text_readln(_file);
	}
	file_text_close(_file);
	delete _file;
	return _temp_buf;
}

/// @desc Load json data from file.
/// @param {String}		path			The path to load from.
/// @param {Function}	filter			Filter function that processes each item. Syntax: function(key, value) -> new_value
/// @param {Bool}		no_convert If true, disable string->type conversion when parsing JSON. Default: false
/// @returns {Array|Struct|undefined}	Loaded JSON data, or undefined if file does not exist.
function loadJSON(path, filter, no_convert)
{
	var _file = loadText(path)
	if(is_undefined(_file)) return undefined;
	return json_parse(
		_file,
		filter,
		is_undefined(no_convert) ? false : no_convert
	);
}
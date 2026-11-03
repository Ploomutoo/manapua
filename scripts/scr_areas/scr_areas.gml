global.areas = {}

Area = function() constructor
{
	name = "";
	display_name = "";
	loot = new WeightedList();
	enemies = new WeightedList();
	music = [];
	overlays = [];
	modifiers = [];
};


// @desc Load areas into struct from JSON file
function loadAreas(file)
{
	var _data = loadJSON(file, undefined, false) // load area data from json
	if (is_undefined(_data))
	{
		show_debug_message("loadAreas: Error loading area JSON: {0}", file);
		return;
	}
	var _area_ids = struct_get_names(_data)
	for (var i = 0; i < array_length(_area_ids); i += 1)
	{
		var _area_id = _area_ids[i];
		var _area_data = struct_get(_data, _area_id);
		loadArea(_area_id, _area_data)
	}
	delete _data;
}

function loadArea(areaId, areaData) {
	
}
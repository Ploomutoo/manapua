global.lootTable = new WeightedPool()

/// @desc Loads a loot table from a JSON file.
/// @param {string} file The file path to load.
/// @returns {bool} True if the loot table was successfully loaded.
function loadLootTableFile(file)
{
	var _data = loadJSON(file)
	if (is_undefined(_data))
	{
		show_debug_message("loadLootTableFile: Failed to load loot table file: {0}", file)
		return
	}
  var _errors = 0
	var _tableNames = struct_get_names(_data);

  for (var i = 0; i < array_length(_tableNames); i++)
  {
    var _tableName = _tableNames[i];
		var _entries = _data[$ _tableName]
		// verify json data format
		// _entries should be a Struct = entry_name (String) : weight (Real)
		if (not is_struct(_entries))
		{
			show_debug_message("loadLootTableFile: Invalid loot table: {0}", _tableName)
      _errors++
			return
		}
		var _table = new WeightedList()
		var _entryNames = struct_get_names(_entries)
    for (var j = 0; j < array_length(_entryNames); j++)
    {
      var _k = _entryNames[j]
      var _v = _entries[$ _k]
      
			if (not is_real(_v))
			{
				show_debug_message("loadLootTableFile: Invalid loot table entry: {0}.{1} (must be Real number.)", _tableName, _k)
        _errors++
				return
			}
			_table.add(_k, _v)
		}
		if (_table.count() != struct_names_count(_entries))
		{
			show_debug_message("loadLootTableFile: Error loading loot table: {0}", _tableName)
      _errors++
			return
		}
		global.lootTable.add(_tableName, _table)
	}
  return _errors == 0
}
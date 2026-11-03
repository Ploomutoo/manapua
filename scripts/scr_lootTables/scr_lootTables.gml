global.lootTables = {}

#macro MAX_LOOT_ROLLS 5

/// @desc Loads a loot table from a JSON file.
/// @param {string} file The file path to load.
/// @returns {bool} True if the loot table was successfully loaded.
function loadLootTableFile(file)
{
	var _data = loadJSON(file)
	if (is_undefined(_data))
	{
		show_debug_message("loadLootTableFile: Failed to load loot table file: {0}", file);
		return;
	}
	var _tableKeys = struct_get_names(_data)
  var _errors = 0;
	array_foreach(_tableKeys, function(_tableName)
	{
		var _entries = _data[$ _tableName]
		// verify json data format
		// _entries should be a Struct = entry_name (String) : weight (Real)
		if (not is_struct(_entries))
		{
			show_debug_message("loadLootTableFile: Invalid loot table: {0}", _tableName);
      _errors += 1;
			return;
		}
		var _table = new WeightedList();
		struct_foreach(_entries, function(_k,_v)
		{
			if (not is_real(_v))
			{
				show_debug_message("loadLootTableFile: Invalid loot table entry: {0}.{1} (must be Real number.)", _tableName, _k);
        _errors += 1;
				return;
			}
			_table.add(_k, _v);
		});
		if (_table.count() != struct_names_count(_entries))
		{
			show_debug_message("loadLootTableFile: Error loading loot table: {0}", _tableName);
      _errors += 1;
			return;
		}
		global.lootTables[$ _tableName] = _table;
	});
  return _errors = 0;
}

/// @desc Gets a loot table via name.
/// @param {string} tableName The loot table's name.
/// @returns {Struct.WeightedList} The loot table, or undefined if it doesn't exist. 
function getLootTable(tableName)
{
    if (lootTableExists(tableName))
        return global.lootTables[$ _tableName];
    return undefined;
}

/// @desc Returns true if the loot table exists.
/// @param {string} tableName The table to check.
/// @returns {bool} True if the loot table exists.
function lootTableExists(tableName)
{
    return variable_struct_exists(global.lootTables, tableName);
}

/// @desc Rolls an entry from a loot table.
/// @param {string} tableName The table name to roll from.
/// @param {bool} flattened Should weights be combined, or rolled individually? Default: false
/// @returns {string} The result of the roll, or undedfined if unable to find a roll.
function rollFromLootTable(tableName, flattened = false)
{
	if (not lootTableExists(tableName))
		return undefined;
  var _tableTree = [tableName]
	var _currentTable = getLootTable(tableName);
	var _result = undefined;
  var _depth = 0;
	while (_depth < MAX_LOOT_ROLLS)
	{
		_result = _currentTable.roll();
		if (string_starts_with(_result, "#"))
		{
			var _newTableName = string_trim_start(_result, ["#"]);
      if (_newTableName == tableName)
      {
        // TODO: maybe handle recursive entries (re-roll?)
        show_debug_message("rollFromLootTable: Recursive entry when rolling table: {0}", tableName);
        return undefined;
      }
      if (not lootTableExists(_newTableName))
      {
        show_debug_message("rollFromLootTable: Unknown reference when rolling table: {0}, entry={1}", tableName, _newTableName);
        return undefined;
      }
      _currentTableName = _newTableName;
      _currentTable = getLootTable(_newTableName);
      _depth += 1;
      continue;
    }
    break;
	}
  if(is_undefined(_result))
    show_debug_message("rollFromLootTable: Unable to find valid roll in table: {0} (Too much recursion, max {1})", tableName, MAX_LOOT_ROLLS);
  return _result;
}
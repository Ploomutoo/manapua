WeightedList = function() constructor
{
	_entries = {}; // key : weight
	
	/// @desc Add a weighted entry.
	/// @param {String} _key The key for this entry.
	/// @param {Real|undefined} _weight The relative weight of this entry. If the key already exists, it adds to the key's existing weight. Default: 1
	/// @returns {Bool} Returns true if key was added or modified.
	static add = function(_key, _weight  = 1)
	{
		if (is_undefined(_weight))
			_weight = 1;
		if (_weight <= 0)
			return false;
		_key = string(_key);
		if (self.has(_key))
			self._entries[$ _key] += _weight;
		else
			self._entries[$ _key] = _weight;
		return true;
	};
	
	/// @desc Remove a weighted entry.
	/// @param {String} _key The key for the entry to remove.
	/// @returns {Bool} Returns true if key existed and was removed.
	static remove = function(_key)
	{
		if (not self.has(_key))	
			return false;
		struct_remove(self._entries, _key);
		return true;
	};
	
	/// @desc Remove a weighted entry.
	/// @param {String} _key The key for the entry to remove.
	/// @returns {Real} Returns the weight of the key or undefined if it doesn't exist.
	static get = function(_key)
	{
		if (self.has(_key))
			return self._entries[$ _key];
		return undefined;
	};
	
	/// @desc Check if a weighted entry exists.
	/// @param {String} _key The key for the entry to check.
	/// @returns {Bool} Returns true if key exists.
	static has = function(_key)
	{
		return variable_struct_exists(self._entries, _key);
	}
	
	/// @desc Gets the number of entries in the weighted list.
	/// @returns {Real} Returns the number of entries.
	static count = function()
	{
		return struct_names_count(self._entries);
	}
	
	/// @desc Gets the combined weight of all entries in the weighted list.
	/// @returns {Real} Returns the combined weight of all entries.
	static totalWeight = function()
	{
		var _weight = 0;
		struct_foreach(self._entries, function(_k,_v)
		{
			_weight += _v;
		});
		return _weight;
	};
	
	/// @desc Returns a random entry from this list using the weights provided.
	/// @returns {String} Returns the selected entry or undefined if the list is empty.
	static roll = function()
	{
		var _total = self.totalWeight();
		if (_total <= 0)
			return undefined;
		var _roll = random(_total);
		var _cumulative = 0;
		var _result = undefined;
		struct_foreach(self._entries, function(_k,_v)
		{
			// Add weight to sum
			_cumulative += _v;
			// If result isn't selected yet and roll is less than sum, set result
			if (is_undefined(_result) and _roll < _cumulative)
				_result = _k;
		});
		return _result;
	};
}
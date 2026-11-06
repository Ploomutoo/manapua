/// @desc A collection of string keys with relative weights.
/// @param {struct|Struct.WeightedList} [from] Optional. Initial entries or another WeightedList.
///   Format: {key: weight, ...}
function WeightedList(from = {}) constructor
{
  _entries = {};
  self.set(from);

  /// @desc Adds a weighted entry. Existing keys have their weights increased.
  /// @param {string} _key The entry key.
  /// @param {real} [_weight] Optional. The weight to add. Must be greater than 0. Default: 1
  /// @returns {bool} Whether the entry was successfully added.
  static add = function(_key, _weight = 1)
  {
    if (is_undefined(_weight))
      _weight = 1;
    if (not is_real(_weight) or _weight <= 0)
      return false;

    _key = string(_key);

    if (self.has(_key))
      self._entries[$ _key] += _weight;
    else
      self._entries[$ _key] = _weight;

    return true;
  };

  /// @desc Checks whether an entry exists.
  /// @param {string} _key The entry key.
  /// @returns {bool} Whether the entry exists.
  static has = function(_key)
  {
    _key = string(_key);
    return variable_struct_exists(self._entries, _key);
  };

  /// @desc Gets the weight of an entry.
  /// @param {string} _key The entry key.
  /// @returns {real} The entry weight, or undefined if it doesn't exist.
  static get = function(_key)
  {
    _key = string(_key);

    if (self.has(_key))
      return self._entries[$ _key];

    return undefined;
  };

  /// @desc Removes an entry.
  /// @param {string} _key The entry key.
  /// @returns {bool} Whether the entry existed and was removed.
  static remove = function(_key)
  {
    _key = string(_key);

    if (not self.has(_key))
      return false;

    struct_remove(self._entries, _key);
    return true;
  };

  /// @desc Removes all entries.
  static clear = function()
  {
    self._entries = {};
  };

  /// @desc Gets the number of entries.
  /// @returns {real} The number of entries.
  static count = function()
  {
    return struct_names_count(self._entries);
  };

  /// @desc Gets all entry keys.
  /// @returns {array<string>} An array of entry keys.
  static keys = function()
  {
    return struct_get_names(self._entries);
  };

  /// @desc Gets the sum of all entry weights.
  /// @returns {real} The combined weight of all entries.
  static totalWeight = function()
  {
    var _weight = 0;

    struct_foreach(self._entries, function(_k, _v)
    {
      _weight += _v;
    });

    return _weight;
  };

  /// @desc Selects a random entry according to its relative weight.
  /// @returns {string} The selected key, or undefined if the list is empty.
  static roll = function()
  {
    var _total = self.totalWeight();

    if (_total <= 0)
      return undefined;

    var _roll = random(_total);
    var _cumulative = 0;
    var _result = undefined;

    struct_foreach(self._entries, function(_k, _v)
    {
      _cumulative += _v;

      if (is_undefined(_result) and _roll < _cumulative)
        _result = _k;
    });

    return _result;
  };

  /// @desc Replaces the entries with those from a struct or another WeightedList.
  /// @param {struct|Struct.WeightedList} _from The source entries.
  ///   Format: {key: weight, ...}
  /// @returns {bool} Whether the entries were successfully set.
  static set = function(_from)
  {
    if (is_undefined(_from))
      return false;

    if (is_struct(_from))
    {
      self.clear();

      if (is_instanceof(_from, WeightedList))
      {
        // Copy entries from another WeightedList.
        struct_foreach(_from._entries, self.add);
      }
      else
      {
        // Validate and copy entries from a plain struct.
        var _count = 0;

        struct_foreach(_from, function(_k, _v)
        {
          if (self.add(_k, _v))
            _count += 1;
        });

        if (_count != struct_names_count(_from))
        {
          self.clear();
          show_debug_message(
            "WeightedList.set: Invalid struct. " +
            "Expected {key [string]: weight [real]}."
          );
          return false;
        }
      }

      return true;
    }

    return false;
  };

  /// @desc Creates an independent copy of this WeightedList.
  /// @returns {Struct.WeightedList} A duplicate of this list.
  static duplicate = function()
  {
    return new WeightedList(self);
  };
}
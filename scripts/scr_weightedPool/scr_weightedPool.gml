
/// @desc A collection of WeightedLists that can reference each other.
/// @param {struct|Struct.WeightedPool} [from] Optional. Initial lists or another WeightedPool.
///   Format: {name: WeightedList, ...}
function WeightedPool(from = {}) constructor
{
  _lists = {};
  self.set(from);

  /// @desc Adds a WeightedList to the pool.
  /// @param {string} _key The name of the list.
  /// @param {struct|Struct.WeightedList} _list The list to add.
  ///   The list is duplicated so the pool owns an independent copy.
  /// @returns {bool} Whether the list was successfully added.
  static add = function(_key, _list)
  {
    if (is_undefined(_list) or not is_struct(_list))
      return false;

    _key = string(_key);

    if (is_instanceof(_list, WeightedList))
      self._lists[$ _key] = _list.duplicate();
    else
      self._lists[$ _key] = new WeightedList(_list);

    return true;
  };

  /// @desc Checks whether a list exists in the pool.
  /// @param {string} _key The name of the list.
  /// @returns {bool} Whether the list exists.
  static has = function(_key)
  {
    _key = string(_key);
    return variable_struct_exists(self._lists, _key);
  };

  /// @desc Gets a list from the pool.
  /// @param {string} _key The name of the list.
  /// @returns {Struct.WeightedList} The list, or undefined if it doesn't exist.
  static get = function(_key)
  {
    _key = string(_key);

    if (self.has(_key))
      return self._lists[$ _key];

    return undefined;
  };

  /// @desc Removes a list from the pool.
  /// @param {string} _key The name of the list.
  /// @returns {bool} Whether the list existed and was removed.
  static remove = function(_key)
  {
    _key = string(_key);

    if (not self.has(_key))
      return false;

    struct_remove(self._lists, _key);
    return true;
  };

  /// @desc Removes all lists from the pool.
  static clear = function()
  {
    self._lists = {};
  };

  /// @desc Gets the number of lists in the pool.
  /// @returns {real} The number of lists.
  static count = function()
  {
    return struct_names_count(self._lists);
  };

  /// @desc Gets the names of all lists in the pool.
  /// @returns {array<string>} An array of list names.
  static keys = function()
  {
    return struct_get_names(self._lists);
  };

  /// @desc Rolls a named list, resolving references to other lists.
  /// @param {string} _key The name of the list to roll.
  /// @returns {string} The selected entry, or undefined if rolling fails.
  static roll = function(_key)
  {
    var _depth = 0;

    while (_depth <= self.count())
    {
      var _list = self.get(_key);

      if (is_undefined(_list))
      {
        show_debug_message(
          "WeightedPool.roll: list not found: {0}",
          string(_key)
        );
        return undefined;
      }

      var _entry = _list.roll();

      if (is_undefined(_entry))
        return undefined;

      // Return ordinary entries directly.
      if (string_char_at(_entry, 1) != "#")
        return _entry;

      // Resolve references by rolling the named list.
      _key = string_delete(_entry, 1, 1);
      _depth += 1;
    }

    show_debug_message(
      "WeightedPool.roll: maximum reference depth exceeded."
    );

    return undefined;
  };

  /// @desc Replaces the pool's lists with those from a struct or another WeightedPool.
  /// @param {struct|Struct.WeightedPool} _from The source lists.
  ///   Format: {name: WeightedList, ...}
  /// @returns {bool} Whether the lists were successfully set.
  static set = function(_from)
  {
    if (is_undefined(_from))
      return false;

    if (is_struct(_from))
    {
      self.clear();

      if (is_instanceof(_from, WeightedPool))
      {
        // Copy lists from another WeightedPool.
        struct_foreach(_from._lists, self.add);
      }
      else
      {
        // Validate and copy lists from a plain struct.
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
            "WeightedPool.set: Invalid struct. " +
            "Expected {name [string]: list [WeightedList]}."
          );
          return false;
        }
      }

      return true;
    }

    return false;
  };

  /// @desc Creates an independent copy of this WeightedPool.
  /// @returns {Struct.WeightedPool} A duplicate of this pool.
  static duplicate = function()
  {
    return new WeightedPool(self);
  };
};

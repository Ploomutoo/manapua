function Statblock(_name = "Random") constructor
{
	var _type = undefined
	var _gridHeight = ds_grid_height(global.enemyGenList)-1
	
	if(_name != "Random" && !ds_grid_value_exists(global.enemyGenList,0,0,0,_gridHeight,_name)) 
	{
		show_debug_message("Could not find enemy type {0}",_name)
		_name = "Random"
	}
	
	if(_name = "Random")
	{
		var _weights = []
		var _weightsOn = 0
		for(var _parser = 0; _parser < ds_grid_height(global.enemyGenList); _parser++)
		{
			if(global.enemyGenList[# 0, _parser] != "Name")
			{
				_weights[_weightsOn] = [_parser,real(global.enemyGenList[# 1, _parser])]
				_weightsOn++
			}
		}
		_type = weightedRoll(_weights)	
		_name = global.enemyGenList[# 0, _type]
	}	
	else
	{
		_type = ds_grid_value_y(global.enemyGenList,0,0,0,_gridHeight,_name)	
	}
	name = _name
	//show_debug_message("I am {0}",_name)
	
	sprite	= asset_get_index(global.enemyGenList[# 2, _type])
	max_hp	= real(global.enemyGenList[# 3, _type])
	defense	= real(global.enemyGenList[# 4, _type])
	dodge	= real(global.enemyGenList[# 5, _type])
	damage	= real(global.enemyGenList[# 6, _type])
	attackDelay	= real(global.enemyGenList[# 7, _type])
	moveDelay	= real(global.enemyGenList[# 8, _type])
	
	behavior = "Standard"
	range = 1
	dmgType = ""
	
	dmgMod = 100
	lifesteal = 0
	intelligence = 1
	thorns = 0
	critChance = 0
	critDamage = 100
	
	rFire = 0
	rIce  = 0
	rDark = 0
	rPois = 0
	rElec = 0
	
	multistrike = 1
	flight = false
	
	incomingDamage = 1
	speedAll = 1
	
	//functionss
	spell = []
	onKill = [] 
	onStrike = []
	onSeeDeath = []
	onHit = []
	onDeath = ["drop_item"]
	
	//Parse special column
	var _specials = string_split(global.enemyGenList[# 9, _type]," ")
	var _specialComponents = []
	for(var _i = 0; _i < array_length(_specials); _i++)
	{
		_specialComponents = string_split(_specials[_i],":",true,1)
		
		if(array_length(_specialComponents)<1) continue;
		
		if(struct_exists(self,_specialComponents[0]))
		{
			var _read
			var _spell
						
			switch(_specialComponents[0])
			{
				case "behavior": //single string values
				case "dmgType":
				struct_set(self,_specialComponents[0],_specialComponents[1])
				break;
				
				case "onKill":  //string arrays
				case "onStrike":
				case "onSeeDeath":
				case "onHit":
				case "onDeath":
				_read = struct_get(self,_specialComponents[0])
				array_push(_read,_specialComponents[1])
				struct_set(self,_specialComponents[0],_read)
				break;
				
				case "spell": 
				_read = struct_get(self,_specialComponents[0])
				_spell = new Spell(_specialComponents[1])
								
				array_push(_read,_spell)
				struct_set(self,_specialComponents[0],_read)
				delete _spell
				break;
				
				default: //real values
				struct_set(self,_specialComponents[0],real(_specialComponents[1]))
				break;
			}
		}
	}
}
function calcEffectiveStats()
{
	show_debug_message("Calculating effective stats from {0}",debug_get_callstack())
	
	//Default values
	var _hpRatio = hp/effectiveStats.max_hp
	effectiveStats = variable_clone(baseStats) 

	damage = effectiveStats.wepDamage
	finalDelay = effectiveStats.wepDelay
	
	armorDisparity = 0
	weaponDisparity = 0
	
	if(weight >= weightToNext)
	{	
		weight -= weightToNext
		
		weightclass++;
		weightToNext = getWeightToNext(weightclass)
		
		textPopup(x+32,y-32,"Size Up!")
	}
		
	var _equipped = getEquipped()
	for(var _i = 0; _i < array_length(_equipped); _i++) //Weapon first since it decides base delay
	{
		if(_equipped[_i].slot = "Weapon")
		{
			effectiveStats.wepDamage = _equipped[_i].damage + _equipped[_i].kineticdamage*weightclass
			effectiveStats.wepDelay = real(_equipped[_i].interval)
		
			weaponDisparity = _equipped[_i].weightclass - weightclass 
			if(weaponDisparity>0) 
			{
				preciseDisparity = 0
				if(weaponDisparity>1) preciseDisparity += weaponDisparity-1
			
				preciseDisparity += 1-weight/weightToNext
				effectiveStats.wepDelay += real(_equipped[_i].weightinterval)*preciseDisparity
			}
			
			for(var _i2 = 0; _i2<array_length(_equipped[_i].special);_i2++)
			{
				applyStat(_equipped[_i].special[_i2],_equipped[_i].specialAmt[_i2])
			}
			array_delete(_equipped,_i,1)
			break;
		}
	}
	var armorskin = ""
	for(var _i = 0; _i < array_length(_equipped); _i++) 
	{
		if(_equipped[_i].slot = "Armor")
		{
			if(_equipped[_i].weightclass != weightclass)
			{
				armorDisparity = weightclass - _equipped[_i].weightclass
				if(armorDisparity>1)
				{
					textPopup(x+32,y,"Too tight!")
					soundRand(sndRip)
					_equipped[_i].equipped = false
					continue;
				}
				else if(armorDisparity<-1)
				{
					textPopup(x+32,y,"Too loose!")
					_equipped[_i].equipped = false
					continue;
				}
				else //Tight/Loose armor penalty
				{
					effectiveStats.moveDelay += 0.2
					effectiveStats.wepDelay *= 1.2
				}
			}
		
			armorskin = _equipped[_i].skinName
		}
		else if(_equipped[_i].slot = "Spellbook")
		{
			show_debug_message("Reading spellbook {0}",_equipped[_i].name)	
			effectiveStats.library = _equipped[_i].spells
		}
		
		effectiveStats.defense += _equipped[_i].defense
		
		for(var _i2 = 0; _i2<array_length(_equipped[_i].special);_i2++)
		{
			applyStat(_equipped[_i].special[_i2],_equipped[_i].specialAmt[_i2])
		}
	}

	buffList.allBuffs = array_concat(
	buffList.floorTerminated,
	buffList.turnTerminated,
	buffList.healingTerminated,
	buffList.damageOverTime,
	buffList.killTerminated,
	buffList.attackTerminated,
	buffList.defendTerminated,
	buffList.damageTerminated)

	//scan buffs for stat changes
	for(var _i = 0; _i < array_length(buffList.allBuffs); _i++)
	{	
		applyStat(buffList.allBuffs[_i].affectedStat,buffList.allBuffs[_i].amount)	
	}

	hp = _hpRatio*effectiveStats.max_hp
	evasion = dodgeToEvasion(effectiveStats.dodge)
	defense = effectiveStats.defense
	damage  = effectiveStats.wepDamage * effectiveStats.dmgMod/100
	finalDelay = effectiveStats.wepDelay * effectiveStats.speedAll
	
	var weightskin = weightclass
	with (global.bigSprite) 
	{
		queuesize = weightskin
		var skinarray = ["0",string(displaysize)]
		if(armorskin != "") array_push(skinarray,armorskin)
	
		var skin = skeleton_skin_create("playerskin",skinarray)
		skeleton_skin_set(skin)
	
		delete skin
	}
}
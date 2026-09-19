function calcEffectiveEnemy()
{
	//Default values
	var _hpRatio = hp/effectiveStats.max_hp
	effectiveStats = variable_clone(baseStats) 

	buffList.allBuffs = array_concat(
	buffList.turnTerminated,
	buffList.damageOverTime)

	//scan buffs for stat changes	
	var _adjectives = ""
	for(var _i = 0; _i < array_length(buffList.allBuffs); _i++)
	{	
		applyStat(buffList.allBuffs[_i].affectedStat,buffList.allBuffs[_i].amount)	
		if(string_length(_adjectives)>0) _adjectives += ", " + buffList.allBuffs[_i].adjective
		else _adjectives = buffList.allBuffs[_i].adjective
	}
	if(_adjectives != "") effectiveStats.name = _adjectives + " " + baseStats.name

	hp = _hpRatio*effectiveStats.max_hp
	evasion = dodgeToEvasion(effectiveStats.dodge)

	effectiveStats.attackDelay *= effectiveStats.speedAll
	effectiveStats.moveDelay *= effectiveStats.speedAll
}
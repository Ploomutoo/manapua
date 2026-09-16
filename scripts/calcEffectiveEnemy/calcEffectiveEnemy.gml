function calcEffectiveEnemy()
{
	//Default values
	var _hpRatio = hp/effectiveStats.max_hp
	effectiveStats = variable_clone(baseStats) 

	buffList.allBuffs = array_concat(
	buffList.turnTerminated,
	buffList.damageOverTime)

	//scan buffs for stat changes
	for(var _i = 0; _i < array_length(buffList.allBuffs); _i++)
	{	
		applyStat(buffList.allBuffs[_i].affectedStat,buffList.allBuffs[_i].amount)	
	}

	hp = _hpRatio*effectiveStats.max_hp
	evasion = dodgeToEvasion(effectiveStats.dodge)

	effectiveStats.attackDelay *= effectiveStats.speedAll
	effectiveStats.moveDelay *= effectiveStats.speedAll
}
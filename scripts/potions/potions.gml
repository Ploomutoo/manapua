function potionAll()
{
	soundRand(sndQuaff)
	with(global.bigSprite) skeleton_animation_set("drink",false) 
	global.player.weight += weightgain
	
	return(true)
}

function potionCure()
{
	var _can = potionAll()
	if(_can) heal(15,global.player)
	return(_can)
}

function potionHeal()
{
	var _can = potionAll()
	if(_can) 
	{
		heal(45,global.player)
	}
	return(_can)
}

function potionStrength()
{
	var _can = potionAll()
	if(_can) 
	{
		giveBuff(global.player,"Might")
	}
	return(_can)	
}

function potionManaFrenzy()
{
	var _can = potionAll()
	if(_can) 
	{
		giveBuff(global.player,"Mana Frenzy")
	}
	return(_can)
}

function potionHaste()
{
	var _can = potionAll()
	if(_can) 
	{
		giveBuff(global.player,"Haste")
	}
	return(_can)
}

function potionDivinity()
{
	var _can = potionAll()
	if(_can) 
	{
		giveBuff(global.player,"Divinity")
	}
	return(_can)
}
function potionAll()
{
	soundRand(sndQuaff)
	with(global.bigSprite) skeleton_animation_set("drink",false) 
	global.player.weight += weightgain
}

function potionCure()
{
	potionAll()
	heal(15,global.player)
}

function potionHeal()
{
	potionAll()
	heal(45,global.player)
}

function potionStrength()
{
	potionAll()
	givePlayerBuff("Might")
}

function potionManaFrenzy()
{
	potionAll()
	givePlayerBuff("Mana Frenzy")
}

function potionHaste()
{
	potionAll()
	givePlayerBuff("Haste")
}

function potionDivinity()
{
	potionAll()	
	givePlayerBuff("Divinity")
}
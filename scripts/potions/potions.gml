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
	giveBuff(global.player,"Might")
}

function potionManaFrenzy()
{
	potionAll()
	giveBuff(global.player,"Mana Frenzy")
}

function potionHaste()
{
	potionAll()
	giveBuff(global.player,"Haste")
}

function potionDivinity()
{
	potionAll()	
	giveBuff(global.player,"Divinity")
}
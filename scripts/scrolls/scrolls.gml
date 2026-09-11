function scrollAll()
{
	soundRand(sndScroll)
	with(global.bigSprite) skeleton_animation_set("drink",false) 
}

function scrollTeleport()
{
	scrollAll()	
	//Teleport to a random node, telefrag any current occupant
}

function scrollRevelation()
{
	scrollAll()
	//Reveal entire dark layer
	tilemap_clear(global.fog,0)
}

function scrollSpareTime()
{
	scrollAll()
	//Add time to the player
}

function scrollImmolate()
{
	scrollAll()
}

function scrollBlink()
{
	scrollAll()
}

function scrollBrandWeapon()
{
	scrollAll()
}

function scrollEnchant()
{
	scrollAll()
}
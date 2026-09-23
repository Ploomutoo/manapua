var _scale = size*global.cellSize/sprite_width

image_xscale = _scale
image_yscale = _scale

fired = false;
//special = []
switch(element)
{
	case "Fire":
	soundRand(sndBoom);
	break;
	
	case "Bullet":
	soundRand(sndBullet);
	break;
	
	case "Buff":
	soundRand(sndBuff)
	break;
	
	case "Debuff":
	soundRand(sndDebuff)
	break;
	
	case "Arcane":
	sprite_index = spr_explosion_arcane;
	soundRand(sndArcane)
	break;
}
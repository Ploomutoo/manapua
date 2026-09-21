function playerTakeDamage(_dam)
{
	if(_dam<0)
	{
		
		if(abs(_dam)>effectiveStats.max_hp/5) 
		{
			soundRand(choose(death1,death2,death3),0.1)
			with(global.bigSprite) skeleton_animation_set("blockHeavy",0)
		}
		else 
		{
			soundRand(choose(ow1,ow2,ow3,ow4,ow5,ow6),0.1)
			with(global.bigSprite) skeleton_animation_set("blockLight",0)
		}
	}
	else
	{
		with(global.bigSprite) skeleton_animation_set("block",0)
	}
}
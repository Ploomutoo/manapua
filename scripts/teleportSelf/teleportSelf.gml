function teleportSelf(_target)
{
	if(!instance_exists(caster)) exit;
	//soundRand(sndWin)
	
	textPopup(caster.x+global.cellSize/2,caster.y+global.cellSize/2,"POOF!")
	
	caster.x = x
	caster.y = y
	
	caster.drawX = x
	caster.drawY = y
	
	if(caster.object_index = obj_player)
	{
		with(caster) defog(floor(x/global.cellSize),floor(y/global.cellSize),effectiveStats.viewRadius)	
	}
}
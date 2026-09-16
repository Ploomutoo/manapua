function confused()
{
	var desiredPos = [x,y]
	var _direction = irandom(1)
	desiredPos[_direction] += choose(global.cellSize,-global.cellSize)
	
	drawX += (desiredPos[0]-drawX)/2
	drawY += (desiredPos[1]-drawY)/2
		
	if(tilemap_get(global.walls,desiredPos[0]/64,desiredPos[1]/64)>0)
	{
		dealDamage(1,self)
		
		actionTimer += effectiveStats.moveDelay
		lastActionDuration = effectiveStats.moveDelay
	}
	else
	{
		var obstacle = instance_place(desiredPos[0],desiredPos[1],obj_timeaffected)
		if(obstacle = noone) obstacle = instance_place(desiredPos[0],desiredPos[1],obj_player)
		
		if(instance_exists(obstacle))
		{
			dealDamage(effectiveStats.damage,obstacle)
			
			actionTimer += effectiveStats.attackDelay
			lastActionDuration = effectiveStats.attackDelay
		}  
		else
		{
			x = desiredPos[0]
			y = desiredPos[1]
			
			actionTimer += effectiveStats.moveDelay
			lastActionDuration = effectiveStats.moveDelay
		}
	}
}
if(tileDistObj(self,target)>1)
{
	if(mp_grid_path(global.collisionMap,targetPath,x,y,target.x,target.y,0))
	{
		var _dist = path_get_length(targetPath)/global.cellSize
		if(_dist>10 || inFog(x,y))
		{
			//soundRand(sndSleep)
			asleep = true
		}
		else if(_dist>1)
		{
			var desiredPos = [path_get_point_x(targetPath,1)-32,path_get_point_y(targetPath,1)-32]
			var obstacle = instance_place(desiredPos[0],desiredPos[1],obj_timeaffected)
			if(instance_exists(obstacle))
			{
				
			}
			else
			{
				x = desiredPos[0]
				y = desiredPos[1]
			}
		}
	}
	actionTimer += moveDelay
}
else 
{
	dealDamage(damage,target)
	actionTimer += attackDelay
}
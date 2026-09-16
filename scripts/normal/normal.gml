function normal()
{
	var _tileDist = tileDistObj(self,target)
	var _canLos = true
	if(effectiveStats.range>1) _canLos = canLos(target.x,target.y,effectiveStats.range)

	if(_tileDist > effectiveStats.range || !_canLos)
	{
		if(mp_grid_path(global.collisionMap,targetPath,x,y,target.x,target.y,0))
		{
			var _dist = path_get_length(targetPath)/global.cellSize
			if(_dist>8 || inFog(x,y))
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
		actionTimer += effectiveStats.moveDelay
		lastActionDuration = effectiveStats.moveDelay
	}
	else 
	{
		dealDamage(effectiveStats.damage,target)
	
		if(_tileDist>1)
		{
			instance_create_layer(x,y,"effects",obj_effect_tracer,
			{
				girth : 5,
				points : 
				{
					x1 : x+global.cellSize/2,
					y1 : y+global.cellSize/2,
					x2 : target.x+global.cellSize/2,
					y2 : target.y+global.cellSize/2
				}
			})
			soundRand(sndEnemyRanged)
		}
		else
		{
			drawX += (target.x-drawX)/2
			drawY += (target.y-drawY)/2
		}
	
		actionTimer += effectiveStats.attackDelay
		lastActionDuration = effectiveStats.attackDelay
	}
}
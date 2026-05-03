#region setting inputs
inp_x = keyboard_check_pressed(ord("D")) - keyboard_check_pressed(ord("A"));
inp_y = keyboard_check_pressed(ord("S")) - keyboard_check_pressed(ord("W"));
inp_move = abs(inp_x) || abs(inp_y);
#endregion

if(drawX!=x)
{
	
	drawX += (x-drawX)/5	
}
if(drawY!=y)
{
	
	drawY += (y-drawY)/5	
}

var desiredPos = [x,y]
if(inp_move && waitTime = 0)
{
	if(abs(inp_x)>0)
	{
		desiredPos[0] += 64*inp_x
	}
	else 
	{
		desiredPos[1] += 64*inp_y
	}
	
	
	var obstacle = instance_place(desiredPos[0],desiredPos[1],obj_timeaffected)
	if(instance_exists(obstacle))
	{
		dealDamage(damage,obstacle)
		soundRand(sndCombat)
	
		clock(attackDelay)
	}
	else
	{
		var _tilex = floor(desiredPos[0]/global.cellSize)
		var _tiley = floor(desiredPos[1]/global.cellSize)
		
		if(tilemap_get(global.walls,_tilex,_tiley) = 0)
		{
			x = desiredPos[0]
			y = desiredPos[1]
			
			drawX += (x-drawX)/2
			drawY += (y-drawY)/2
						
			defog(_tilex,_tiley)
		}
		clock(moveDelay)
	}
}

event_inherited()
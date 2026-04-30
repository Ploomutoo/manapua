#region setting inputs
inp_x = keyboard_check_pressed(ord("D")) - keyboard_check_pressed(ord("A"));
inp_y = keyboard_check_pressed(ord("S")) - keyboard_check_pressed(ord("W"));
inp_move = abs(inp_x) || abs(inp_y);
#endregion

var desiredPos = [x,y]
if(inp_move && alarm[0]<=0)
{
	if(abs(inp_x)>0)
	{
		desiredPos[0] += 64*inp_x
	}
	else 
	{
		desiredPos[1] += 64*inp_y
	}
	alarm[0] = 10
	
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
			
			defog(_tilex,_tiley)
		}
		clock(1)
	}
}

event_inherited()
#region setting inputs
var inp_x = keyboard_check_pressed(ord("D")) - keyboard_check_pressed(ord("A"));
var inp_y = keyboard_check_pressed(ord("S")) - keyboard_check_pressed(ord("W"));
var inp_move = abs(inp_x) || abs(inp_y);
#endregion

if(drawX!=x)
{
	drawX += (x-drawX)/5	
}
if(drawY!=y)
{
	drawY += (y-drawY)/5	
}

if(keyboard_check(vk_shift)) exit;
//Do not execute remaining code if trying to activate a cheat

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
	
	var obstacle = noone
	var _check = [0,0]
	
	for(var _i = 1; (_i <= effectiveStats.reach && obstacle = noone); _i++)
	{
		_check = [x+64*inp_x*_i,y+64*inp_y*_i]
		obstacle = instance_place(_check[0],_check[1],obj_timeaffected)
		
		if(tilemap_get(global.walls,_check[0]/64,_check[1]/64)>0) break;
	}
	
	if(instance_exists(obstacle))
	{
		dealDamage(damage,obstacle,effectiveStats.multistrike)
		clock(finalDelay)
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
		clock(effectiveStats.moveDelay * effectiveStats.speedAll)
	}
}

if(keyboard_check_pressed(ord("C"))) //Toggle Character Pane
{
	characterPane.open = !characterPane.open	
}

if(keyboard_check_pressed(ord("E"))) //Eat item off the floor
{
	var _item = instance_place(x,y,obj_item_empty)

	if(_item!=noone)
	{
		if(_item.item.slot = "Consumable")
		{
			_item.item.funcUse()
			
			calcEffectiveStats()
			instance_destroy(_item)	
		}
	}
}
else if(keyboard_check_pressed(ord("G"))) //Pick up floor item or go up stairs
{
	var _item = instance_place(x,y,obj_item_empty)

	if(_item!=noone)
	{
		var _i = 0
		while(inventory[_i]!=-1)
		{
			_i++
			if(_i>=invSize) 
			{ //inventory full :(
				soundRand(choose(invFull1,invFull2),0.1)
				with(global.bigSprite) skeleton_animation_set("no",0)
				exit;	
			}
		}
		inventory[_i] = _item.item
		soundRand(choose(get1,get2,get4,get5),0.1)
		instance_destroy(_item)	
	}
	else
	{
		var _stairs = instance_place(x,y,obj_stairs)
	
		if(_stairs != noone)
		{
			room_goto(room)
			exit;
		}
	
		//No item or stairs found
		soundRand(choose(invFull1,invFull2),0.1)
		with(global.bigSprite) skeleton_animation_set("no",0)
	}
}
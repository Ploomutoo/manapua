if(drawX!=x)
{
	drawX += (x-drawX)/5	
}
if(drawY!=y)
{
	drawY += (y-drawY)/5	
}

if(keyboard_key != 0) 
{
	if(keyboard_check_pressed(keyboard_key)) 
	{
		inputBuffer = keyboard_key
		//show_debug_message("Input {0}",inputBuffer)
	}
}

if(keyboard_check(vk_shift)) exit;
//Do not execute remaining code if trying to activate a cheat

if(waitTime > 0 || alarm[0] > 0) exit;
//Do not execute remaining code if it is the enemy turn

var inp_x = 0, inp_y = 0
switch(inputBuffer)
{
	case ord("D"): inp_x++; break;
	case ord("A"): inp_x--; break;
	case ord("S"): inp_y++; break;
	case ord("W"): inp_y--; break;
}
var inp_move = abs(inp_x) || abs(inp_y);

if(keyboard_check_pressed(inputBuffer)) 
{
	if(inputBuffer >= ord("1") && inputBuffer <= ord("9")) 
	{
		var _num = inputBuffer - ord("1")
		if(_num < array_length(effectiveStats.library)) 
		{
			delete spellCasting
			
			libraryOn = _num
			//show_debug_message("Readying spell {0}",effectiveStats.library[libraryOn])
			spellCasting = new Spell(effectiveStats.library[libraryOn])
			textPopup(x+global.cellSize/2,y+global.cellSize/2,effectiveStats.library[libraryOn])
		}
	}
}

if(spellCasting.selected != -1)
{
	switch(spellCasting.targetStyle)
	{
		case spellTargeting.directional:
		if(inp_move)
		{
			var _desiredPos = [
			x + inp_x*global.cellSize,
			y + inp_y*global.cellSize]
			
			spellCasting.targets[0].x = _desiredPos[0]
			spellCasting.targets[0].y = _desiredPos[1]
			
			if(inp_x > 0) //right
			{
				spellCasting.targets[1].image_xscale = spellCasting.spellRange
				spellCasting.targets[1].image_yscale = 1
			}
			else if(inp_x < 0) //left
			{
				spellCasting.targets[1].image_xscale = spellCasting.spellRange
				spellCasting.targets[1].image_yscale = 1
				_desiredPos[0] = x - spellCasting.spellRange*global.cellSize
			}
			else if(inp_y > 0) //down
			{
				spellCasting.targets[1].image_xscale = 1
				spellCasting.targets[1].image_yscale = spellCasting.spellRange
			}
			else if(inp_y < 0) //up
			{
				spellCasting.targets[1].image_xscale = 1
				spellCasting.targets[1].image_yscale = spellCasting.spellRange
				_desiredPos[1] = y- spellCasting.spellRange*global.cellSize
			}
									
			spellCasting.targets[1].x = _desiredPos[0]
			spellCasting.targets[1].y = _desiredPos[1]
			
		}
		break;
		case spellTargeting.singleEnemy:
		if(inp_x>0 || inp_y>0)
		{
			spellCasting.selected++;
			if(spellCasting.selected>=array_length(spellCasting.targets)) spellCasting.selected = 0
		}
		else if(inp_x<0 || inp_y<0)
		{
			spellCasting.selected--;
			if(spellCasting.selected<0) spellCasting.selected = array_length(spellCasting.targets)-1
		}
		break;
		case spellTargeting.cursor:
		if(inp_move)
		{
			var _desiredPos = [spellCasting.targets[0].x + inp_x*global.cellSize,
			spellCasting.targets[0].y + inp_y*global.cellSize]
			
			var _offset = floor((spellCasting.diameter-1)/2)*global.cellSize
			
			if(canLos(_desiredPos[0]+_offset,_desiredPos[1]+_offset,spellCasting.spellRange))
			{
				spellCasting.targets[0].x = _desiredPos[0]
				spellCasting.targets[0].y = _desiredPos[1]
			}
		}
		break;
	}
	
	if(inputBuffer = vk_space) //cast spell
	{
		var _validCast = true;
		var _center = [spellCasting.targets[spellCasting.selected].x,spellCasting.targets[spellCasting.selected].y]
		if(spellCasting.diameter>1)
		{
			var _offset = floor((spellCasting.diameter-1)/2)*global.cellSize
			_center[0] += _offset
			_center[1] += _offset
		}
		
		var _targetList = [spellCasting.targets[spellCasting.selected]]
		switch(spellCasting.targetStyle)
		{
			case spellTargeting.cursor:
			case spellTargeting.directional:
			if(!spellCasting.valid.onPlayer 
			&& instance_position(_center[0],_center[1],obj_player)) _validCast = false
			
			if(!spellCasting.valid.onEnemy
			&& instance_position(_center[0],_center[1],obj_enemy)) _validCast = false
			
			if(!spellCasting.valid.onWall
			&& tilemap_get_at_pixel(global.walls,_center[0],_center[1])>0) _validCast = false
			break;
			
			case spellTargeting.allEnemy:
			_targetList = spellCasting.targets
			break;
		}
		
		if(_validCast)
		{
			if(spellCasting.targetStyle = spellTargeting.directional) 
			{
				var _vector = [spellCasting.targets[0].x-x,spellCasting.targets[0].y-y]
				var _place = []
				for(var _i = 0; _i < spellCasting.spellRange; _i++)
				{
					_place = [spellCasting.targets[spellCasting.selected].x+_vector[0]*_i,spellCasting.targets[spellCasting.selected].y+_vector[1]*_i]
					if(!spellCasting.valid.onWall
					&& tilemap_get_at_pixel(global.walls,_place[0],_place[1])>0) break;
					
					createSpellInst(_place[0],_place[1],spellCasting,self,_i*5)
				}
			}
			else
			{
				for(var _i = 0; _i < array_length(_targetList); _i++)
				{
					createSpellInst(_targetList[_i].x,_targetList[_i].y,spellCasting,self)
				}
			}
			if(spellCasting.selfBuff.name != "") giveBuff(self,spellCasting.selfBuff.name,
				evalSpellDamage(spellCasting.selfBuff.duration),
				evalSpellDamage(spellCasting.selfBuff.strength))
		}
		else soundRand(sndSpellFail)
		
		cancelSpell()
	}
}
else
{
	var desiredPos = [x,y]
	if(inp_move)
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
	
		if(instance_exists(obstacle)) //Hitting stuff
		{
			dealDamage(damage,obstacle,effectiveStats.multistrike)
			drawX += (obstacle.x-drawX)/2
			drawY += (obstacle.y-drawY)/2
			
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
						
				defog(_tilex,_tiley,effectiveStats.viewRadius)
			}
			clock(effectiveStats.moveDelay * effectiveStats.speedAll)
		}
	}
}

if(inputBuffer = ord("C")) //Toggle Character Pane
{
	characterPane.open = !characterPane.open	
	if(spellCasting.selected != -1) cancelSpell()
}

if(inputBuffer = ord("M")) //Aim spell
{
	characterPane.open = false
	spellCasting.targets = []
	
	if(spellCasting.selected != -1) 
	{
		soundRand(sndSpellFail)	
		cancelSpell()
	}
	else 
	{
		switch(spellCasting.targetStyle)
		{
			case spellTargeting.singleEnemy:
			case spellTargeting.allEnemy:
			spellCasting.targets = getVisible(floor(x/global.cellSize),floor(y/global.cellSize),spellCasting.spellRange)
			break;
			case spellTargeting.selfEnch:
			case spellTargeting.randomized:
			spellCasting.targets = [self]
			break;
			case spellTargeting.selfRadius:
			case spellTargeting.cursor:
			spellCasting.targets = [createCursor(x,y,spellCasting.diameter)]
			break;
			case spellTargeting.directional:
			if(spellCasting.spellRange>1) spellCasting.targets = [createCursor(x,y,spellCasting.diameter),createCursor(x,y,spellCasting.diameter)]
			else spellCasting.targets = [createCursor(x,y,spellCasting.diameter)]
			break;
		}
		if(array_length(spellCasting.targets)>0) 
		{	
			soundRand(sndSpellTarget)
			spellCasting.selected = 0
		}
		else
		{
			soundRand(sndSpellFail)	
		}
	}	
}

if(inputBuffer = ord("E")) //Eat item off the floor
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
else if(inputBuffer = ord("G")) //Pick up floor item or go up stairs
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
				inputBuffer = 0
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
			nextLevel()
			exit;
		}
	
		//No item or stairs found
		soundRand(choose(invFull1,invFull2),0.1)
		with(global.bigSprite) skeleton_animation_set("no",0)
	}
}

inputBuffer = 0
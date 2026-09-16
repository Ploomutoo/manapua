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
	
	if(keyboard_check_pressed(vk_space)) //cast spell
	{
		var _validCast = true;
		var _center = [spellCasting.targets[spellCasting.selected].x,spellCasting.targets[spellCasting.selected].y]
		if(spellCasting.diameter>1)
		{
			var _offset = floor((spellCasting.diameter-1)/2)*global.cellSize
			_center[0] += _offset
			_center[1] += _offset
		}
		
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
		}
		
		if(_validCast)
		{
			var _caster = self
			if(spellCasting.targetStyle = spellTargeting.directional) 
			{
				var _vector = [spellCasting.targets[0].x-x,spellCasting.targets[0].y-y]
				var _place = []
				for(var _i = 0; _i < spellCasting.spellRange; _i++)
				{
					_place = [spellCasting.targets[spellCasting.selected].x+_vector[0]*_i,spellCasting.targets[spellCasting.selected].y+_vector[1]*_i]
					if(!spellCasting.valid.onWall
					&& tilemap_get_at_pixel(global.walls,_place[0],_place[1])>0) break;
					
					instance_create_layer(_place[0],_place[1],"effects",obj_spell_aoe,
					{
						size : spellCasting.diameter,
						caster : _caster,
						hitsPlayer : true,
						damage : 25,
					})
				}
			}
			else
			{
				var _spell = instance_create_layer(spellCasting.targets[spellCasting.selected].x,spellCasting.targets[spellCasting.selected].y,"effects",obj_spell_aoe,
				{
					size : spellCasting.diameter,
					caster : _caster,
					hitsPlayer : true,
					damage : 25,
				})
			}
		}
		else soundRand(sndSpellFail)
		
		cancelSpell()
	}
}
else
{
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

if(keyboard_check_pressed(ord("C"))) //Toggle Character Pane
{
	characterPane.open = !characterPane.open	
	if(spellCasting.selected != -1) cancelSpell()
}

if(keyboard_check_pressed(ord("M"))) //Aim spell
{
	characterPane.open = false
	
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
			spellCasting.targets = [self]
			break;
			case spellTargeting.selfRadius:
			case spellTargeting.cursor:
			spellCasting.targets = [createCursor(x,y,spellCasting.diameter)]
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
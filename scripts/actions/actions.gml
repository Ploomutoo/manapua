function advance()
{
	//if not adjacent, move closer
	if(mp_grid_path(global.collisionMap,targetPath,x,y,target.x,target.y,0))
	{
		var _dist = path_get_length(targetPath)/global.cellSize
		if(_dist>8 || inFog(x,y))
		{
			sleep()
			exit;
		}

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
	actionTimer += effectiveStats.moveDelay
	lastActionDuration = effectiveStats.moveDelay
}

function retreat(_coords)
{
	//if adjacent to target, find a tile further from the target and try to move there
	
	x = _coords[0]*global.cellSize
	y = _coords[1]*global.cellSize
	
	actionTimer += effectiveStats.moveDelay
	lastActionDuration = effectiveStats.moveDelay
}

function rangedAttack(_target)
{
	//if in range, hit target
	dealDamage(effectiveStats.damage,_target)
	
	//visuals
	instance_create_layer(x,y,"effects",obj_effect_tracer,
	{
		girth : 5,
		points : 
		{
			x1 : x+global.cellSize/2,
			y1 : y+global.cellSize/2,
			x2 : _target.x+global.cellSize/2,
			y2 : _target.y+global.cellSize/2
		}
	})
	soundRand(sndEnemyRanged)
	
	actionTimer += effectiveStats.attackDelay
	lastActionDuration = effectiveStats.attackDelay
}

function meleeAttack(_isWeak = false)
{
	var _damage = effectiveStats.damage
	if(_isWeak) _damage *= 0.5
	
	dealDamage(_damage,target)
	//runArray(effectiveStats.onStrike,[target])
	
	//visuals
	drawX += (target.x-drawX)/2
	drawY += (target.y-drawY)/2
	
	actionTimer += effectiveStats.attackDelay
	lastActionDuration = effectiveStats.attackDelay
}

function cast(_spell)
{
	//if in range, blast target
	//show_debug_message("{0} casts {1}!",effectiveStats.name,_spell.name)
	
	var _caster = self
	var _damage = evalSpellDamage(_spell.damage)
	var _outBuffEval = 
	{
		name : _spell.outBuff.name,
		duration : -1,
		strength : -1
	}
	if(_outBuffEval.name != "") 
	{
		if(is_array(_spell.outBuff.duration)) _outBuffEval.duration = evalSpellDamage(_spell.outBuff.duration)
		if(is_array(_spell.outBuff.strength)) _outBuffEval.strength = evalSpellDamage(_spell.outBuff.strength)
	}
	
	var _aim = []
	switch(_spell.targetStyle)
	{
		case spellTargeting.randomized:
		_aim = aimRandom(_spell.spellRange,_spell.valid)
		break;
		
		default:
		_aim = [target.x,target.y]
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
		break;
	}
	
	var _sprite
	var _sound
	switch(_spell.element)
	{
		case "Fire":
		_sprite = spr_explosion
		_sound = sndBoom
		break;
		
		default:
		_sprite = spr_explosion_arcane
		_sound = sndArcane
		break;
	}
	
	instance_create_layer(_aim[0],_aim[1],"effects",obj_spell_aoe,
	{
		sprite_index : _sprite,
		size : _spell.diameter,
		caster : _caster,
		hitsPlayer : true,
		damage : _damage,
		outBuff : _outBuffEval,
		special : _spell.special
	})
	
	soundRand(_sound)
	
	actionTimer += 1
	lastActionDuration = 1
}

function stumble()
{
	//move/attack randomly
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

function sleep()
{
	soundRand(sndSleep)
	asleep = true
	
	actionTimer += 1
	lastActionDuration = 1
}
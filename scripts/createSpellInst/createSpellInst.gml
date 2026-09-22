function createSpellInst(_x,_y,_spellStruct,_caster)
{
	var _hitsPlayer = false
	if(_caster.object_index = obj_enemy || _spellStruct.valid.onPlayer) _hitsPlayer = true 
	
	var _damage = evalSpellDamage(_spellStruct.damage)
			
	var _outBuffEval = 
	{
		name : _spellStruct.outBuff.name,
		duration : -1,
		strength : -1
	}
	if(_outBuffEval.name != "") 
	{
		if(is_array(_spellStruct.outBuff.duration)) _outBuffEval.duration = evalSpellDamage(_spellStruct.outBuff.duration)
		if(is_array(_spellStruct.outBuff.strength)) _outBuffEval.strength = evalSpellDamage(_spellStruct.outBuff.strength)
	}
	
	var _tracer = "Bullet"
	
	var _castStruct =
	{
		size : _spellStruct.diameter,
		caster : _caster,
		hitsPlayer : _hitsPlayer,
		damage : _damage,
		outBuff : _outBuffEval,
		special : _spellStruct.special,
		element : _spellStruct.element,
		selfSpecial : _spellStruct.selfSpecial,
		tracer : _tracer
	}
	
	var _multi = _spellStruct.multicast[0]
	global.player.alarm[0] = 1 + _multi*_spellStruct.multicast[1]
	
	while(_multi>0)
	{
		_multi--;
		
		var _aim = [_x,_y]
		if(_spellStruct.targetStyle = spellTargeting.randomized) with(_caster) _aim = aimRandom(_spellStruct.spellRange,_spellStruct.valid)
		
		_caster.multiTimeSource[_multi] = time_source_create(time_source_game,1 + _multi*_spellStruct.multicast[1],time_source_units_frames,createSpellInstJr,[_aim[0],_aim[1],_castStruct])
		time_source_start(multiTimeSource[_multi])
	}
	//createSpellInstJr(_x,_y,_spellStruct,_caster)
}

function createSpellInstJr(_x,_y,_castStruct)
{
	if(_castStruct.tracer != "None")
	{
		var _girth, _decay, _color, _variance
		switch(_castStruct.tracer)
		{
			case "Bullet":
			_girth = 3
			_decay = 0.8
			_color = c_white
			_variance = [irandom_range(-16,16),irandom_range(-16,16)]
			break;
			
			default:
			_girth = 5
			_decay = 0.8
			_color = c_white
			_variance = [0,0]
			break;
		}
		instance_create_layer(_x,_y,"effects",obj_effect_tracer,
		{
			girth : _girth,
			decay : _decay,
			color : _color,
			points : 
			{
				x1 : _castStruct.caster.x+global.cellSize/2,
				y1 : _castStruct.caster.y+global.cellSize/2,
				x2 : _x+global.cellSize/2+_variance[0],
				y2 : _y+global.cellSize/2+_variance[1]
			}
		})
	}
	
	instance_create_layer(_x,_y,"effects",obj_spell_aoe,
	{
		size : _castStruct.size,
		caster : _castStruct.caster,
		hitsPlayer : _castStruct.hitsPlayer,
		damage : _castStruct.damage,
		outBuff : _castStruct.outBuff,
		special : _castStruct.special,
		element : _castStruct.element,
		selfSpecial : _castStruct.selfSpecial
	})
}
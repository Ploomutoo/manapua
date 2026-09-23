function dealDamage(_damage,_target,_multi = 1)
{
	if(!instance_exists(_target)) exit;
	
	var _source = other
	var _mult = effectiveStats.incomingDamage
	var _evade = _target.evasion
	var _crit = 0
	var _critMult = 100
	

	if(object_index = obj_player)
	{
		if(_target.asleep)
		{
			//soundRand(sndCrit)
			_crit = 100
			_evade = 0
			_target.asleep = false
		}
		else
		{
			_crit = effectiveStats.critChance	
		}
		_critMult = effectiveStats.critDamage
	}
	
	global.player.alarm[0] = 1 + _multi*5
	while(_multi>0)
	{
		_multi--;
		multiTimeSource[_multi] = time_source_create(time_source_game,1 + 5*_multi,time_source_units_frames,dealDamageInstance,[_damage,_target,self,_mult,_evade,_crit,_critMult,"Melee"])
		time_source_start(multiTimeSource[_multi])
	}
}

function dealDamageInstance(_damage,_target,_executor,_mult,_evade,_crit,_critMult,_element)
{	
	if(!instance_exists(_target)) 
	{
		soundRand(sndSwing)
		exit;
	}
	
	if(_evade > 0 && _evade > irandom(100))
	{
		soundRand(choose(fart1,fart2,fart3,fart4))
		textPopup(_target.x,_target.y,"MISS!")
		exit;
	}

	var _dam = min(0,random(_target.effectiveStats.defense)-random_range(_damage/2,_damage))
	if(_crit != 0 && _crit > irandom(100))
	{
		_mult *= 1 + _critMult/100	
		soundRand(sndCrit)
	}
	
	//Calculate resistances
	var _resistance = 0
	switch(_element)
	{
		case "Fire":
			_resistance = _target.effectiveStats.rFire
			break;
		case "Ice":
			_resistance = _target.effectiveStats.rIce
			break;
		case "Dark":
			_resistance = _target.effectiveStats.rDark
			break;
		case "Pois":
			_resistance = _target.effectiveStats.rPois
			break;
		case "Elec":	
			_resistance = _target.effectiveStats.rDark
			break;
	}
	_resistance = clamp(_resistance*20,-60,60)
	_mult *= (1-_resistance/100)
	
	_dam *= _mult	
	if(_mult >= 1) _dam = ceil(_dam)
	else _dam = floor(_dam)
	
	if(_dam>=0) soundRand(choose(fart1,fart2,fart3,fart4))
	else soundRand(sndSwing)
	
	textPopup(_target.x,_target.y,string(_dam))
	
	_target.hp += _dam
	
	with(_target) runArray(effectiveStats.onHit,[_dam])
	with(_executor) runArray(effectiveStats.onStrike,[_target])
	
	if(_executor!=noone)
	{
		var _lifesteal = round(random(_executor.effectiveStats.lifesteal))
		if(_lifesteal > 0) heal(_lifesteal,_executor)
	}
	
	if(_target.hp<=0)
	{
		with(_target) runArray(effectiveStats.onDeath)		
		if(_executor != noone) with(_executor) runArray(effectiveStats.onKill)
		
		instance_destroy(_target)
	}
}
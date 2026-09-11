function Item() constructor
{
	//Accepts potion, weapon, armor, ring
	slot = ""
	name = "Placeholder"
	size = ""
	sprite = spr_item_placeholder
	defense = 0
	damage	= 0
	equipped	= false
	consumable	= false
	special = [""]
	specialAmt = [0]
	tooltip = ""
	funcUse = function()
	{
		toggleEquipped(global.player)
	}
}

function specialTooltip(_special,_amt)
{
	var _out = ""
	for(var _i = 0; _i < array_length(_special); _i++)
	{
		_out += "\n[spr_text_special] " + _special[_i] + " " + string(_amt[_i])
	}
	return(_out)
}

function generateTooltip(_item)
{
	var _tooltip = _item.name
	if(_item.damage != 0)
	{
		_tooltip += "\n[spr_text_damage] "+ string(_item.damage)
	}
	if(_item.slot = "Weapon")
	{
		if(_item.kineticdamage!=0)	_tooltip += "\n[spr_text_kinetic] "+ string(_item.kineticdamage)
		_tooltip += "\n[spr_text_interval] "+ string(_item.interval)
		if(ceil(_item.weightinterval)!=0)	
		{
			_tooltip = "[spr_text_weight,"+string(_item.weightclass)+"] " + _tooltip
			_tooltip += "\n[spr_text_weight_interval] "+ string(_item.weightinterval)
		}
		
		if(_item.special[0]!="") _tooltip += specialTooltip(_item.special,_item.specialAmt)
	}
	else if(_item.slot = "Consumable")
	{
		if(_item.special[0] != "") _tooltip += "\nAdds " + string(_item.specialAmt[0]) + " " + _item.special[0]
		_tooltip += "\nHeals for " + string(_item.healing)+". Gain " + string(_item.weightgain) + " lbs"	
	}
	else if(_item.slot = "Armor")
	{
		_tooltip += "\n[spr_text_defense] "+ string(_item.defense)
		_tooltip = "[spr_text_weight,"+string(_item.weightclass)+"] " + _tooltip
		
		if(_item.special[0]!="") _tooltip += specialTooltip(_item.special,_item.specialAmt)
	}
	else if(_item.slot = "Ring" || _item.slot = "Amulet")
	{
		if(_item.special[0]!="") _tooltip += specialTooltip(_item.special,_item.specialAmt)
	}
	
	return(_tooltip)
}

function eatFood()
{
	var _i = 0
	switch(special[_i])
	{
		case "Max HP":
		global.player.baseStats.max_hp += specialAmt[_i]
		break;
		case "Damage":
		global.player.baseStats.dmgMod += specialAmt[_i]
		break;
		case "Defense":
		global.player.baseStats.defense += specialAmt[_i]
		break;
		case "Dodge":
		global.player.baseStats.dodge += specialAmt[_i]
		break;
		case "Lifesteal":
		global.player.baseStats.lifesteal += specialAmt[_i]
		break;
		case "Intelligence":
		global.player.baseStats.intelligence += specialAmt[_i]
		break;
		case "Thorns":
		global.player.baseStats.thorns += specialAmt[_i]
		break;
		case "Crit Rate":
		global.player.baseStats.critChance += specialAmt[_i]
		break;
		case "Crit Damage":
		global.player.baseStats.critDamage += specialAmt[_i]
		break;
		case "Fire Resist":
		global.player.baseStats.rFire += specialAmt[_i]
		break;
		case "Ice Resist":
		global.player.baseStats.rIce += specialAmt[_i]
		break;
		case "Dark Resist":
		global.player.baseStats.rDark += specialAmt[_i]
		break;
		case "Pois Resist":
		global.player.baseStats.rPois += specialAmt[_i]
		break;
		case "Elec Resist":
		global.player.baseStats.rElec += specialAmt[_i]
		break;		
	}
	
	if(healing>0) heal(healing,global.player)
	else if(healing<0) hurt(healing,global.player)
	
	with(global.bigSprite) skeleton_animation_set("eat",0)
	global.player.weight += weightgain
	global.player.weight = max(0,global.player.weight)
}

function drawItemText(_item,_x,_y)
{
	if(_item = -1) exit;
	
	var _text = _item.tooltip
	var _outlineColor = c_white
	
	if(_item.slot = "Weapon" && _item.weightclass > global.player.weightclass) 
	{
		var _disparity = _item.weightclass - global.player.weightclass
			
		if(_disparity>2) _text = "Very Heavy " + _text
		else _text = "Heavy " + _text
			
		_outlineColor = c_yellow
	}
	else if(_item.slot = "Armor")
	{
		var _disparity = _item.weightclass - global.player.weightclass
			
		switch(clamp(round(_disparity),-2,2))
		{
			case -2:
			_text = "Puny " + _text
			_outlineColor = c_red
			break;
			case -1:
			_text = "Tight " + _text
			_outlineColor = c_yellow
			break;
			case 0:

			break;
			case 1:
			_text = "Loose " + _text
			_outlineColor = c_yellow
			break;
			case 2:
			_text = "Oversized " + _text
			_outlineColor = c_red
			break;
		}
	}
	
	var _id   = "itemText"
	scribble(_text,_id).align(fa_left,fa_bottom)
	var _bbox = scribble(_text,_id).get_bbox(_x,_y)
	
	draw_set_alpha(0.5)
	draw_set_color(c_black)
	draw_rectangle(_bbox.x0,_bbox.y0,_bbox.x3,_bbox.y3,0)
	draw_set_alpha(1)
	draw_set_color(_outlineColor)
	draw_rectangle(_bbox.x0,_bbox.y0,_bbox.x3,_bbox.y3,1)
	draw_set_color(c_white)
	scribble(_text,_id).draw(_x,_y)
	delete _bbox
}

function dealDamage(_damage,_target,_multi = 1)
{
	if(!instance_exists(_target)) exit;
	
	var _source = other
	var _mult = 1
	var _evade = _target.evasion
	var _crit = 0
	var _critMult = 100
	
	if(_target.object_index = obj_player)
	{
		_mult = _target.effectiveStats.incomingDamage
	}
	else if(object_index = obj_player)
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
	
	drawX += (_target.x-drawX)/2
	drawY += (_target.y-drawY)/2

	global.player.alarm[0] = 1 + _multi*5
	while(_multi>0)
	{
		_multi--;
		multiTimeSource[_multi] = time_source_create(time_source_game,1 + 5*_multi,time_source_units_frames,dealDamageInstance,[_damage,_target,_mult,_evade,_crit,_critMult])
		time_source_start(multiTimeSource[_multi])
	}
}

function dealDamageInstance(_damage,_target,_mult,_evade,_crit,_critMult)
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

	var _dam = min(0,random(_target.defense)-random_range(_damage/2,_damage))
	if(_crit != 0 && _crit > irandom(100))
	{
		_mult *= 1 + _critMult/100	
		soundRand(sndCrit)
	}
	
	_dam *= _mult	
	if(_mult >= 1) _dam = ceil(_dam)
	else _dam = floor(_dam)
	
	if(_dam>=0) soundRand(choose(fart1,fart2,fart3,fart4))
	else soundRand(sndSwing)
	
	textPopup(_target.x,_target.y,string(_dam))
	
	_target.hp += _dam
	_target.takeDamage(_dam)
	if(_target.hp<=0)
	{
		_target.onDeath()
		instance_destroy(_target)	
	}
}

function heal(_amt,_target)
{
	if(_target.hp < _target.effectiveStats.max_hp) _target.hp = min(_target.effectiveStats.max_hp,_target.hp+_amt)
}

function hurt(_amt,_target)
{
	_target.hp += _amt
	//_target.takeDamage(_amt)
	
	textPopup(_target.x+32,_target.y,string(_amt))
	soundRand(sndFireHiss)
	if(_target.hp<=0)
	{
		_target.onDeath()
		instance_destroy(_target)	
	}
}
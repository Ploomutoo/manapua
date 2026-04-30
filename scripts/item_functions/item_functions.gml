function Item() constructor
{
	//Accepts potion, weapon, armor, ring
	slot = ""
	name = "Placeholder"
	size = ""
	sprite = other.sprite_index
	defense = 0
	damage	= 0
	equipped	= false
	consumable	= false
	tooltip = ""
	funcUse = function()
	{
		//soundRand(sndQuaff)
		toggleEquipped(global.player)
	}
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
		_tooltip += "\n[spr_text_interval] "+ string(_item.interval)
	}
	if(_item.defense != 0)
	{
		_tooltip += "\n[spr_text_defense] "+ string(_item.defense)
	}
	return(_tooltip)
}

function toggleEquipped(_wearer)
{
	if(!equipped)
	{
		switch(slot)
		{
			case "Weapon":
			soundRand(sndDrawWeapon)
			_wearer.attackDelay = interval
			break;
			
			default:
			soundRand(sndDon)
			break;
		}
		_wearer.defense += defense
		_wearer.damage  += damage
	}
	else
	{
		soundRand(sndDoff)
		_wearer.defense -= defense
		_wearer.damage  -= damage
	}
	equipped = !equipped
}

function drawItemText(_item,_x,_y)
{
	if(_item = -1) exit;
	
	var _text = _item.tooltip
	var _id   = "itemText"
	scribble(_text,_id).align(fa_left,fa_bottom)
	scribble(_text,_id).draw(_x,_y)
	var _bbox = scribble(_text,_id).get_bbox(_x,_y)
	
	draw_rectangle(_bbox.x0,_bbox.y0,_bbox.x3,_bbox.y3,1)
	delete _bbox
}

function dealDamage(_damage,_target)
{
	var _source = other
	var _dam = min(0,irandom(_target.defense)-irandom(_damage))
	
	if(_target.asleep) 
	{
		soundRand(sndCrit)
		_dam = -(irandom(_damage)+5)
		_target.asleep = false
	}
	_target.hp += _dam
	if(_target.hp<=0)
	{
		if(_target = global.player)
		{
			
		}
		else
		{
			instance_destroy(_target)	
		}
	}
}

function heal(_amt,_target)
{
	if(_target.hp < _target.max_hp) _target.hp = min(_target.max_hp,_target.hp+_amt)
}
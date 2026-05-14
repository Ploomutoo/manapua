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
		if(_item.kineticdamage!=0)	_tooltip += "\n[spr_text_kinetic] "+ string(_item.kineticdamage)
		_tooltip += "\n[spr_text_interval] "+ string(_item.interval)
		if(ceil(_item.weightinterval)!=0)	
		{
			_tooltip = "[spr_text_weight,"+string(_item.weightclass)+"] " + _tooltip
			_tooltip += "\n[spr_text_weight_interval] "+ string(_item.weightinterval)
		}
		if(_item.special!="") _tooltip += "\n[spr_text_special] "+ _item.special + " " + string(_item.specialAmt)
	}
	else if(_item.slot = "Food")
	{
		_tooltip += "\n" + string(_item.foodval)+" calories"	
	}
	else if(_item.slot = "Armor")
	{
		_tooltip += "\n[spr_text_defense] "+ string(_item.defense)
		_tooltip = "[spr_text_weight,"+string(_item.weightclass)+"] " + _tooltip
		if(_item.special!="") _tooltip += "\n[spr_text_special] "+ _item.special + " " + string(_item.specialAmt)
	}
	/*if(_item.defense != 0)
	{
		_tooltip += "\n[spr_text_defense] "+ string(_item.defense)
	}*/
	return(_tooltip)
}

function eatFood()
{
	with(global.bigSprite) skeleton_animation_set("eat",0)
	heal(foodval,global.player)
	
	global.player.weight += foodval
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
	var _bbox = scribble(_text,_id).get_bbox(_x,_y)
	
	draw_set_alpha(0.5)
	draw_set_color(c_black)
	draw_rectangle(_bbox.x0,_bbox.y0,_bbox.x3,_bbox.y3,0)
	draw_set_alpha(1)
	draw_set_color(c_white)
	scribble(_text,_id).draw(_x,_y)
	draw_rectangle(_bbox.x0,_bbox.y0,_bbox.x3,_bbox.y3,1)
	delete _bbox
}

function dealDamage(_damage,_target)
{
	//var _source = other
	var _dam = min(0,irandom(_target.defense)-irandom(_damage))
	
	drawX += (_target.x-drawX)/2
	drawY += (_target.y-drawY)/2
	
	//part_particles_create(global.pSystem,x,y,global.partSwing,10)
	
	if(_target.asleep) 
	{
		soundRand(sndCrit)
		_dam = -(irandom(_damage)+5)
		_target.asleep = false
	}
	_target.hp += _dam
	if(_dam>=0) soundRand(choose(fart1,fart2,fart3,fart4))
	else soundRand(sndSwing)
	
	textPopup(_target.x,_target.y,string(_dam))
	
	_target.takeDamage(_dam)
	if(_target.object_index = obj_player)
	{
		
	}
	else if(_target.hp<=0)
	{
		_target.onDeath()
		instance_destroy(_target)	
	}
}

function heal(_amt,_target)
{
	if(_target.hp < _target.max_hp) _target.hp = min(_target.max_hp,_target.hp+_amt)
}
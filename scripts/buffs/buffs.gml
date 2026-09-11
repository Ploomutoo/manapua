function buff(_name = "",_tooltip = "",_icon = spr_buff_happy,_duration = 10,_affectedStat = "",_amount = 0,_expireFunc = expireExample) constructor 
{
	name = _name
	tooltip = _tooltip
	icon = _icon
	
	duration = _duration
	affectedStat = _affectedStat
	amount = _amount
	
	expireFunc = _expireFunc
}

function dotEffect(_name = "",_tooltip = "",_icon = spr_buff_sad,_duration = 10,_amount = 0) constructor 
{
	name = _name
	tooltip = _tooltip
	icon = _icon
	
	duration = _duration
	amount = _amount
}

function expireExample()
{
	//nothing lol
}

function givePlayerBuff(_debuffName,_duration = -1)
{
	var _buff = new buff(_debuffName)
	var _type = "turnTerminated"
	switch(_debuffName)
	{
		case "Might":
			_buff.duration = 20
			_buff.tooltip = "You are mighty!"
			_buff.icon = spr_buff_mighty
			_buff.affectedStat = "%dmgMod"
			_buff.amount = 2
		break;
		case "Mana Frenzy":
			_buff.duration = 10
			_buff.tooltip = "Instant spell cooldown!"
			_buff.icon = spr_buff_happy
			_buff.affectedStat = "%spellCooldown"
			_buff.amount = 0
		break;
		case "Haste":
			_buff.duration = 10
			_buff.tooltip = "Actions are twice as fast!"
			_buff.icon = spr_buff_happy
			_buff.affectedStat = "%speedAll"
			_buff.amount = 0.5
		break;
		case "Divinity":
			_buff.duration = 20
			_buff.tooltip = "You feel invincible!"
			_buff.icon = spr_buff_happy
			_buff.affectedStat = "%incomingDamage"
			_buff.amount = 0
		break;
		case "Invisibility":
			_buff.duration = 20
			_buff.tooltip = "You are very stealthy"
			_buff.icon = spr_buff_happy
			_buff.affectedStat = "stealth"
			_buff.amount = 100
		break;
		case "Ghost Pepper":
			_type = "defendTerminated"
			_buff.duration = 1
			_buff.tooltip = "You are very stealthy"
			_buff.icon = spr_buff_happy
			_buff.affectedStat = "dodge"
			_buff.amount = 100
		break;
		
		default:
			show_debug_message("Buff " + _debuffName + " not found")
			exit;
	}
	
	if(_duration != -1) _buff.duration = _duration //overwrite duration if one is given	
	
	with(global.player)
	{
		var _buffArray = struct_get(buffList,_type)
		if(_buffArray != undefined)
		{
			if(is_array(_buffArray))
			{
				array_push(_buffArray,_buff)
				struct_set(buffList,_type,_buffArray)
			}
			else
			{
				show_debug_message("Buff type " + _type + " is not an array")	
			}
		}
		else
		{
			show_debug_message("Buff type " + _type + " not found")	
		}
	}
	
	delete _buff;
}
if(instance_place(x,y,obj_timeaffected))
{
	instance_destroy()
	exit;
}

event_inherited()

lastActionDuration = 1
meterAmt = 0

target = instance_nearest(x,y,obj_player)
drawX = x
drawY = y

targetPath = path_add()
asleep = true

baseStats = new Statblock("Magic Rat")
effectiveStats = variable_clone(baseStats)

buffList = 
{
	damageOverTime : [],
	turnTerminated : [],
	allBuffs : []
}

hp = effectiveStats.max_hp
evasion = dodgeToEvasion(effectiveStats.dodge)
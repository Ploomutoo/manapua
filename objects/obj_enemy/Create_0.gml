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

baseStats = new Statblock("Pit Fiend")
effectiveStats = variable_clone(baseStats)

buffList = new buffStruct()

hp = effectiveStats.max_hp
evasion = dodgeToEvasion(effectiveStats.dodge)
function devouring_blade()
{
	var _weaponSlot = findWieldedWeapon()
	
	show_debug_message("Weapon is slot {0}",_weaponSlot)
	if(_weaponSlot != -1) 
	{	
		inventory[_weaponSlot].damage	+= 1
		inventory[_weaponSlot].interval += 0.01
		
		inventory[_weaponSlot].tooltip = generateTooltip(inventory[_weaponSlot])
		calcEffectiveStats()
	}
}
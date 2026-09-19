function takePoison(_target)
{
	//show_debug_message("Taking {0} damage", _buffInstance.amount)
	var _damage = amount
	with(_target)
	{
		textPopup(x,y,"[c_lime]"+string(_damage))
		soundRand(sndPoison)
	
		hp += _damage
		if(hp <= 0) 
		{
			runArray(effectiveStats.onDeath)
			instance_destroy()
		}
	}
}
	
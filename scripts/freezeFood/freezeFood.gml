function freezeFood(_index,_amt)
{
	with(global.player)
	{
		switch(inventory[_index].condition)
		{
			case "Frozen":
			inventory[_index].condition = "Deep Frozen"
			inventory[_index].tooltip = generateTooltip(inventory[_index])
			soundRand(sndFreeze)
			return(true)
			
			case "Fresh":
			case "Stale":
			inventory[_index].condition = "Frozen"
			inventory[_index].tooltip = generateTooltip(inventory[_index])
			soundRand(sndFreeze)
			return(true)
		
			default:
			return(false)
		}
	}
	show_debug_message("Could not freeze for some reason")
	return(false)
}
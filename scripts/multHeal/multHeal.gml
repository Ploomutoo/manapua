function multHeal(_index,_amt)
{
	with(global.player)
	{
		switch(inventory[_index].condition)
		{
			case "Fresh":
			case "Stale":
			//show_debug_message("Multiplying {0} by {1}",inventory[_index].healing,_amt)
			inventory[_index].healing = max(0,inventory[_index].healing * real(_amt))		
			inventory[_index].condition = "Sweetened"
			
			inventory[_index].tooltip = generateTooltip(inventory[_index])
			soundRand(sndSalt)
			return(true)
			
			default:
			return(false)
		}
	}
}
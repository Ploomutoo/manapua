function multSpecial(_index,_amt)
{
	with(global.player)
	{
		switch(inventory[_index].condition)
		{
			case "Fresh":
			case "Stale":
			inventory[_index].specialAmt[0] = max(0,inventory[_index].specialAmt[0] * real(_amt))		
			inventory[_index].condition = "Pepper"
			
			inventory[_index].tooltip = generateTooltip(inventory[_index])
			soundRand(sndSalt)
			return(true)
			
			default:
			return(false)
		}
		
		
	}
}
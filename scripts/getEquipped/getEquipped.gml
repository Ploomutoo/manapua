function getEquipped()
{
	var _return = []
	for(var _i = 0; _i < array_length(inventory); _i++)
	{
		if(inventory[_i] != -1 && inventory[_i].equipped)
		{
			array_push(_return,inventory[_i])
		}
	}
	return(_return)
}
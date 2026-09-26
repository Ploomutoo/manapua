function skewerRandomFood(_amt)
{
	repeat(_amt)
	{
		var _index = getRandomFoodInd()
		if(_index = -1) return(false)
		skewerFood(_index,0)
	}
}
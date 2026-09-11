function toggleEquipped(_wearer)
{
	if(!equipped)
	{
		switch(slot)
		{
			case "Weapon":
			soundRand(sndDrawWeapon)
			clock(1)
			break;
			
			case "Armor":
			soundRand(sndDon)
			clock(3)
			break;
			
			default:
			soundRand(sndDon)
			clock(1)
			break;
		}
	}
	else
	{
		soundRand(sndDoff)
	}
	equipped = !equipped
}
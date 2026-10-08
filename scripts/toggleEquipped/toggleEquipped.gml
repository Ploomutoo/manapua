function toggleEquipped(_wearer)
{
	if(!equipped)
	{
		switch(slot)
		{
			case "Weapon":
			if(global.player.weightclass < minWeight)
			{
				textPopup(global.player.x,global.player.y,"Too heavy!")
				return(false)	
			}
			soundRand(sndDrawWeapon)
			clock(1)
			break;
			
			case "Armor":
			if(global.player.weightclass < minWeight)
			{
				textPopup(global.player.x,global.player.y,"Too loose!")
				return(false)	
			}
			else if(global.player.weightclass > maxWeight)
			{
				textPopup(global.player.x,global.player.y,"Too tight!")
				return(false)	
			}
			soundRand(sndDon)
			clock(3)
			break;
			
			case "Spellbook":
			var _spell = spells[0]
			with(global.player)
			{
				libraryOn = 0
				spellCasting = new Spell(_spell)
				textPopup(x+global.cellSize/2,y+global.cellSize/2,_spell)
			}	
			break;
			
			default:
			soundRand(sndDon)
			clock(1)
			break;
		}
	}
	else
	{
		if(slot = "Spellbook")
		{
			with(global.player)
			{
				libraryOn = 0
				spellCasting = new Spell(baseStats.library[0])
				//textPopup(x+global.cellSize/2,y+global.cellSize/2,baseStats.library[0])
			}	
		}
		soundRand(sndDoff)
	}
	
	equipped = !equipped
	return(false)
}
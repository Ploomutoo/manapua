var _tileDist = tileDistObj(self,target)
var _canLine = canLine(self,target)

var _validSpells = []
if(_canLine) for(var _i = 0; _i < array_length(effectiveStats.spell); _i++)
{
	if(_tileDist <= effectiveStats.spell[_i].spellRange)
	{
		array_push(_validSpells,effectiveStats.spell[_i])	
	}
}
var _spellCount = array_length(_validSpells)

switch(effectiveStats.behavior)
{
	case "Confused":
		stumble();
		break;
		
	case "Ranger": //rangers will prioritize casting > advancing > shooting  > retreating > melee
	case "ranger":
		
		if(_spellCount>0 && irandom(9)<=3)
		{
			var _spellIndex = 0
			if(_spellCount > 1) _spellIndex = irandom(_spellCount-1)
			
			cast(_validSpells[_spellIndex])
		}
		else if(_tileDist > effectiveStats.range)
		{
			advance()
		}
		else if(_tileDist > 1 && _tileDist <= effectiveStats.range && canLos(target.x,target.y,effectiveStats.range)) rangedAttack(target)
		else 
		{
			var _validRetreat = getValidRetreat(target)
			if(_tileDist < 2 && _validRetreat!=-1)
			{
				retreat(_validRetreat)
			}
			else 
			{
				if(_tileDist<2) meleeAttack(true)
				else sleep()
			}
		}
		break;
		
	default: //cast spell > advance > attack
	
		if(_spellCount>0 && irandom(9)<=3)
		{
			var _spellIndex = 0
			if(_spellCount > 1) _spellIndex = irandom(_spellCount-1)
			
			cast(_validSpells[_spellIndex])
		}
		else if(_tileDist > effectiveStats.range)
		{
			advance()
		}
		else if(_tileDist > 1 && _tileDist <= effectiveStats.range && canLos(target.x,target.y,effectiveStats.range)) rangedAttack(target)
		else 
		{
			if(_tileDist<2) meleeAttack()
			else sleep()
		}
		break;
}
//decayBuff("turnTerminated",lastActionDuration)
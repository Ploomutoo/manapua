var _enemyCount = instance_number(obj_timeaffected)
var _instance
var _time = min(0.1,waitTime)

decayBuff("turnTerminated",_time)

for (var _i = 0; _i < _enemyCount; _i++)
{
	_instance = instance_find(obj_timeaffected,_i)
	with(_instance)
	{
		actionTimer -= _time
		if(actionTimer <= 0)
		{
			if (asleep) //wakey func
			{
				var _playerDist = tileDistObj(self,other)
				if(!inFog(x,y) && _playerDist<4)
				{				
					if(floor(random(3/other.effectiveStats.stealth))=0) 
					{
						asleep = false
						soundRand(sndBiterHerald)
					}
				}	
				actionTimer = 1
			}
			else
			{
				event_user(0)
			
				other.alarm[0] = global.gameDelay
				break;
			}
		}
		
		decayBuff("turnTerminated",_time)
	}
}
if(waitTime>0 && alarm[0] = 0)
{
	waitTime -= _time
	alarmRecursions--;
	
	if(alarmRecursions>1) event_perform(ev_alarm,0)
	else 
	{
		alarm[0] = 1
		alarmRecursions = 30
	}
}
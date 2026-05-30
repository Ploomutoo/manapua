#region Stats

	//Default values
	damage		= 10+baseDamage
	attackDelay = 1
	var reach		= 1
	var multistrike = 1
	
	var lifesteal	= baseLifesteal
	defense = baseDefense
	evasion = baseEvasion
	stealth = 0
	
	var foodheal= baseFoodheal
	var flight  = false
	moveDelay = 1
	var thorns  = 0
	
	armorDisparity = 0
	weaponDisparity = 0
	
	if(weight >= weightToNext)
	{
		var lastMaxhp = max_hp		
		weight -= weightToNext
		
		weightclass++;
		weightToNext = getWeightToNext(weightclass)
		max_hp = getMaxhp(weightclass)
		hp+=max_hp-lastMaxhp
		
		textPopup(x+32,y-32,"Size Up!")
	}
		
var _equipped = getEquipped()
for(var _i = 0; _i < array_length(_equipped); _i++) //Weapon first since it decides base delay
{
	if(_equipped[_i].slot = "Weapon")
	{
		damage = _equipped[_i].damage+baseDamage
		damage += _equipped[_i].kineticdamage*weightclass
		attackDelay = real(_equipped[_i].interval)
		
		switch(_equipped[_i].special)
		{
			case "Reach":
			reach = 1 + _equipped[_i].specialAmt
			break;
			case "Multistrike":
			multistrike += _equipped[_i].specialAmt
			break;
		}
		weaponDisparity = _equipped[_i].weightclass - weightclass 
		if(weaponDisparity>0) 
		{
			preciseDisparity = 0
			if(weaponDisparity>1) preciseDisparity += weaponDisparity-1
			
			preciseDisparity += 1-weight/weightToNext
			attackDelay += real(_equipped[_i].weightinterval)*preciseDisparity
		}
		
		array_delete(_equipped,_i,1)
		break;
	}
}
var armorskin = ""
for(var _i = 0; _i < array_length(_equipped); _i++) 
{
	if(_equipped[_i].slot = "Armor")
	{
		if(_equipped[_i].weightclass != weightclass)
		{
			armorDisparity = weightclass - _equipped[_i].weightclass
			if(armorDisparity>1)
			{
				textPopup(x+32,y,"Too tight!")
				soundRand(sndRip)
				_equipped[_i].equipped = false
				continue;
			}
			else if(armorDisparity<-1)
			{
				textPopup(x+32,y,"Too loose!")
				_equipped[_i].equipped = false
				continue;
			}
			else //Tight/Loose armor penalty
			{
				moveDelay += 0.2
				attackDelay += 0.2
			}
		}
	}
	armorskin = _equipped[_i].skinName
	
	if(struct_exists(_equipped[_i],"lifesteal")) lifesteal += _equipped[_i].lifesteal
	defense += _equipped[_i].defense
	if(struct_exists(_equipped[_i],"evasion")) evasion		+= _equipped[_i].evasion
	if(struct_exists(_equipped[_i],"stealth")) stealth		+= _equipped[_i].stealth
	if(struct_exists(_equipped[_i],"foodheal")) foodheal	+= _equipped[_i].foodheal
	if(struct_exists(_equipped[_i],"flight")) flight = true
	if(struct_exists(_equipped[_i],"movespeed")) moveDelay	-= _equipped[_i].movespeed
	if(struct_exists(_equipped[_i],"thorns")) thorns		+= _equipped[_i].thorns
}
#endregion

#region setting inputs
var inp_x = keyboard_check_pressed(ord("D")) - keyboard_check_pressed(ord("A"));
var inp_y = keyboard_check_pressed(ord("S")) - keyboard_check_pressed(ord("W"));
var inp_move = abs(inp_x) || abs(inp_y);
#endregion

if(drawX!=x)
{
	drawX += (x-drawX)/5	
}
if(drawY!=y)
{
	drawY += (y-drawY)/5	
}

var desiredPos = [x,y]
if(inp_move && waitTime = 0)
{
	if(abs(inp_x)>0)
	{
		desiredPos[0] += 64*inp_x
	}
	else 
	{
		desiredPos[1] += 64*inp_y
	}
	
	
	var obstacle = noone
	var _check = [0,0]
	
	for(var _i = 1; (_i <= reach && obstacle = noone); _i++)
	{
		_check = [x+64*inp_x*_i,y+64*inp_y*_i]
		obstacle = instance_place(_check[0],_check[1],obj_timeaffected)
		
		if(tilemap_get(global.walls,_check[0]/64,_check[1]/64)>0) break;
	}
	
	if(instance_exists(obstacle))
	{
		repeat(multistrike) dealDamage(damage,obstacle)
		if(lifesteal>0) heal(irandom(lifesteal),global.player)
		//show_debug_message("attack delay "+string(attackDelay))
		clock(attackDelay)
	}
	else
	{
		var _tilex = floor(desiredPos[0]/global.cellSize)
		var _tiley = floor(desiredPos[1]/global.cellSize)
		
		if(tilemap_get(global.walls,_tilex,_tiley) = 0)
		{
			x = desiredPos[0]
			y = desiredPos[1]
			
			drawX += (x-drawX)/2
			drawY += (y-drawY)/2
						
			defog(_tilex,_tiley)
		}
		clock(moveDelay)
	}
}

var weightskin = weightclass
with (global.bigSprite) 
{
	queuesize = weightskin
	var skinarray = ["0",string(displaysize)]
	if(armorskin != "") array_push(skinarray,armorskin)
	
	var skin = skeleton_skin_create("playerskin",skinarray)
	skeleton_skin_set(skin)
	
	delete skin
}
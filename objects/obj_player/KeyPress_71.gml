var _item = instance_place(x,y,obj_item)

if(_item!=noone)
{
	var _i = 0
	while(inventory[_i]!=-1)
	{
		_i++
		if(_i>=invSize) 
		{ //inventory full :(
			soundRand(choose(invFull1,invFull2),0.1)
			with(global.bigSprite) skeleton_animation_set("no",0)
			exit;	
		}
	}
	inventory[_i] = _item.item
	soundRand(choose(get1,get2,get4,get5),0.1)
	instance_destroy(_item)	
}
else
{
	var _stairs = instance_place(x,y,obj_stairs)
	
	if(_stairs != noone)
	{
		room_goto(room)
		exit;
	}
	
	soundRand(choose(invFull1,invFull2),0.1)
	with(global.bigSprite) skeleton_animation_set("no",0)
}
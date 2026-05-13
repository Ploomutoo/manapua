event_inherited()

target = instance_nearest(x,y,obj_player)
drawX = x
drawY = y

targetPath = path_add()
asleep = true

max_hp = 10
hp = max_hp
defense = 1
damage = 3

attackDelay = 1
moveDelay   = 1

onDeath = function()
{
	instance_create_layer(x,y,layer,obj_item_flesh)
	soundRand(sndEnemyDie,0.1)
}
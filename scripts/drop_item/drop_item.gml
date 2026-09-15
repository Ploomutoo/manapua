function drop_item()
{
	instance_create_layer(x,y,"Instances",obj_item)
	soundRand(sndEnemyDie,0.1)
}
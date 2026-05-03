function defineParticles()
{
	global.pSystem = part_system_create_layer(layer_create(-100,"Particles"),true)	
	global.partSwing = part_type_create()
	part_type_sprite(global.partSwing,spr_swing,true,true,false)
	part_type_life(global.partSwing,30,60)
}

function createAt(object){
	return(instance_create_layer(x,y,layer,object));
}
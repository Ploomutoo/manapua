if(!skeleton_animation_is_looping(0))
{
	if(displaysize != queuesize)
	{
		skeleton_animation_set("weight-gain",0)
	}
	else skeleton_animation_set("idle",0)
}
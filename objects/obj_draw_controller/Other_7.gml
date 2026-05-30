if(!skeleton_animation_is_looping(0))
{
	if(displaysize != queuesize)
	{
		skeleton_animation_set("weightUp",0)
	}
	else skeleton_animation_set("basic",0)
}
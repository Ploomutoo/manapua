function explode(_damage,_diameter)
{
	_damage = real(_damage)
	_diameter = real(_diameter)
	
	var _offset = floor((_diameter-1)/2)*global.cellSize
			
	var _spell = instance_create_layer(x-_offset,y-_offset,"effects",obj_spell_aoe,
	{
		size : _diameter,
		caster : noone,
		hitsPlayer : true,
		damage : _damage,
		outBuff : 
		{
			name : ""	
		}
	})
}
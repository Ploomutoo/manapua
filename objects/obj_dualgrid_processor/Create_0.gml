var working_layers = layer_get_all()
global.cellSize = 64
global.mapSize = [ceil(room_width/global.cellSize),ceil(room_height/global.cellSize)]

global.collisionMap = mp_grid_create(0,0,
global.mapSize[0],
global.mapSize[1],
global.cellSize,global.cellSize)

mp_grid_clear_all(global.collisionMap)

for(var _layer = 0; _layer<array_length(working_layers); _layer++)
{
	grid_in = layer_tilemap_get_id(working_layers[_layer])
	if(!layer_tilemap_exists(working_layers[_layer],grid_in)) continue;
	if(layer_get_name(working_layers[_layer]) = "ts_fog") continue;

	grid_width = tilemap_get_width(grid_in)+1
	grid_height = tilemap_get_height(grid_in)+1

	tileset_out_index = asset_get_index(tileset_get_name(tilemap_get_tileset(grid_in))+"_out")
	grid_out = layer_tilemap_create(
	layer_create(layer_get_depth(working_layers[_layer]),layer_get_name(working_layers[_layer])+"_out"),
	-32,-32,
	tileset_out_index,
	ceil(room_width/grid_width),
	ceil(room_height/grid_height)
	)

	for(var _i = 0; _i<grid_width; _i++)
	{
		for(var _i2 = 0; _i2<grid_height; _i2++)
		{
			out = 0
			if(tilemap_grab(grid_in,_i  ,_i2  )) out += 1
			if(tilemap_grab(grid_in,_i-1,_i2  )) out += 2
			if(tilemap_grab(grid_in,_i  ,_i2-1)) out += 4
			if(tilemap_grab(grid_in,_i-1,_i2-1)) out += 8
			
			if(out != 0)
			{
				randmax = tilesetDoesRandom(tileset_out_index)
				
				if(randmax > 0)	out+=16*irandom(randmax)
			}
				
			tilemap_set(grid_out,out,_i,_i2)
		}
	}
	layer_set_visible(working_layers[_layer],0)
}

grid_in = layer_tilemap_get_id("ts_walls")
for(var _i = 0; _i<grid_width; _i++)
	{
		for(var _i2 = 0; _i2<grid_height; _i2++)
		{
			if(tilemap_get(grid_in,_i,_i2))
			{
				mp_grid_add_cell(global.collisionMap,_i,_i2)
			}
		}
	}

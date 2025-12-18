extends Node2D

var transparancy_radius=720

func update_opacity():
	for child in get_children():
		pass
func get_elevation(pos):
	var cell_pos=to_local(pos)
	var z=0
	for child in get_children():
		if child.get_cell_tile_data(pos)!=null:
			z=child.get_index()
	return z

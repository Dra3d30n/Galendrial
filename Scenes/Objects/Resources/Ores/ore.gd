extends "res://Scenes/Objects/Resources/resource.gd"
func awaken_values():
	Actions=["mine"]
	
func mine():
	GameState.active_player.goals=[["walk",[global_position]],["harvest",[self,"mine"]]]

extends "res://Scenes/Objects/Resources/resource.gd"

func awaken_values():
	Actions=["chop"]
func chop():
	GameState.active_player.goals=[["walk",[global_position]],["harvest",[self,"chop"]]]

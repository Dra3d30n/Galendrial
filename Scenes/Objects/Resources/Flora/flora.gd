extends "res://Scenes/Objects/Resources/resource.gd"
func awake():
	Actions=["collect"]
	
func collect():
	GameState.active_player.goals=[["walk",[global_position]],["harvest",[self,"collect"]]]

extends "res://Scenes/Objects/object.gd"
var item_id
func awake():
	Actions=["pick up"]
	
func pick_up():
	GameState.active_player.goals=

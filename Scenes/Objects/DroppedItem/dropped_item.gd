extends "res://Scenes/Objects/object.gd"
@export var item_id : int
func awake():
	Actions=["pick up"]
	synchronization_values=["item_id"]
	Name=Items.items[item_id]["name"]
	
func pick_up():
	GameState.active_player.goals=[["walk",[global_position]],["add_item",[self,item_id,]]]

extends "res://Scenes/Objects/object.gd"
@export var item_id : int
@export var amount : int

func awake():
	Actions=["pick up"]
	synchronization_values=["item_id"]
	Name=Items.items[item_id]["name"] +str(amount)
	
func pick_up():
	GameState.active_player.goals=[["walk",[global_position]],["add_item",[self,amount,]]]

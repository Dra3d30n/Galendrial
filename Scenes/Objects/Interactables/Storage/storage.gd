extends "res://Scenes/Objects/Interactables/interactable.gd"
var inventory=[]
@export var max_size=0


func awake():
	synchronization_values=["inventory"]
	ui_scene_path=""

func add_item(id):
	if inventory.size() >= max_size:
		return false  # inventory full

	inventory.append({"id": id})
	return true

func remove_item(id):
	for index in range(inventory.size()):
		if inventory[index]["id"] == id:
			inventory.remove(index)
			return true  # successfully removed

	return false  # item not found


func get_current_amount():
	return len(inventory)
func change(slot):
	request_change.rpc_id(1,slot,multiplayer.get_unique_id())
@rpc("any_peer","reliable")
func request_change(slot,sender):
	var data=inventory[slot]
	if data!=null:
		finish_change.rpc_id(sender,data)
@rpc("reliable","authority")
func finish_change(item):
	GameState.active_player.add_item(item)

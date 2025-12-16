extends "res://Scenes/Objects/Interactables/interactable.gd"
var inventory=[]
@export var max_size=0


func awake():
	synchronization_values=["inventory"]
	ui_scene_path=""
	
func add_item(id,amount):
	if inventory.size() >= max_size:
		#NEEDLATER
		return false# or handle overflow

	var item= {"id":id,"amount":amount}
	var index=0
	
	for new_item in inventory:
		if new_item["id"]==id:
			var reformed_item=new_item.duplicate()
			reformed_item["amount"]+=amount
			inventory[index]=reformed_item
			return
		index+=1
	inventory.append(item)
	return true
func remove_item(id, amount):
	for index in range(inventory.size()):
		if inventory[index]["id"] == id:
			# Reduce amount
			inventory[index]["amount"] -= amount
			
			# Remove item if amount is 0 or less
			if inventory[index]["amount"] <= 0:
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

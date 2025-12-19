extends "res://Scenes/Objects/Interactables/interactable.gd"

var inventory = []  # Each entry: {"id": id, "amount": n}
@export var max_size = 0


func awake():
	synchronization_values = ["inventory"]
	ui_scene_path = ""


# Add an item with an amount (default 1)
func add_item(id, amount = 1) -> bool:
	# First, try to stack if it already exists
	for entry in inventory:
		if entry["id"] == id:
			entry["amount"] += amount
			return true

	# If inventory is full, cannot add new item
	if inventory.size() >= max_size:
		return false

	# Otherwise, add a new item entry
	inventory.append({"id": id, "amount": amount})
	return true


# Remove a certain amount of an item
func remove_item(id, amount = 1) -> bool:
	for index in range(inventory.size()):
		if inventory[index]["id"] == id:
			if inventory[index]["amount"] > amount:
				inventory[index]["amount"] -= amount
			else:
				inventory.remove(index)  # Remove entirely if amount <= 0
			return true
	return false  # item not found


# Get total amount of a specific item
func get_amount(id) -> int:
	for entry in inventory:
		if entry["id"] == id:
			return entry["amount"]
	return 0


# Get total number of items (sum of all amounts)
func get_current_amount() -> int:
	var total = 0
	for entry in inventory:
		total += entry["amount"]
	return total


# Networking functions (unchanged)
func change(slot):
	request_change.rpc_id(1, slot, multiplayer.get_unique_id())

@rpc("any_peer","reliable")
func request_change(slot, sender):
	var data = inventory[slot]
	if data != null:
		finish_change.rpc_id(sender, data)

@rpc("reliable","authority")
func finish_change(item):
	GameState.active_player.add_item(item["id"], item["amount"])

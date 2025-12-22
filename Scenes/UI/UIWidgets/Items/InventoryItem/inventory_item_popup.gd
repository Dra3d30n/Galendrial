extends "res://Scenes/UI/UIWidgets/Popups/ItemPopups/base_button_popup.gd"

var actions: Array = []

func _process(delta: float) -> void:
	if  link.item_name == null:
		actions = []
		return

	# Rebuild actions each frame (or only when context changes)
	actions = []

	# Always available actions
	if ItemCategories.equipped_key[ link.item_name]!=null:
		actions.append({"name": "Equip", "func": "Equip"})
	actions.append({"name": "Drop", "func": "Drop"})

	# Context-sensitive actions
	if GameState.active_object != null:
		actions.append({"name": "Interact", "func":"Interact"})
func Equip():
	var old_item=GameState.active_player
	
	if old_item:
		GameState.active_player.equipped[ItemCategories.equipped_key[ link.item_name]]=link.item_id
		GameState.active_player.add_item(link.item)
	else:
		

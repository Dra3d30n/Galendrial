extends Control
var tab="craftable"
func _process(delta: float) -> void:
		$"Title".text=GameState.active_object.Name
		var items=[]
		for item in CraftingRecipes.get_items_by_station(GameState.active_object.Name):
			match tab:
				"craftable":
					if CraftingRecipes.can_craft(item, GameState.active_player.inventory)==true:
						items.append(item)
				"not_craftable":
					if CraftingRecipes.can_craft(item, GameState.active_player.inventory)==true:
						items.append(item)
		$"WindowManager/Craftable".items=items



func _on_not_craftable_pressed() -> void:
	tab = "not_craftable"


func _on_craftable_pressed() -> void:
	tab = "craftable"

extends "res://Scenes/UI/UIWidgets/Items/item.gd"


func _on_background_pressed() -> void:
	CraftingRecipes.craft(item_name)

extends "res://Scenes/UI/UIWidgets/Items/item.gd"

func _on_background_pressed() -> void:
	if item_name:
		GameState.active_object.change(get_index())
		
func awake():
	$"Label".text=str(get_index()+1)

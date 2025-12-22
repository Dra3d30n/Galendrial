extends Control

var link=null


func  _physics_process(delta: float) -> void:
	if link:
		if link.item_name:
			$"Label".text=Items.items[link.item_name]["name"]

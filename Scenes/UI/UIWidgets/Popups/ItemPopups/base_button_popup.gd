extends Control

var link=null
@onready var container=$"VBoxContainer"


func  _physics_process(delta: float) -> void:
	if link:
		if link.item_name:
			$"VBoxContainer/Label".text=Items.items[link.item_name]["name"]
			for i in range(link.actions):
				var action=link.actions[i]
				container.get_children()[i+1].label.text=action
var action_decoder={
	"Equip":"equip",
	"Move to Backpack":"move_to_backpack",
	"Move to Object":"move_to_object"
}

func activate(i):
	var action=link.actions[i-1]
	link.call(action_decoder[action])
	
	

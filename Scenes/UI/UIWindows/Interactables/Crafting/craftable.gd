extends Control
@onready var item_scene="res://Scenes/UI/UIWidgets/Items/CraftingItem/Craftable/craftable_item.tscn"
var items=[]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	items=[]

	for child in get_children():
		if child.get_index()<items.size():
			child.item_name=items[child.get_index()]
			child.visible=true
		else:
			child.visible=false

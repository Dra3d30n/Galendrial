extends Control
var inventory=[]
func _physics_process(delta: float) -> void:
	inventory=GameState.active_object.inventory
	var index=0
	for value in inventory:
		$"GridContainer".item_name=Items.items[inventory[index]]["name"]
		index+=1

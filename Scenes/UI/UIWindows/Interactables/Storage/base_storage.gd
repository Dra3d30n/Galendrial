extends Control
var inventory=[]
func _physics_process(delta: float) -> void:
	inventory=GameState.active_object.inventory
	$"WindowManager/Title".text=str(GameState.active_object.Name)
	var index=0
	for value in inventory:
		$"GridContainer".item_name=Items.items[inventory[index]]["name"]
		index+=1

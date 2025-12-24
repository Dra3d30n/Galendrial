extends Control
var link=null
var inventory=[]
func _physics_process(delta: float) -> void:
	if not link:
		return

	inventory = link.inventory
	$"WindowManager/Title".text = str(link.Name)

	for i in range(inventory.size()):
		var slot = $"GridContainer".get_child(i)
		var item_id = inventory[i]["id"]
		var item_amount = inventory[i]["amount"]

		slot.item_name.text = Items.items[item_id]["name"]
		slot.amount.text = str(item_amount)

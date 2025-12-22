extends Node
class_name InventoryWrapper

var inventory_ref: Array

signal changed

func bind(inv: Array):
	inventory_ref = inv
	changed.emit()

func get_items() -> Array:
	return inventory_ref

func add_item(id, amount := 1) -> bool:
	for entry in inventory_ref:
		if entry["id"] == id:
			entry["amount"] += amount
			changed.emit()
			return true

	inventory_ref.append({"id": id, "amount": amount})
	changed.emit()
	return true

func remove_index(index: int):
	if index < 0 or index >= inventory_ref.size():
		return
	inventory_ref.remove_at(index)
	changed.emit()

extends Node

var recipes = {
	0: {
		"name": "sword",
		"ingredients": {
			"iron": 2,
			"wood": 1
		},
		"output_amount": 1,
		"station": "anvil",
		"craft_time": 0
	},
}

signal crafting_success(item_name)
signal crafting_failed(reason)

func _ready() -> void:
	crafting_failed.connect(UiManager.crafting_failed)
	crafting_success.connect(UiManager.crafting_success)

# ----------------------------
# Check if craftable
# ----------------------------
func can_craft(item_name: String, inventory: Array) -> bool:
	for key in recipes.keys():
		var recipe = recipes[key]
		if recipe["name"] == item_name:
			#if recipe.has("station") and recipe["station"] != current_station:
				#return false
			for ingredient_id in recipe["ingredients"].keys():
				if GameState.active_player.get_amount(ingredient_id) < recipe["ingredients"][ingredient_id]:
					return false
			return true
	return false

# ----------------------------
# Craft function
# ----------------------------
func craft(item_name: String) -> void:
	if not can_craft(item_name, GameState.active_player.inventory):
		emit_signal("crafting_failed", "Cannot craft %s. Check materials or station." % item_name)
		return

	# Remove ingredients from player
	for key in recipes.keys():
		var recipe = recipes[key]
		if recipe["name"] == item_name:
			for ingredient_id in recipe["ingredients"].keys():
				GameState.active_player.remove_item(ingredient_id, recipe["ingredients"][ingredient_id])
			# Add result via player method
			GameState.active_player.add_item(item_name, recipe.get("output_amount", 1))
			emit_signal("crafting_success", item_name)
			return
# ----------------------------
# Get all recipes available at a station
# ----------------------------
func get_items_by_station(station: String) -> Array:
	var items := []
	for key in recipes.keys():
		var recipe = recipes[key]
		if recipe.has("station") and recipe["station"] == station:
			items.append(recipe["name"])
	return items

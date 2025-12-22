extends "res://Scenes/Objects/Interactables/interactable.gd"
var inventory=[]
func awake():
	synchronization_values=[]
	ui_scene_path=""
	inventory=CraftingRecipes.get_items_by_station(Name)
	Actions=["Craft"]
func Craft():
	GameState.active_player.goals=[["walk",[global_position]],["activate",[self]]]

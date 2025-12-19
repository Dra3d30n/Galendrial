extends "res://Scenes/Objects/Entities/entitiy.gd"
var Password=""
func awake():
	if multiplayer_authority:
		$Camera2D.make_current()
		GameState.active_player=self
	
	synchronization_values=["position"]
func export_sync():
	var data={}
	for value in synchronization_values:
		if value in self:
			data[value] = get(value)
	init.rpc_id(1,data)
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("LeftMouse"):
		if multiplayer_authority:
			goals = [["walk", [get_global_mouse_position()]]] 
			GameState.set_active_object(null)

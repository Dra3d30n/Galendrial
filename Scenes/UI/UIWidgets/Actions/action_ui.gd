extends "res://Scenes/UI/ui_root.gd"
var actions=[]
var locked_pos=Vector2.ZERO
@onready var title=$"NinePatchRect/Label"
func _physics_process(delta: float) -> void:
	if GameState.active_object:
		update_actions()
	else:
		visible=false
func update_actions():
	if not visible:
		global_position = get_global_mouse_position()
	title.text=GameState.active_object.Name
	
	#position = locked_pos
	visible = true
	actions = GameState.active_object.Actions

	var index = 0
	for child in $VBoxContainer.get_children():
		if index < actions.size():
			child.action_name = actions[index]
			index += 1
		else:
			child.action_name = null

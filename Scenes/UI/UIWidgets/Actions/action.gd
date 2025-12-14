extends "res://Scenes/UI/ui_root.gd"
var action_name=null

func _physics_process(delta: float) -> void:
	if action_name:
		$Label.text=action_name
		visible=true
	else:
		visible=false


func _on_scalable_button_pressed() -> void:
	GameState.active_object.call(action_name)

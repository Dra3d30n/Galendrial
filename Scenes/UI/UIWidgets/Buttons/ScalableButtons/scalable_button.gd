extends "res://Scenes/UI/ui_root.gd"
func _ready() -> void:
	$NinePatchRect/Button.modulate.a=0
	$NinePatchRect/Button.visible=true
signal pressed


func _on_button_button_up() -> void:
	pressed.emit()

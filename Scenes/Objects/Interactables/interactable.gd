extends "res://Scenes/Objects/object.gd"

@export var ui_scene_path: String = ""
@export var distance_threshold: float = 384
@export var state: bool = false  # true = interacted, false = ignored

var current_ui: Node = null

func awake():
	synchronization_values=["state"]
	match state:
		true:
			$AnimatedSprite2D.play("interacted")
		false:
			$AnimatedSprite2D.play("ignored")
	


@rpc("any_peer", "call_local")
func rpc_activate():
	activate()

@rpc("any_peer", "call_local")
func rpc_deactivate():
	deactivate()


func activate() -> void:
	if state != true:
		state = true
		$AnimatedSprite2D.play("interacted")
	open_ui()

func deactivate() -> void:
	if state != false:
		state = false
		$AnimatedSprite2D.play("ignored")
	close_ui()


func open_ui() -> void:
	if ui_scene_path != "" and current_ui == null:
		current_ui = UiManager.open_ui(ui_scene_path)

func close_ui() -> void:
	if current_ui:
		UiManager.close_ui(str(current_ui.name))
		current_ui = null


func active_object_changed(new_object: Node) -> void:
	if GameState.active_object == self and new_object != self:
		deactivate()


func update(delta):
	if Current and GameState.active_object == self:
		if global_position.distance_squared_to(GameState.active_player.global_position) >= (distance_threshold * distance_threshold):
			deactivate()

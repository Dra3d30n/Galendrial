extends Control

var item_name=null
var hovered=false
var active_ui=null
@export var ui=""
@onready var timer=$"HoverTimer"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Items.items[item_name]["texture"]!=$"item".texture:
		$"item".texture=Items.items[item_name]["texture"]
	awake()
func awake():
	pass
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("LeftMouse"):
		UiManager.close_ui(str(active_ui.name))

func _on_background_mouse_entered() -> void:
	hovered=true
	timer.start()


func _on_background_mouse_exited() -> void:
	hovered=false

func _on_hover_timer_timeout() -> void:
	if hovered:
		active_ui=UiManager.open_ui(ui)
		active_ui.global_position=get_global_mouse_position()


func _on_background_pressed() -> void:
	if item_name:
		GameState.active_object.change(item_name)

extends Control
var inventory_pos=null
var item_name=null
var hovered=false
var active_ui=null
@export var ui=""
@onready var timer=$"HoverTimer"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	awake()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Items.items[item_name]["texture"]!=$"item".texture:
		$"item".texture=Items.items[item_name]["texture"]
	
func awake():
	pass
func _input(event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("LeftMouse"):
		if active_ui:
			UiManager.close_ui(str(active_ui.name))
	


func _on_background_pressed() -> void:
	if Input.is_action_just_pressed("RightMouse"):
		active_ui=UiManager.open_ui(ui)
		active_ui.global_position=get_global_mouse_position()
		active_ui.link=self
		pressed()
func pressed():
	pass

extends Control
var inventory_pos=null
var item_name=null
var hovered=false
var active_ui=null
var amount=0
@export var actions=[]
@export var ui=""
@onready var timer=$"HoverTimer"
@export var controller=null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	awake()
	pass # Replace with function body.

func update(new_name,new_amount,link):
	
	item_name=new_name
	amount=new_amount
	
func update_ui():
	if amount>0:
		$"Amount".text=str(amount)
	else:
		$"Amount".text=""
	if Items.items[item_name]["texture"]!=$"item".texture:
		$"item".texture=Items.items[item_name]["texture"]
func awake():
	pass
func _input(event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("LeftMouse"):
		if active_ui:
			UiManager.close_ui(str(active_ui.name))
	
func move_to_backpack():
	if GameState.active_object:
		if controller:
			
			controller.remove_item(item_name,amount)
			GameState.add_item(item_name,amount)
func move_to_object():
	if GameState.active_object:
		if controller:
			
			controller.remove_item(item_name,amount)
			GameState.add_item(item_name,amount)
func equip():
	pass

func _on_background_pressed() -> void:
	if Input.is_action_just_pressed("RightMouse"):
		if controller:
			if amount<=0:
				active_ui=UiManager.open_ui(ui)
				active_ui.global_position=get_global_mouse_position()
				active_ui.link=self
				pressed()
func pressed():
	pass

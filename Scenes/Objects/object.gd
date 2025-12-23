extends Node2D

# -----------------------------
# Exports / variables
# -----------------------------
@export var Name="Object"
@export var NetworkID: int = 1
@export var ObjectID: int = 1
@export var z: int = 0
@export var Actions: Array = []
var multiplayer_authority=false
var synchronization_values=[]
var Current: bool = false
var last_synced_position: Vector2



@rpc("any_peer","unreliable")
func update_position(pos: Vector2):
	global_position = pos

func _ready() -> void:
	name = str(ObjectID)
	last_synced_position = global_position
	if multiplayer.get_unique_id() == NetworkID:
		multiplayer_authority = true
	awake()

	synchronization_values.append_array(["NetworkID","ObjectID"])

	# -----------------------
	# Safe connection for Area2D clicks
	# -----------------------
	if $Area2D and not $Area2D.input_event.is_connected(_on_area_2d_input_event):
		$Area2D.input_event.connect(_on_area_2d_input_event)


func awake():
	pass  # custom logic

func interact(action: String):
	if action in self:
		self.call(action)
func _physics_process(delta: float) -> void:
	
	if not multiplayer.is_server():
		
		if multiplayer_authority:
			export_sync()
		else:
			sync()
	if Current:
		# Only active/on-screen objects update and syn
		update(delta)
		
	if multiplayer.get_unique_id()==NetworkID:
		multiplayer_authority=true
	else:
		multiplayer_authority=false
	visible = Current
	name=str(ObjectID)

func update(delta):
	pass  # override in subclasses


func can_render(): 
	if not GameState.active_player:
		Current=true
		return Current
	var Margin=50 
	var dist_x=abs(GameState.active_player.global_position.x-global_position.x)
	var dist_y=abs(GameState.active_player.global_position.y-global_position.y)
	if dist_x>960+Margin or dist_y>540+Margin: 
		Current=false 
	else:
		Current=true
	return Current
func export_sync():
	pass
func sync():

		request_position_sync()
		if Current:
			request_full_sync(multiplayer.get_unique_id())
@rpc("any_peer","unreliable")
func request_full_sync(id):
	if multiplayer.is_server():
		full_sync(id)
func request_position_sync():
	sync_position.rpc_id(1,multiplayer.get_unique_id())
@rpc("any_peer","unreliable")
func sync_position(id):
	if multiplayer.is_server():
		if global_position != last_synced_position:
			update_position.rpc_id(id,global_position)
			last_synced_position = global_position
func full_sync(id):
	var data={}
	for value in synchronization_values:
		if value in self:
			data[value] = get(value)
	init.rpc_id(id,data)
@rpc("any_peer","unreliable")
func init(data := {}):
	for key in data:
		if key in self:
			self.set(key, data[key])
		else:
			print("⚠ Unknown init field: ", key, " on ", self)

func active_object_changed(object):
	pass
func remove():
	ObjectFactory.remove_internal(ObjectID, z)

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:

	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		GameState.set_active_object(self)

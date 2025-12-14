extends Node
var UIBase: Node

var console=null
@onready var open_windows=[]
var current_ui=null
func init() -> void:
	if multiplayer.is_server():
		return
	UIBase = get_tree().current_scene.get_node("UI")
	console=UIBase.get_node("Console")
	print(console)
	open_windows=UIBase.get_children()
func is_ui_open(scene_path: String) -> bool:
	for ui in open_windows:
		if ui.filename == scene_path:  # `filename` is the path the node was instanced from
			return true
	return false

func open_ui(scene_path: String) -> Node:
	if is_ui_open(scene_path):
		print("Window already open!")
		return null

	var instance = load(scene_path).instantiate()
	UIBase.add_child(instance)
	open_windows.append(instance)
	return instance


func close_ui(node_path: String) -> void:
	if not UIBase.has_node(node_path):
		print("Warning: node not found: ", node_path)
		return
	
	var node: Node = UIBase.get_node(node_path)
	if node in open_windows:
		open_windows.erase(node)
	
	node.remove()
	if current_ui == node:
		current_ui = null
func close_all_ui() -> void:
	for ui in open_windows.duplicate():
		ui.queue_free()
	open_windows.clear()
	current_ui = null
func info(text):	console.info(text)
func success(text):	console.success(text)
func warn(text):	console.warn(text)
func error(text):	console.error(text)
func system(text):	console.system(text)

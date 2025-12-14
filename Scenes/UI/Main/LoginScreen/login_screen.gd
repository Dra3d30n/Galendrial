extends Node2D

@export var HostAddress: String = "192.168.1.195"
@export var HostPort: int = 9000

@export var JoinAddress: String = "true-appreciated.gl.at.ply.gg"
@export var JoinPort: int = 22517

var max_clients=32
const WORLD = preload("res://Scenes/Map/world.tscn")
const CLIENT_WORLD = preload("res://Scenes/Map/client_world.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	multiplayer.connected_to_server.connect(_on_connected)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	
func _on_connected():
	print("Connected")
	await multiplayer.peer_connected
	open_world()
	open_player()
func _on_connection_failed():
	print("OH SHIT YOU DIDNT CONNECT")
func _on_peer_connected(i):
	print("peer connected",i)

func _on_peer_disconnected(i):
	print("peer disconnecte",i)
func open_player():
	ObjectFactory.request_full_sync()
	await get_tree().create_timer(1.0).timeout
	print(ObjectFactory.request_spawn("Player",0,Vector2(0,0),{"NetworkID":GameState.active_id}))
	
func open_world():
	var world=CLIENT_WORLD.instantiate()
	GameState.active_id=multiplayer.get_unique_id()
	get_tree().root.add_child(world)
	get_tree().current_scene = world
	UiManager.init()
	visible=false
func open_host_world():
	var world=WORLD.instantiate()
	GameState.active_id=multiplayer.get_unique_id()
	get_tree().root.add_child(world)
	get_tree().current_scene = world
	visible=false
	await get_tree().create_timer(1.0).timeout
	
	ObjectFactory.register_existing_objects()
	
	
func _on_join_pressed() -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(HostAddress,HostPort)
	multiplayer.multiplayer_peer=peer
	print("Client attempted join!")


func _on_host_pressed() -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(HostPort,max_clients)
	multiplayer.multiplayer_peer=peer
	
	print("Host is up!")
	open_host_world()

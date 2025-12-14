extends Node

var scenes = {
	"Player":"res://Scenes/Objects/Entities/Player/player.tscn",
	"SmallStone":"res://Scenes/Objects/Resources/Ores/L1/SmallStone/small_stone.tscn",
	"LargeStone":"res://Scenes/Objects/Resources/Ores/L1/LargeStone/large_stone.tscn"
	
}
var ObjectMap = [
	[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]
]
#func _physics_process(delta: float) -> void:
	#if not multiplayer.is_server():
		#print(ObjectMap[0])
func request_full_sync():
	full_sync.rpc_id(1,multiplayer.get_unique_id())
@rpc("reliable","any_peer")
func full_sync(NetworkID):
	if multiplayer.is_server():
		print(ObjectMap)
		for z in ObjectMap:
			for object in z:
				var scene_key=""
				for key in scenes.keys():
					if scenes[key]==str(object.get_scene_file_path()) :
						scene_key=key
				rpc_spawn.rpc_id(NetworkID,scene_key,object.z,object.global_position,{"NetworkID":object.NetworkID,"ObjectID":object.ObjectID})

# ─────────────────────────────────────────────
# 1. CLIENT → SERVER: Request spawn
# ─────────────────────────────────────────────
func request_spawn(id: String, z: int, pos: Vector2, data := {}):
	rpc_id(1, "rpc_spawn", id, z, pos, data)
# ─────────────────────────────────────────────
# 2. SERVER → ALL: Validate + replicate spawn
# ─────────────────────────────────────────────
@rpc("any_peer","reliable")
func rpc_spawn(id: String, z: int, pos: Vector2, data := {}):
	# SERVER validates and broadcasts back
	if multiplayer.is_server():
		
		# Basic MMO validation
		if not scenes.has(id): return
		if z < 0 or z >= ObjectMap.size(): return

		# After validating, send to all clients (including requester)
		rpc("rpc_spawn", id, z, pos, data)
		spawn_internal(id, z, pos, data)
		return
	print(multiplayer.get_unique_id())
	# Both clients and server spawn locally
	spawn_internal(id, z, pos, data)
# ─────────────────────────────────────────────
# 3. LOCAL spawn: Runs on server + all clients
# ─────────────────────────────────────────────
func spawn_internal(id: String, z: int, pos: Vector2, data := {}):
	if not scenes.has(id):
		return null
	# --- Check if something with same ID and position already exists ---
	#for obj in ObjectMap[z]:
		#if obj.position == pos and obj.get_scene_file_path() == scenes[id]:
			#return obj  # return existing
	# --- Instantiate normally ---
	
	var inst = load(scenes[id]).instantiate()
	inst.position = pos

	if inst.has_method("init"):
		inst.init(data)


	get_tree().current_scene.get_node("Objects").get_node(str(z)).add_child(inst)

	inst.ObjectID = ObjectMap[z].size()
	ObjectMap[z].append(inst)
	return inst







# 1. CLIENT → SERVER: Request removal
func request_remove(ObjectID: int, z: int):
	rpc_id(1, "rpc_request_remove", ObjectID, z)


# 2. SERVER: validate + broadcast
@rpc("any_peer")
func rpc_request_remove(ObjectID: int, z: int):
	if not multiplayer.is_server():
		return

	# Validate bounds
	if z < 0 or z >= ObjectMap.size(): return
	if ObjectID < 0 or ObjectID >= ObjectMap[z].size(): return

	# Broadcast removal to all clients
	rpc_id(0, "rpc_remove", ObjectID, z)  # 0 = everyone including server


# 3. LOCAL removal (runs on all peers)
@rpc("call_local")
func rpc_remove(ObjectID: int, z: int):
	remove_internal(ObjectID, z)


func remove_internal(ObjectID: int, z: int):
	if z < 0 or z >= ObjectMap.size():
		return
	if ObjectID < 0 or ObjectID >= ObjectMap[z].size():
		return

	var inst = ObjectMap[z][ObjectID]
	if inst != null:
		inst.queue_free()
		ObjectMap[z][ObjectID] = null



#register map

func get_all_objects():
	var all_objects=[]
	for row in ObjectMap:
		for object in row:
			all_objects.append(object)
	return all_objects
func register_existing_objects():

	for obj in get_tree().get_nodes_in_group("Object"):
		register_object(obj)

func register_object(obj: Node):
	var z =int(str(obj.get_node("../").name))
	obj.z=z
	obj.ObjectID = ObjectMap[z].size()
	ObjectMap[z].append(obj)

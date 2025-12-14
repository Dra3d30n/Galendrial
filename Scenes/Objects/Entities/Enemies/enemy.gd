extends "res://Scenes/Objects/Entities/entitiy.gd"

var detection_range = 256
var deviation_range = 1024
var patrol_target = null

@onready var initial_position = global_position


func pick_patrol_pos():
	# Pick a target around the initial spawn (ABSOLUTE position)
	patrol_target = initial_position + Vector2(
		randi_range(-deviation_range, deviation_range),
		randi_range(-deviation_range, deviation_range)
	)


func handle_patrol():
	# If no patrol target, pick one
	if patrol_target == null:
		pick_patrol_pos()

	# If close to target, pick a new one
	if global_position.distance_to(patrol_target) < 32:
		pick_patrol_pos()

	# Only set walk goal if we finished old goals
	if goals == []:
		goals = [["walk", [patrol_target]]]


func pathfind():
	var player_distance = global_position.distance_to(GameState.active_player.global_position)
	var home_distance = global_position.distance_to(initial_position)

	# ---- CHASE LOGIC ----
	if player_distance <= detection_range:
		goals = [["walk", [GameState.active_player.global_position]]]
		patrol_target = null
		return

	# ---- RETURN HOME ----
	if home_distance >= deviation_range:
		goals = [["walk", [initial_position]]]
		patrol_target = null
		return

	# ---- PATROL ----
	handle_patrol()

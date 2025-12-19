extends "res://Scenes/Objects/object.gd"

var goals: Array = []
@onready var animator: Node2D = $Animators
var item_range=32
var max_items=32
var inventory=[]
var equipped := {
	"body": null,
	"head": null,
	"chest": null,
	"hands": null,
	"legs": null,
	"feet": null,
	"offhand": null,
	"tool": null,
	"backpack": null,
	"mount": null
}
var animations={
	"idle":"Idle2",
	"walk":"Walk",
	"mine":"Attack4",
	"chop":"Attack2",
	"hit":"Hit",
	"collect":"Taunt"
	
}
var base_stats := {
	"speed": 50,
	"damage": 0,
	"health": 100,
	"max_health": 100
}

var stats = base_stats.duplicate()

func update(delta: float) -> void:


	if len(goals)==0:
		return
	var velocity=Vector2.ZERO
	handle_children(delta)

	velocity = match_goals()
	
	if multiplayer_authority:
		position += velocity * delta
	

func pathfind():
	return
# Define a dictionary mapping goal names to handler functions
var goal_handlers := {
	"walk": "handle_walk",
	"harvest": "handle_harvest",
	"hitstun": "handle_hitstun",
	"attack": "handle_attack",
	"add_item":"handle_add_item"
}

func match_goals() -> Vector2:
	if len(goals)<=0:
		return Vector2.ZERO

	var goal = goals[0]
	var goal_name = goal[0]
	var goal_vars = goal[1]

	var handler = goal_handlers[goal_name]
	if handler:
		return self.call(handler,goal_vars)
	return Vector2.ZERO

# Handler functions
func handle_walk(goal_vars) -> Vector2:
	var velocity = move_towards(goal_vars[0])
	return velocity
# Move towards a target
func move_towards(target_pos: Vector2) -> Vector2:
	var to_target = target_pos - position
	var distance = to_target.length()
	#NEEDWORK
	if distance <= item_range:  # reached target
		goals.pop_front()
		return Vector2.ZERO
	
	return to_target.normalized() * stats["speed"]

func handle_harvest(goal_vars) -> Vector2:
	if equipped['tool']:
		goal_vars[0].harvest(equipped['tool'])
		animator.play(goal_vars[1])
		goals.pop_front()
	return Vector2.ZERO

func handle_hitstun(goal_vars) -> Vector2:
	if animator.frame == animator.max_frame:
		goals.pop_front()
	return Vector2.ZERO

func handle_attack(goal_vars) -> Vector2:
	return Vector2.ZERO
# Animation function stays mostly the same
func animate(velocity: Vector2):
	if velocity == Vector2.ZERO:
		animator.play("south", animations["walk"])
	else:
		animator.play(Util.v2_to_cardinal(velocity), animations["walk"])
func handle_add_item(vars):
	if vars[0]:
		#NEEDLATER
		add_item(vars[1],vars[2])
# Update children
func handle_children(delta: float) -> void:
	animator.update(delta)


func _on_timer_timeout() -> void:
	pathfind()
# Add an item with a specific amount
func add_item(id, amount = 1) -> bool:
	# Try to stack if item already exists
	for entry in inventory:
		if entry["id"] == id:
			entry["amount"] += amount
			return true

	# If inventory is full, cannot add new item
	if inventory.size() >= max_items:
		return false

	# Otherwise, add new entry
	inventory.append({"id": id, "amount": amount})
	return true


# Remove a specific amount of an item
func remove_item(id, amount = 1) -> bool:
	for index in range(inventory.size()):
		if inventory[index]["id"] == id:
			if inventory[index]["amount"] > amount:
				inventory[index]["amount"] -= amount
			else:
				inventory.remove(index)  # remove entire entry if amount <= 0
			return true  # successfully removed
	return false  # item not found

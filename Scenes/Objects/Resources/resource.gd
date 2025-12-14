extends "res://Scenes/Objects/object.gd"
@export var level=1
@export var health: int = 10
@export var max_health: int = 10
@export var amount: int = 0
@export var item_id: int = 0
@export var state: bool = true    

@rpc("any_peer", "call_local") func rpc_destroy():
	destroy()

@rpc("any_peer", "call_local") func rpc_form():
	form()
func awake():
	awaken_values()
	synchronization_values=["health","state"]


func awaken_values():
	pass

func can_harvest(item: int) -> int:
	return 0


func harvest(item: int):
	if !state:
		return  

	health -= can_harvest(item)

	if health <= 0:
		GameState.active_player.add_item(item_id, amount)
		if multiplayer.is_server():
			rpc_destroy.rpc()


func destroy():
	state = false
	$AnimatedSprite2D.play("destroyed")
	$LifeTimer.start()


func form():
	state = true
	health = max_health
	$AnimatedSprite2D.play("formed")


func _on_life_timer_timeout() -> void:
	if multiplayer.is_server():
		rpc_form.rpc()

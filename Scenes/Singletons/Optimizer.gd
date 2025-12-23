extends Node

func _physics_process(delta: float) -> void:
	if GameState.active_player:
		for object in ObjectFactory.get_all_objects():
				object.set_physics_process(object.can_render())

		ObjectFactory.request_partial_sync(GameState.active_player.global_position)
		ObjectFactory.partial_purge(GameState.active_player.global_position)

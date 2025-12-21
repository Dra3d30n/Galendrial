# Attach this to the node you want fixed
@tool
extends Area2D

@export var fixed_position: Vector2 = Vector2.ZERO

func _process(_delta):
	# Only run in editor or runtime
	if Engine.is_editor_hint() or true:
		if position != fixed_position:
			position = fixed_position
		if $"CollisionPolygon2D".position!=fixed_position:
			$"CollisionPolygon2D".position=fixed_position
		if visible:
			visible=false

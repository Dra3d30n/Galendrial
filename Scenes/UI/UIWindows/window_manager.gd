extends Control

var start : Vector2
var initialPosition : Vector2
var isMoving : bool
var isResizing : bool
var resizeX : bool
var resizeY : bool
var initialSize : Vector2
@export var GrabThreshold := 20
@export var ResizeThreshold := 5
@export var can_be_resized := true

func _input(event):
	if Input.is_action_just_pressed("LeftMouse"):
		var rect = get_global_rect()
		var localMousePos = get_local_mouse_position()
		if abs(get_global_mouse_position().y-global_position.y) < GrabThreshold:
			start = event.position 
			print(start)

			initialPosition = global_position
			isMoving = true
		else:
			if can_be_resized:
				if abs(localMousePos.x - rect.size.x) < ResizeThreshold:
					start.x = event.position.x
					initialSize.x = get_size().x
					resizeX = true
					isResizing = true
				
				if abs(localMousePos.y - rect.size.y) < ResizeThreshold:
					start.y = event.position.y
					initialSize.y = get_size().y
					resizeY = true
					isResizing = true
				
				if localMousePos.x < ResizeThreshold && localMousePos.x > -ResizeThreshold:
					start.x = event.position.x
					initialPosition.x = get_global_position().x
					initialSize.x = get_size().x
					isResizing = true
					resizeX = true
					
				if localMousePos.y < ResizeThreshold && localMousePos.y > -ResizeThreshold:
					start.y = event.position.y
					initialPosition.y = get_global_position().y
					initialSize.y = get_size().y
					isResizing = true
					resizeY = true

		
	if Input.is_action_pressed("LeftMouse"):
		if isMoving:
			set_position(initialPosition + (event.position - start))
			clamp_to_screen()
		
		if isResizing and can_be_resized:
			# resize logic
			var newWidith = get_size().x
			var newHeight = get_size().y
			
			if resizeX:
				newWidith = initialSize.x - (start.x - event.position.x)
			if resizeY:
				newHeight = initialSize.y - (start.y - event.position.y)
				
			if initialPosition.x != 0:
				newWidith = initialSize.x + (start.x - event.position.x)
				set_position(Vector2(initialPosition.x - (newWidith - initialSize.x), get_position().y))
			
			if initialPosition.y != 0:
				newHeight = initialSize.y + (start.y - event.position.y)
				set_position(Vector2(get_position().x, initialPosition.y - (newHeight - initialSize.y)))
			
			set_size(Vector2(newWidith, newHeight))
			
		
	if Input.is_action_just_released("LeftMouse"):
		isMoving = false
		initialPosition = Vector2(0,0)
		resizeX = false
		resizeY = false
		isResizing = false
func clamp_to_screen():
	var vp_size = get_viewport_rect().size
	var rect = get_rect() # local rect
	var pos = position     # screen-space position

	# Right / bottom boundaries
	if pos.x + rect.size.x > vp_size.x:
		pos.x = vp_size.x - rect.size.x
	if pos.y + rect.size.y > vp_size.y:
		pos.y = vp_size.y - rect.size.y

	# Left / top boundaries
	if pos.x < 0:
		pos.x = 0
	if pos.y < 0:
		pos.y = 0

	position = pos


func _on_exit_pressed() -> void:
	UiManager.close_ui(str($"..".name))

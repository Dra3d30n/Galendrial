@tool
extends TextureButton

func _enter_tree():
	# Only try this if in the editor
	if Engine.is_editor_hint():
		# Set top-right anchors
		self.set_anchors_preset(Control.PRESET_TOP_RIGHT)
		# Optional: reset offsets so it hugs the corner
		self.offset_left = -self.rect_size.x
		self.offset_top = 0
		self.offset_right = 0
		self.offset_bottom = self.rect_size.y

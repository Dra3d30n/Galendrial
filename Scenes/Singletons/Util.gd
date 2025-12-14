extends Node

func v2_to_cardinal(v: Vector2, deadzone: float = 0.01) -> String:
	if v.length() <= deadzone:
		return "Origin"
	# Convert Godot coords (+y down) to math-style for atan2 (y up)
	var angle_deg := rad_to_deg(atan2(-v.y, v.x))  # 0 = E, 90 = N
	angle_deg = fposmod(angle_deg + 360.0, 360.0)  # normalize to [0,360)
	var idx := int((angle_deg + 22.5) / 45.0) % 8
	match idx:
		0: return "east"
		1: return "northeast"
		2: return "north"
		3: return "northwest"
		4: return "west"
		5: return "southwest"
		6: return "south"
		7: return "sotheast"
	return "South"  # fallback (shouldn't happen)

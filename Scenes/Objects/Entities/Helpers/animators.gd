extends Node2D

const MAX_SIZE = 160
@onready var player=$".."
var equipped = {}
@export var loaded_animations = {}
@export var current_animation = {}
var frame=0
var max_frame=15

func play(direction, animation):
	for slot in player.equipped.keys():
		var item = player.equipped[slot]
		var anim_node = get_node(slot)

		if item:
			anim_node.visible = true
			var anim_name = item + "_" + animation + "_" + direction

			# --- Skip if node is already playing this animation ---
			if anim_node.animation == anim_name:
				continue
			# -----------------------------------------------------

			# Lazy-load animation frames
			if not loaded_animations.has(item + "_" + animation):
				load_animation(anim_node, item, animation, direction)

			if loaded_animations.has(item + "_" + animation):
				anim_node.sprite_frames = loaded_animations[item + "_" + animation]

			anim_node.play(anim_name)
		else:
			anim_node.visible = false


var old_weapon = ""

func mine(direction):
	old_weapon = player.equipped["weapon"]
	player.equipped["weapon"] = "Pickaxe"
	play(direction, "Attack4")


func load_animation(anim_node: AnimatedSprite2D, item_name: String, animation: String, direction: String):
	var path = "res://Utilities/player frames/" + item_name + "_" + animation + ".res"

	if not FileAccess.file_exists(path):
		print("Animation not found:", path)
		return

	var sprite_frames = load(path) as SpriteFrames
	if sprite_frames:
		if loaded_animations.keys().size() >= MAX_SIZE:
			var first_key = loaded_animations.keys()[0]
			loaded_animations.erase(first_key)

		anim_node.sprite_frames = sprite_frames
		loaded_animations[item_name + "_" + animation] = sprite_frames


func print_spriteframes_info(sprite_frames: SpriteFrames) -> void:
	if not sprite_frames:
		print("No SpriteFrames assigned")
		return

	for anim_name in sprite_frames.get_animation_names():
		print("Animation:", anim_name, "Frames:", sprite_frames.get_frame_count(anim_name))


var accumulator := 0.0
const UPDATE_RATE := 0.1


func update(delta) -> void:
	for child in get_children():
		var slot = child.name

		# Skip if slot has no active animation
		if not current_animation.has(slot):
			continue

		var equip = player.equipped.get(slot)
		if equip == null:
			child.visible = false
			continue

		# Item + anim name only (NO direction in key)
		var anim_name = current_animation[slot][0]
		var direction = current_animation[slot][1]
		var key = equip + "_" + anim_name

		# Load the animation only when missing
		if not loaded_animations.has(key):
			load_animation(child, equip, anim_name, direction)

		# Set sprite_frames ONLY if different
		if child.sprite_frames != loaded_animations[key]:
			child.sprite_frames = loaded_animations[key]

		var full_anim = "%s_%s_%s" % [equip, anim_name, direction]

		# Only play if not already playing
		if child.animation != full_anim:
			child.play(full_anim)

		child.visible = true
	if $"body".sprite_frames:
		frame=$body.frame
		max_frame=$"body".sprite_frames.get_frame_count($"body".animation)


var frame_size = Vector2(128, 128)
var frames_per_animation = 15

var directions = [
	"east","southeast","south","southwest",
	"west","northwest","north","northeast"
]


func add_animations(anim_node: Node, directory: String) -> void:
	var all_animations = []
	var dir = DirAccess.open(directory)

	if not dir:
		print("Failed to open directory:", directory)
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()

	while file_name != "":
		if dir.current_is_dir() and file_name != "." and file_name != "..":
			var subfolder_path = directory + file_name
			print(subfolder_path)

			var pngs = []
			var sub_dir = DirAccess.open(subfolder_path)

			sub_dir.list_dir_begin()
			var sub_file = sub_dir.get_next()

			while sub_file != "":
				if not sub_dir.current_is_dir() and sub_file.ends_with(".png"):
					pngs.append([subfolder_path + "/" + sub_file, sub_file.get_basename()])
				sub_file = sub_dir.get_next()

			sub_dir.list_dir_end()
			all_animations.append({"folder": file_name, "pngs": pngs})

		file_name = dir.get_next()

	dir.list_dir_end()
	convert_to_animations(all_animations, anim_node)


func convert_to_animations(all_animations, anim_node):
	for item in all_animations:
		for png in item["pngs"]:
			add_animation_from_spritesheet(anim_node, png[0], item["folder"], png[1])


func add_animation_from_spritesheet(
	anim_node: AnimatedSprite2D,
	path: String,
	item_name: String,
	action_name: String,
	frame_width: int = 128,
	frame_height: int = 128,
	fps: float = 15.0
):
	var texture: Texture2D = load(path)
	if not texture:
		print("Failed to load texture:", path)
		return

	var img = texture.get_image()
	if img == null or img.get_width() == 0 or img.get_height() == 0:
		print("Image empty:", path)
		return

	var cols = img.get_width() / frame_width
	var rows = img.get_height() / frame_height

	var sprite_frames = SpriteFrames.new()

	for row in range(rows):
		var anim_name = item_name + "_" + action_name + "_" + directions[row]

		sprite_frames.add_animation(anim_name)
		sprite_frames.set_animation_speed(anim_name, fps)

		for col in range(cols):
			var slice_rect = Rect2(col * frame_width, row * frame_height, frame_width, frame_height)

			var frame_img = Image.create(frame_width, frame_height, false, img.get_format())
			frame_img.blit_rect(img, slice_rect, Vector2.ZERO)

			var frame_tex = ImageTexture.create_from_image(frame_img)
			sprite_frames.add_frame(anim_name, frame_tex)

	ResourceSaver.save(sprite_frames, "res://Utilities/player frames/" + item_name + "_" + action_name + ".res")


func combine_spriteframes(sf1: SpriteFrames, sf2: SpriteFrames) -> SpriteFrames:
	var combined := SpriteFrames.new()

	for anim_name in sf1.get_animation_names():
		combined.add_animation(anim_name)
		combined.set_animation_speed(anim_name, sf1.get_animation_speed(anim_name))
		combined.set_animation_loop(anim_name, sf1.get_animation_loop(anim_name))

		for i in range(sf1.get_frame_count(anim_name)):
			combined.add_frame(anim_name, sf1.get_frame_texture(anim_name, i))

	for anim_name in sf2.get_animation_names():
		if not combined.has_animation(anim_name):
			combined.add_animation(anim_name)
			combined.set_animation_speed(anim_name, sf2.get_animation_speed(anim_name))
			combined.set_animation_loop(anim_name, sf2.get_animation_loop(anim_name))

		for i in range(sf2.get_frame_count(anim_name)):
			combined.add_frame(anim_name, sf2.get_frame_texture(anim_name, i))

	return combined


func _run():
	add_animations(null, "res://Assets/.../Backpacks/")
	add_animations(null, "res://Assets/.../Offhands/")
	add_animations(null, "res://Assets/.../Chestpieces/")
	add_animations(null, "res://Assets/.../Hands/")
	add_animations(null, "res://Assets/.../Helmets/")
	add_animations(null, "res://Assets/.../Boots/")
	add_animations(null, "res://Assets/.../Pants/")
	add_animations(null, "res://Assets/.../Bodies/")
	add_animations(null, "res://Assets/.../Magic Weapons/")
	add_animations(null, "res://Assets/.../Ranged Weapons/")
	add_animations(null, "res://Assets/.../Melee Weapons/")
	add_animations(null, "res://Assets/.../Mounts/")

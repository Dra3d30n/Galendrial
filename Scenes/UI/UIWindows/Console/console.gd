extends Control

@onready var log: RichTextLabel = $WindowManager/RichTextLabel

const MAX_LINES := 200

func _ready():
	log.bbcode_enabled = true
	log.scroll_active = true
	log.fit_content = true

# Toggle visibility (bind to ~ or F1)
func toggle():
	visible = !visible

# Public API
func add(text: String, color := "white"):
	log.append_text("[color=%s]%s[/color]\n" % [color, text])
	_trim()
	_scroll_to_bottom()

# Categories (optional helpers)
func info(text):	add(text, "black")
func success(text):	add(text, "darkgreen")
func warn(text):	add(text, "yellow")
func error(text):	add(text, "red")
func system(text):	add(text, "darkblue")

# Internal helpers
func _trim():
	while log.get_line_count() > MAX_LINES:
		log.remove_line(0)

func _scroll_to_bottom():
	log.scroll_to_line(log.get_line_count())

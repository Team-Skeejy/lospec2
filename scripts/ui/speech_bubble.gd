class_name SpeechBubble
extends PanelContainer

@onready var label : Label = $Label
@onready var despawn_timer : Timer = $DespawnTimer

var text_speed : int = 20 # in chars/second
var despawn_time : float = 0.5 # how much time after showing all text will it despawn
var _visible_characters : float = 0.0
var _started : bool = true

func init(text: String, color: String):
	label.text = text
	var c : Color
	if color == 'b':
		c = Color.hex(0x000000ff)
	elif color == 'g':
		c = Color.hex(0x007062ff)
		#c = Color.hex(0x0aff0aff) # brighter green
	elif color == 'r':
		c = Color.hex(0xff032bff)
	else:
		c = Color.hex(0x260a34ff)

	label.add_theme_color_override("font_color", c)
	label.visible_ratio = 0.0
	_started = true

func _process(delta: float): # show more characters
	if not _started:
		return
	
	_visible_characters += delta * text_speed
	label.visible_characters = int(_visible_characters)
	if label.visible_ratio >= 1.0:
		despawn_timer.start(despawn_time)
		_started = false

func _on_despawn_timer_timeout():
	queue_free()

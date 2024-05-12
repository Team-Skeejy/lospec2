class_name SpeechBubble
extends PanelContainer

@onready var label : Label = $Label
@onready var despawn_timer : Timer = $DespawnTimer
@onready var visible_notifier : VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

var text_speed : int = 20 # in chars/second
var despawn_time : float = 0.5 # how much time after showing all text will it despawn
var _visible_characters : float = 0.0
var _started : bool = true
enum State {
	GROWING, # when the label is becoming bigger
	READABLE,# when info can be gained 
	READ 	 # when info has already been optained
}
var curr_state : State 

enum Type {
	BUY,
	SELL,
	SMALL_TALK
}
var curr_type : Type 

signal seen(t: Type)

func init(text: String, type: Type):
	label.text = text
	var color : Color
	if type == Type.SMALL_TALK:
		color = Color.hex(0x000000ff)
	elif type == Type.BUY:
		color = Color.hex(0x007062ff)
		#c = Color.hex(0x0aff0aff) # brighter green
	elif type == Type.SELL:
		color = Color.hex(0xff032bff)
	else:
		color = Color.hex(0x260a34ff)

	label.add_theme_color_override("font_color", color)
	label.visible_ratio = 0.0
	_started = true
	curr_state = State.GROWING
	curr_type = type
	
	

func _process(delta: float): 
	if not _started:
		return
		

	if curr_state == State.READ:
		return
	# show more characters
	if curr_state == State.GROWING: 
		_visible_characters += delta * text_speed
		label.visible_characters = int(_visible_characters)
		
		# when all chars are shown, make it readable
		if label.visible_ratio >= 1.0: 
			despawn_timer.start(despawn_time)
			visible_notifier.rect.size.x = size.x
			curr_state = State.READABLE
	# when it's readable and on screen, read it
	elif curr_state == State.READABLE and visible_notifier.is_on_screen(): 
		seen.emit(curr_type)
		curr_state = State.READ

func _on_despawn_timer_timeout():
	queue_free()

func on_seen():
	seen.emit()
	visible_notifier

class_name SpeechBubble
extends PanelContainer

@export var label : Label 
@export var despawn_timer : Timer 
@export var visible_notifier1 : VisibleOnScreenNotifier2D 
@export var visible_notifier2 : VisibleOnScreenNotifier2D 
@export var style_box : StyleBoxTexture
var text_speed : int = 20 # in chars/second
var despawn_time : float = 1. # how much time after showing all text will it despawn
var _visible_characters : float = 0.0
var _started : bool = true

enum State {
	GROWING, # when the label is becoming bigger
	READABLE,# when info can be gained 
	READ, 	 # when info has already been obtained
	DESPAWNING 
}
var curr_state : SpeechBubble.State

enum Type {
	BUY,
	SELL,
	SMALL_TALK
}
var curr_type : SpeechBubble.Type 

signal seen(t: Type)

func init(text: String, type: Type):
	label.text = text
	var color : Color
	if type == Type.SMALL_TALK:
		color = Color.hex(0x000000ff)
	elif type == Type.BUY:
		#color = Color.hex(0x007062ff)
		color = Color.hex(0x0aff0aff) # brighter green
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
		
	# show more characters
	elif curr_state == State.GROWING: 
		_visible_characters += delta * text_speed
		label.visible_characters = int(_visible_characters)
		
		# when all chars are shown, make it readable
		if label.visible_ratio >= 1.0: 
			despawn_timer.start(despawn_time)
			visible_notifier2.position.x = size.x - 20
			curr_state = State.READABLE
			
	# when it's readable and on screen, read it
	elif curr_state == State.READABLE and \
		visible_notifier1.is_on_screen() and \
		visible_notifier2.is_on_screen(): 
		seen.emit(curr_type)
		curr_state = State.READ
		if curr_type == Type.SELL:
			style_box.region_rect.position = Vector2(112, 32)
		elif curr_type == Type.BUY:
			style_box.region_rect.position = Vector2(112, 64)
			
		
	#wait for the despawn timer
	if curr_state == State.READ:
		return
	
	# despawn
	elif curr_state == State.DESPAWNING:
		_visible_characters -= delta * text_speed * 4.
		if _visible_characters <= 0.:
			queue_free()
		label.visible_characters = int(_visible_characters)

func _on_despawn_timer_timeout():
	curr_state = State.DESPAWNING

func on_seen():
	seen.emit()

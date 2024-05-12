class_name DialogueGenerator
extends Node2D


@export var speech_bubble_scene : PackedScene
var speech_bubble_spacing : int = 20
var speech_bubble_movement_speed : float = 0.1
func _ready():
	pass
	
func _process(delta):
	if Input.is_action_just_pressed("A"): #for testing
		var _t = [SpeechBubble.Type.SELL, SpeechBubble.Type.BUY, SpeechBubble.Type.SMALL_TALK].pick_random()
		new_speech_bubble(_t)


func new_speech_bubble(type: SpeechBubble.Type):
	var speech_bubble_y : int = 0
	for child in get_children().filter(func(x): return x is SpeechBubble):
	
		var tween : Tween = get_tree().create_tween()
		tween.tween_property(child, 
							"position:y", 
							child.position.y - speech_bubble_spacing,
							speech_bubble_movement_speed
						)
			
	var speech_bubble : SpeechBubble = speech_bubble_scene.instantiate()
	add_child(speech_bubble)
	
	var text : String = ""
	if type == SpeechBubble.Type.BUY:
		text = Global.buy_dialogue[randi() % len(Global.buy_dialogue)]
	elif type == SpeechBubble.Type.SELL:
		text = Global.sell_dialogue[randi() % len(Global.sell_dialogue)]
	elif type == SpeechBubble.Type.SMALL_TALK:
		text = Global.small_talk_dialogue[randi() % len(Global.small_talk_dialogue)]
	
	speech_bubble.init(text, type)
	speech_bubble.seen.connect(_on_seen)

var debug_num_seen : int = 0
@onready var debug_label : Label = $Camera2D/Label

func _on_seen(type):
	debug_num_seen += 1
	debug_label.text = str(debug_num_seen)
	print(type)

















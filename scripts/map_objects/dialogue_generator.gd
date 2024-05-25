class_name DialogueGenerator
extends Node2D


@export var speech_bubble_scene: PackedScene
@export var npc: NPC
@export var dialogue_area : Area2D

var speech_bubble_spacing: int = 16
var speech_bubble_movement_speed: float = 0.1
var dialogue_timer: Timer
var dialogue_time_interval: float = 3.

var has_info_to_give : bool = true
static var RESPONSE_TIME := 0.4

func check_requirements() -> bool:
	return true

var completed : bool :
	get:
		if npc:
			return not has_info_to_give or (npc.company in InformationManager.instance.completed_companies)
		else:
			return false

func _ready():
	Global.instance.new_speech_bubble.connect(_on_new_speech_bubble)

func respond_to_small_talk():
	await get_tree().create_timer(RESPONSE_TIME).timeout
	if not npc:
		return
		
	if check_requirements() and not completed:  # if requirements are met generate green or red bubbles
		var _t = [SpeechBubble.Type.SELL, SpeechBubble.Type.BUY].pick_random()
		new_dialogue_speech_bubble(_t)
		has_info_to_give = false
		Global.instance.new_notification_no_texture("AHAHAHAHAHAHAHAHAHAH")
		
	else:  # if not, generate small talk
		new_dialogue_speech_bubble(SpeechBubble.Type.SMALL_TALK)
		Global.instance.new_notification_no_texture("WOWOWOWOWOWOWOWOWOW")

func add_speech_bubble(speech_bubble: SpeechBubble):
	add_child(speech_bubble)
	Global.instance.new_speech_bubble.emit(global_position)

func new_custom_speech_bubble(text:String, type:SpeechBubble.Type):
	var speech_bubble: SpeechBubble = speech_bubble_scene.instantiate()
	speech_bubble.init(text, type, false) # Custom speech bubbles don't change colour when readq
	add_speech_bubble(speech_bubble)

func new_dialogue_speech_bubble(type: SpeechBubble.Type):
	var speech_bubble: SpeechBubble = speech_bubble_scene.instantiate()
	if completed:
		speech_bubble.set_completed()

	var text: String = ""
	if type == SpeechBubble.Type.BUY:
		text = Global.instance.buy_dialogue[randi() % len(Global.instance.buy_dialogue)]
	elif type == SpeechBubble.Type.SELL:
		text = Global.instance.sell_dialogue[randi() % len(Global.instance.sell_dialogue)]
	elif type == SpeechBubble.Type.SMALL_TALK:
		text = Global.instance.small_talk_dialogue[randi() % len(Global.instance.small_talk_dialogue)]

	speech_bubble.init(text, type)
	add_speech_bubble(speech_bubble)
	
	if npc:
		speech_bubble.seen.connect(_on_seen)



func _on_seen(type: SpeechBubble.Type):
	if not npc:
		return
		
	if type == SpeechBubble.Type.SMALL_TALK:
		return
	
	if type == SpeechBubble.Type.BUY:
		InformationManager.instance.add_info(npc.company, InformationManager.Type.BUY)
	elif type == SpeechBubble.Type.SELL:
		InformationManager.instance.add_info(npc.company, InformationManager.Type.SELL)

static var Y_DISTANCE_THRESHOLD = 20

func _on_new_speech_bubble(pos: Vector2):
	if abs(pos.y - global_position.y) > Y_DISTANCE_THRESHOLD:
		return
		
	for child in get_children().filter(func(x): return x is SpeechBubble):
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(child,
							"position:y",
							child.position.y - speech_bubble_spacing,
							speech_bubble_movement_speed
						)

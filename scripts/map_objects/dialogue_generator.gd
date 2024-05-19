class_name DialogueGenerator
extends Node2D


@export var speech_bubble_scene: PackedScene
@export var npc : NPC
var speech_bubble_spacing: int = 16
var speech_bubble_movement_speed: float = 0.1
var dialogue_timer: Timer
var dialogue_time_interval: float = 3.

func check_requirements() -> bool:
	return true

func _ready():
	dialogue_timer = Timer.new()
	add_child(dialogue_timer)
	dialogue_timer.timeout.connect(_on_dialogue_timer_timeout)
	dialogue_timer.wait_time = dialogue_time_interval
	dialogue_timer.start()

func _on_dialogue_timer_timeout():
	if check_requirements() and npc.company not in InformationManager.instance.completed_companies:  # if requirements are met generate green or red bubbles
		var _t = [SpeechBubble.Type.SELL, SpeechBubble.Type.BUY].pick_random()
		new_speech_bubble(_t)
	else:  # if not, generate small talk
		new_speech_bubble(SpeechBubble.Type.SMALL_TALK)

func new_speech_bubble(type: SpeechBubble.Type):
	for child in get_children().filter(func(x): return x is SpeechBubble):

		var tween: Tween = get_tree().create_tween()
		tween.tween_property(child,
							"position:y",
							child.position.y - speech_bubble_spacing,
							speech_bubble_movement_speed
						)

	var speech_bubble: SpeechBubble = speech_bubble_scene.instantiate()
	add_child(speech_bubble)

	var text: String = ""
	if type == SpeechBubble.Type.BUY:
		text = Global.instance.buy_dialogue[randi() % len(Global.instance.buy_dialogue)]
	elif type == SpeechBubble.Type.SELL:
		text = Global.instance.sell_dialogue[randi() % len(Global.instance.sell_dialogue)]
	elif type == SpeechBubble.Type.SMALL_TALK:
		text = Global.instance.small_talk_dialogue[randi() % len(Global.instance.small_talk_dialogue)]

	speech_bubble.init(text, type)
	speech_bubble.seen.connect(_on_seen)



func _on_seen(type: SpeechBubble.Type):
	if type == SpeechBubble.Type.SMALL_TALK:
		return
	elif type == SpeechBubble.Type.BUY:
		InformationManager.instance.add_info(npc.company, InformationManager.Type.BUY)
	elif type == SpeechBubble.Type.SELL:
		InformationManager.instance.add_info(npc.company, InformationManager.Type.SELL)
















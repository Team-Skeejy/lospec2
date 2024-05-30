class_name BossArea
extends Node2D

@export var talk_zone: Area2D
@export var boss: NPC
@export var ending_door: HideDoor

var done := false

func on_body_entered(node: Node2D):
	if node is Player:
		var player := node as Player
		var sequence := BossSequence.new(self)
		player.add_behaviour(sequence)

		if sequence.player_has_landed:
			begin()
		else:
			sequence.is_ready.connect(begin)

# Called when the node enters the scene tree for the first time.
func _ready():
	talk_zone.body_entered.connect(on_body_entered)

# func _process(delta):
# 	if turn_left && !turned_left:


func begin():
	if done: return
	Global.player.up_press(0)
	await get_tree().create_timer(4.).timeout

	var tween: Tween = create_tween()
	tween.tween_property(Global.player.camera, "global_position", boss.global_position, 1.)
	await tween.finished

	boss.dialogue_generator.has_info_to_give = false

	await boss.dialogue_generator.new_custom_speech_bubble("I've been expecting you...", SpeechBubble.Type.SMALL_TALK).closed
	await get_tree().create_timer(1.).timeout
	await boss.dialogue_generator.new_custom_speech_bubble("Mr Journalist...", SpeechBubble.Type.SMALL_TALK).closed

	var remove = boss.behaviours.filter(func(behaviour): return behaviour is Sit)
	for behaviour in remove:
		boss.remove_behaviour(behaviour)

	await get_tree().create_timer(1.).timeout

	await boss.dialogue_generator.new_custom_speech_bubble("I've been watching your plights", SpeechBubble.Type.SMALL_TALK).closed
	await boss.dialogue_generator.new_custom_speech_bubble("You think you've got me cornered...", SpeechBubble.Type.SMALL_TALK).closed
	await boss.dialogue_generator.new_custom_speech_bubble("But it is I who is the hunter...", SpeechBubble.Type.SMALL_TALK).closed
	await boss.dialogue_generator.new_custom_speech_bubble("And you...", SpeechBubble.Type.SMALL_TALK).closed

	# await get_tree().physics_frame
	var turn = Vector2(boss.global_position.x - NPC.ARRIVAL_THRESHOLD, boss.global_position.y)
	boss.destination = turn
	await boss.dialogue_generator.new_custom_speech_bubble("the hunted!", SpeechBubble.Type.SMALL_TALK).closed

	await get_tree().create_timer(3.).timeout

	await boss.dialogue_generator.new_custom_speech_bubble("You have lost your way Mr Journalist", SpeechBubble.Type.SMALL_TALK).closed

	await get_tree().create_timer(1.).timeout

	await boss.dialogue_generator.new_custom_speech_bubble("In order to reach me", SpeechBubble.Type.SMALL_TALK).closed
	await boss.dialogue_generator.new_custom_speech_bubble("You've lied", SpeechBubble.Type.SMALL_TALK).closed
	await boss.dialogue_generator.new_custom_speech_bubble("And cheated", SpeechBubble.Type.SMALL_TALK).closed
	await boss.dialogue_generator.new_custom_speech_bubble("And...", SpeechBubble.Type.SMALL_TALK).closed
	await boss.dialogue_generator.new_custom_speech_bubble("Uh...", SpeechBubble.Type.SMALL_TALK).closed
	await boss.dialogue_generator.new_custom_speech_bubble("Wait... you double jumped?", SpeechBubble.Type.SMALL_TALK).closed
	await boss.dialogue_generator.new_custom_speech_bubble("Whatever", SpeechBubble.Type.SMALL_TALK).closed
	await boss.dialogue_generator.new_custom_speech_bubble("You've climbed my beautiful spire", SpeechBubble.Type.SMALL_TALK).closed

	await get_tree().create_timer(1.).timeout

	await boss.dialogue_generator.new_custom_speech_bubble("And in your blind pursuit", SpeechBubble.Type.SMALL_TALK).closed
	await boss.dialogue_generator.new_custom_speech_bubble("You've become what you hate the most", SpeechBubble.Type.SMALL_TALK).closed
	await boss.dialogue_generator.new_custom_speech_bubble("You've become one of us...", SpeechBubble.Type.SMALL_TALK).closed

	tween = create_tween()
	tween.tween_property(Global.player.camera, "position", Vector2.ZERO, 0.5)
	await tween.finished
	await get_tree().create_timer(1.).timeout

	Global.player.up_press(0)
	await get_tree().create_timer(4.).timeout

	tween = create_tween()
	tween.tween_property(Global.player.camera, "global_position", boss.global_position, 0.5)
	await tween.finished
	await get_tree().create_timer(1.).timeout

	await boss.dialogue_generator.new_custom_speech_bubble("...", SpeechBubble.Type.SMALL_TALK).closed

	await get_tree().create_timer(3.).timeout

	await boss.dialogue_generator.new_custom_speech_bubble("Do you actually even know how to talk?", SpeechBubble.Type.SMALL_TALK).closed

	tween = create_tween()
	tween.tween_property(Global.player.camera, "position", Vector2.ZERO, 0.5)
	await tween.finished
	await get_tree().create_timer(1.).timeout
	Global.player.up_press(0)
	await get_tree().create_timer(4.).timeout
	tween = create_tween()
	tween.tween_property(Global.player.camera, "global_position", boss.global_position, 0.5)
	await tween.finished
	await get_tree().create_timer(1.).timeout

	await boss.dialogue_generator.new_custom_speech_bubble("Wow...", SpeechBubble.Type.SMALL_TALK).closed

	await get_tree().create_timer(3.).timeout
	await boss.dialogue_generator.new_custom_speech_bubble("Whatever the case...", SpeechBubble.Type.SMALL_TALK).closed

	await get_tree().create_timer(1.).timeout
	await boss.dialogue_generator.new_custom_speech_bubble("What is a day trader?", SpeechBubble.Type.SMALL_TALK).closed
	await boss.dialogue_generator.new_custom_speech_bubble("But a miserable", SpeechBubble.Type.SMALL_TALK).closed
	await boss.dialogue_generator.new_custom_speech_bubble("pile", SpeechBubble.Type.SMALL_TALK).closed
	await boss.dialogue_generator.new_custom_speech_bubble("of", SpeechBubble.Type.SMALL_TALK).closed
	await boss.dialogue_generator.new_custom_speech_bubble("secrets...", SpeechBubble.Type.SMALL_TALK).closed

	boss.destination = ending_door.global_position
	await boss.on_arrival

	await boss.dialogue_generator.new_custom_speech_bubble("I'll be seeing you", SpeechBubble.Type.SMALL_TALK).closed

	boss.interact_target._interact(boss)

	tween = create_tween()
	tween.tween_property(Global.player.camera, "position", Vector2.ZERO, 1.)
	await tween.finished

	done = true

	remove = Global.player.behaviours.filter(func(behaviour): return behaviour is BossSequence)
	for behaviour in remove:
		Global.player.remove_behaviour(behaviour)

	await get_tree().create_timer(15.).timeout


	await boss.dialogue_generator.new_custom_speech_bubble("...", SpeechBubble.Type.SMALL_TALK).closed

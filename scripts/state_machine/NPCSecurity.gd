class_name NPCSecurity
extends NPCState

static var WARNING_TIME := 2.
var countdown := WARNING_TIME

var seen_before := false

var cooling_down := false

@export var danger_zone: Area2D
@export var on_idle: String

@export var alert: Alert

func on_danger_zone(body: Node2D):
	if body is Player:
		cooling_down = false

func on_undanger_zone(body: Node2D):
	if body is Player:
		cooling_down = true

func Enter() -> void:
	countdown = WARNING_TIME
	cooling_down = false
	if danger_zone.get_overlapping_bodies().any(func(body): return body is Player):
		danger_zone.body_entered.connect(on_undanger_zone)
		danger_zone.body_exited.connect(on_undanger_zone)
		# Yell at player
		# TODO
		if seen_before:
			npc.dialogue_generator.new_custom_speech_bubble("You again?! Scram!", SpeechBubble.Type.SELL)
		else:
			npc.dialogue_generator.new_custom_speech_bubble("OI, get outta here!", SpeechBubble.Type.SELL)
			seen_before = true
	else:
		transitioned.emit(self, on_idle)

var done := false
func Update(delta: float) -> void:
	var player_direction := Humanoid.EDirection.right if npc.global_position.x < Global.player.global_position.x else Humanoid.EDirection.left

	if player_direction != npc._facing:
		npc._facing = player_direction

	if cooling_down: countdown = move_toward(countdown, WARNING_TIME, delta)
	else: countdown = move_toward(countdown, 0, delta)

	if alert: alert.progress = (WARNING_TIME - countdown) / WARNING_TIME

	if cooling_down && countdown >= WARNING_TIME:
		transitioned.emit(self, on_idle)
		npc.dialogue_generator.new_custom_speech_bubble("Yeah... and stay out", SpeechBubble.Type.SELL)

	if !cooling_down && countdown <= 0 && !done:
		done = true
		npc.dialogue_generator.new_custom_speech_bubble("Alright... You're coming with me", SpeechBubble.Type.SELL)
		Global.instance.go_to_next_phase()
		Global.instance.store_player_and_transition_to("res://scenes/ui/kicked_out.tscn")

func Exit() -> void:
	if danger_zone && danger_zone.body_exited.is_connected(on_undanger_zone):
		danger_zone.body_exited.disconnect(on_undanger_zone)

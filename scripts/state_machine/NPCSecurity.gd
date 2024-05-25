class_name NPCSecurity
extends NPCState

static var WARNING_TIME := 2.
var countdown := WARNING_TIME

var seen_before := false

@export var danger_zone: Area2D
@export var on_idle: String

func on_undanger_zone(body: Node2D):
	if body is Player:
		transitioned.emit(self, on_idle)

func Enter() -> void:
	countdown = WARNING_TIME
	if danger_zone.get_overlapping_bodies().any(func(body): return body is Player):
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
	if countdown > 0:
		countdown = move_toward(countdown, 0, delta)
	elif !done:
		done = true
		print_debug("send the player to the shadow realm")
		npc.dialogue_generator.new_custom_speech_bubble("Alright... You're coming with me", SpeechBubble.Type.SELL)
		Global.instance.go_to_next_phase()
		Global.instance.store_player_and_transition_to("res://scenes/ui/kicked_out.tscn")

func Exit() -> void:
	if danger_zone && danger_zone.body_exited.is_connected(on_undanger_zone):
		danger_zone.body_exited.disconnect(on_undanger_zone)

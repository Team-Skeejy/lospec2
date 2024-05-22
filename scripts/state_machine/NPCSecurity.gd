class_name NPCSecurity
extends NPCState

static var WARNING_TIME := 5.
var countdown := WARNING_TIME

var seen_before := false

@export var danger_zone: Area2D

func on_undanger_zone(body: Node2D):
	if body is Player:
		transitioned.emit(self, "NPCIdle")

func Enter() -> void:
	countdown = WARNING_TIME
	if danger_zone.get_overlapping_bodies().any(func(body): return body is Player):
		danger_zone.body_exited.connect(on_undanger_zone)
		# Yell at player
		# TODO
		if seen_before:
			print_debug("You again?! Scram!")
		else:
			print_debug("OI, get outta here!")
			seen_before = true
	else:
		transitioned.emit(self, "NPCIdle")

func Process(delta: float) -> void:
	if countdown > 0:
		countdown = move_toward(countdown, 0, delta)
	else:
		# TODO
		# Yell at player
		# npc.dialog_generator.new_speech_bubble(SpeechBubble.Type.SELL, "Alright... You're coming with me")
		print_debug("send the player to the shadow realm")
		Global.instance.go_to_next_phase()

func Exit() -> void:
	if danger_zone && danger_zone.body_exited.is_connected(on_undanger_zone):
		danger_zone.body_exited.disconnect(on_undanger_zone)
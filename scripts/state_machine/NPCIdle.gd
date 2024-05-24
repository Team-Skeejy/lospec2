class_name NPCIdle
extends NPCState

@export var idle_to: String = "NPCPatrol"
@export var on_alert: String = "NPCGuardAlert"


@export var danger_zone: Area2D

var timer: Timer
static var IDLE_TIME = 2.

func on_danger_zone(body: Node2D):
	if body is Player:
		transitioned.emit(self, on_alert)

func Enter() -> void:

	# create a timer and wait for it to start wandering
	timer = Timer.new()
	timer.wait_time = IDLE_TIME
	timer.one_shot = true
	add_child(timer)
	timer.start()
	timer.timeout.connect(_on_timer_timeout)

func Update(_delta: float):
	if !danger_zone: return
	var players := danger_zone.get_overlapping_bodies().filter(func(body): return body is Player)
	for player in players:
		if player.behaviours.any(func(behaviour): return behaviour is Hide):
			continue
		else:
			transitioned.emit(self, on_alert)

func Exit() -> void:
	if timer.timeout.is_connected(_on_timer_timeout):
		timer.timeout.disconnect(_on_timer_timeout)

	if danger_zone && danger_zone.body_entered.is_connected(on_danger_zone):
		danger_zone.body_entered.disconnect(on_danger_zone)


func _on_timer_timeout():
	transitioned.emit(self, idle_to)

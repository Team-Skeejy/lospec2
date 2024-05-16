class_name NPCIdle
extends NPCState

@export var idle_to : String = "NPCPatrol"
var timer : Timer
static var IDLE_TIME = 2.

func Enter() -> void:
	# create a timer and wait for it to start wandering
	timer = Timer.new()
	timer.wait_time = IDLE_TIME
	timer.one_shot = true
	add_child(timer)
	timer.start()
	timer.timeout.connect(_on_timer_timeout)
	
func Exit() -> void:
	timer.timeout.disconnect(_on_timer_timeout)
	

func _on_timer_timeout():
	transitioned.emit(self, idle_to)

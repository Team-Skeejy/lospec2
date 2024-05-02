class_name PostIt
extends Item

@export var number_of_jumps : int = 2
var jumps_available : int = 0
@onready var player : Player = get_parent()
@onready var timer : Timer = $Timer
var active = false


func _ready():
	player.first_jump.connect(activate)

func _physics_process(_delta:float):
	
	if not active:
		return
	
	if player.is_on_floor():
		deactivate()
		return
	
	if not timer.is_stopped():
		return
	
	if Input.is_action_just_pressed("A"):
		player.jump()
		jumps_available -= 1
		if jumps_available <= 0:
			deactivate()

func activate():
	if number_of_jumps <= 1:
		return
	active = true
	timer.start()
	jumps_available = number_of_jumps - 1

func deactivate():
	active = false
	timer.stop()

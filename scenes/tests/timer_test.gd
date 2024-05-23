extends Node2D

@export var lbl_part: Label
@export var lbl_of: Label
@export var lbl_time_remaining: Label

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.instance.time_changed.connect(on_time_changed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float):
	if Input.is_action_just_pressed("A"):
		Global.instance.reset_timer()
	lbl_time_remaining.text = str(int(Global.instance.time_limit_countdown))

func on_time_changed(part: int, of: int):
	lbl_part.text = str(part)
	lbl_of.text = str(of)

func _on_button_button_down():
	Global.instance.reset_timer()

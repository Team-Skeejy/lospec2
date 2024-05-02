extends Control

@export var label: Label

func _physics_process(_delta: float):
	var pressed: String = ""
	if Input.is_action_pressed("Up"):
		pressed += "Up\n"
	if Input.is_action_pressed("Down"):
		pressed += "Down\n"
	if Input.is_action_pressed("Left"):
		pressed += "Left\n"
	if Input.is_action_pressed("Right"):
		pressed += "Right\n"
	if Input.is_action_pressed("A"):
		pressed += "A\n"
	if Input.is_action_pressed("B"):
		pressed += "B\n"
	if Input.is_action_pressed("Start"):
		pressed += "Start\n"
	if Input.is_action_pressed("Select"):
		pressed += "Select\n"
	label.text = pressed

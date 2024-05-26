extends Control

@export var settings_menu: SettingsMenu

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float):
	if Input.is_action_just_pressed("Select"):
		_flip_paused()
		settings_menu.visible = not settings_menu.visible
	elif Input.is_action_just_pressed("Start"):
		get_tree().paused = false
		Global.instance.go_to_phase(Global.GamePhase.intro)




func _flip_paused():
	get_tree().paused = not get_tree().paused

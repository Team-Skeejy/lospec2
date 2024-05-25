extends Control

@export var settings_menu : SettingsMenu
@export_file("*.tscn") var game_scene

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Select"):
		_flip_paused()
		settings_menu.visible = not settings_menu.visible
	elif Input.is_action_just_pressed("Start"):
		get_tree().paused = false
		FadeTransition.instance.transition_to(game_scene)
	


func _flip_paused():
	get_tree().paused = not get_tree().paused

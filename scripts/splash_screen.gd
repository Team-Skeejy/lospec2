extends Control

@export var animationPlayer: AnimationPlayer

var ignore_animation_end := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -4)
	if OS.get_name() == "Web":
		get_tree().change_scene_to_file(FadeTransition.MAIN_MENU)
	else:
		animationPlayer.play("sleepy_fade")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(_ev: InputEvent) -> void:
	if Input.is_action_just_pressed("Select"):
		print_debug("REMOVE ME REMOVE ME")
		Global.instance.go_to_phase(Global.GamePhase.platformer)
		ignore_animation_end = true
	elif Input.is_anything_pressed():
		FadeTransition.instance.transition_to(FadeTransition.MAIN_MENU)
		ignore_animation_end = true

func _on_animation_player_animation_finished(_animation: StringName) -> void:
	if ignore_animation_end: return
	FadeTransition.instance.transition_to(FadeTransition.MAIN_MENU)

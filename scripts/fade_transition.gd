extends Node
class_name FadeTransition

static var SPLASH_SCREEN: StringName = "res://scenes/splash_screen/splash_screen.tscn"
static var MAIN_MENU: StringName = "res://scenes/main_menu/main_menu.tscn"
static var GAME: StringName = "res://scenes/game/game.tscn"


static var instance: FadeTransition

@export var animationPlayer: AnimationPlayer
@onready var starting_volume: float = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	FadeTransition.instance = self
	animationPlayer.play("fade_in")

var nextScene: StringName
func transition_to(scene: StringName) -> void:
	nextScene = scene;
	animationPlayer.play("fade_out")

func _change_scene() -> void:
	get_tree().change_scene_to_file(nextScene)
	animationPlayer.play("fade_in")

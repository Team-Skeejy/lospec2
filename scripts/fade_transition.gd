extends Node
class_name FadeTransition

static var SPLASH_SCREEN: StringName
static var MAIN_MENU: StringName
static var GAME: StringName

static var instance: FadeTransition

@export var animationPlayer: AnimationPlayer

@export_category("scenes")
@export_file("*.tscn") var splash_screen: String
@export_file("*.tscn") var main_menu: String
@export_file("*.tscn") var game: String


@onready var starting_volume: float = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SPLASH_SCREEN = splash_screen
	MAIN_MENU = main_menu
	GAME = game

	FadeTransition.instance = self
	animationPlayer.play("fade_in")

var next_scene: StringName

func transition_to(scene: StringName) -> void:
	next_scene = scene
	animationPlayer.play("fade_out")

func _change_scene() -> void:
	if next_scene:
		get_tree().change_scene_to_file(next_scene)

	next_scene = ""
	animationPlayer.play("fade_in")

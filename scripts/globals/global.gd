class_name Global
extends Node

static var GRAVITY: float = ProjectSettings.get_setting("physics/2d/default_gravity")

static var instance: Global
@export_category("Items")
@export var all_items : Array[ItemResource]
@export_category("Nodes")
@export var player_storage: Node
@export var player_scene: PackedScene
@export_file("*.tscn") var intro_scene: String
@export_file("*.tscn") var tutorial_scene: String
@export_file("*.tscn") var platformer_scene: String
@export_file("*.tscn") var shop_scene: String
@export_file("*.tscn") var home_scene: String
@export_file("*.tscn") var test_game_scene: String
@export_file("*.tscn") var test_shop_scene: String
@export_file("*.tscn") var test_bet_scene: String

static var player: Player
var player_money: int = 50

var sell_dialogue: PackedStringArray
var buy_dialogue: PackedStringArray
var small_talk_dialogue: PackedStringArray

static var all_companies: Array[String] = [
	"Crimson Co",
	"Greenland Oil",
	"Blue Inc.",
	"Yellower",
	"Cylantro",
	"B.I.M.",
	"Vatican llc"
]

signal new_speech_bubble(pos: Vector2)

func _ready():
	Global.instance = self
	
	# I do this in global because I don't want to open files everytime a new dialogue generator is created
	setup_dialogue()
	setup_items()

func setup_items():
	# yes this is the actual way you look for all files in a path
	var items_path := "res://assets/items/"
	var dir = DirAccess.open(items_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			all_items.append(ResourceLoader.load(items_path+file_name))
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("An error occurred when trying to access " + items_path)
	
	
	
func setup_dialogue():
	var sell_file_path = "res://assets/text/sell_dialogue.txt"
	var file_access: FileAccess = FileAccess.open(sell_file_path, FileAccess.READ)
	sell_dialogue = file_access.get_as_text().split("\n", false)

	var buy_file_path = "res://assets/text/buy_dialogue.txt"
	file_access = FileAccess.open(buy_file_path, FileAccess.READ)
	buy_dialogue = file_access.get_as_text().split("\n", false)

	var small_talk_file_path = "res://assets/text/small_talk_dialogue.txt"
	file_access = FileAccess.open(small_talk_file_path, FileAccess.READ)
	small_talk_dialogue = file_access.get_as_text().split("\n", false)

func store_player():
	if player:
		player.reparent(player_storage)

func spawn_player(parent: Node2D, spawn_point: Node2D):
	if !player:
		player = player_scene.instantiate()
		parent.add_child.call_deferred(player)
	else:
		player.reparent.call_deferred(parent)

	player.global_position = spawn_point.global_position
	player.physics_enabled = true

enum GamePhase {
	intro, tutorial, platformer, shop, home, test_platformer, test_shop, test_bet
}

var current_phase: GamePhase = GamePhase.intro

func store_player_and_transition_to(next_scene: String):
	player.physics_enabled = false
	await FadeTransition.instance.transition_to(next_scene, store_player)

func go_to_phase(phase: GamePhase):
	match (phase):
		GamePhase.intro:
			FadeTransition.instance.transition_to(platformer_scene)
		GamePhase.tutorial:
			FadeTransition.instance.transition_to(platformer_scene)
		GamePhase.platformer:
			FadeTransition.instance.transition_to(platformer_scene)
		GamePhase.shop:
			FadeTransition.instance.transition_to(shop_scene)
		GamePhase.home:
			FadeTransition.instance.transition_to(home_scene)
		GamePhase.test_platformer:
			store_player_and_transition_to(test_game_scene)
		GamePhase.test_bet:
			store_player_and_transition_to(test_bet_scene)
		GamePhase.test_shop:
			store_player_and_transition_to(test_shop_scene)

func go_to_next_phase():
	match (current_phase):
		GamePhase.intro:
			current_phase = GamePhase.tutorial
		GamePhase.tutorial:
			current_phase = GamePhase.shop
		GamePhase.shop:
			current_phase = GamePhase.home
		GamePhase.home:
			current_phase = GamePhase.platformer
		GamePhase.platformer:
			current_phase = GamePhase.shop
		GamePhase.test_platformer:
			current_phase = GamePhase.test_bet
		GamePhase.test_bet:
			current_phase = GamePhase.test_shop
		GamePhase.test_shop:
			current_phase = GamePhase.test_platformer
	go_to_phase(current_phase)

func update_money(change: int):
	player_money += change

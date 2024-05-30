class_name Global
extends Node

static var GRAVITY: float = ProjectSettings.get_setting("physics/2d/default_gravity")

static var TIME_LIMIT: float = 2 * 60  # 2 minute time limit
static var TIME_DIVISIONS: int = 8 * 6  # 8 hr days, divided into 10 minute segments
static var TIME_SEGMENT_LENGTH: float = TIME_LIMIT / TIME_DIVISIONS
var run_timer: bool = false
var time_limit_countdown: float = TIME_LIMIT
var prev_time_signal_at: int = 0
signal time_changed(part: int, of: int)
signal time_out

static var instance: Global
@export_category("Audio")
@export_file("*.wav") var menu_music: String
@export_file("*.wav") var intro_music: String
@export_file("*.wav") var game_music: String
@export_file("*.wav") var stock_market_music: String
@export_file("*.wav") var shop_music: String
@export var audio_player: AudioStreamPlayer

var current_track: String
var audio_stream: AudioStreamWAV

@export_category("Items")
@export var all_items: Array[ItemResource]

@export_category("Nodes")
@export var player_storage: Node
@export var player_scene: PackedScene
@export_file("*.tscn") var menu_scene: String
@export_file("*.tscn") var intro_scene: String

@export_file("*.tscn") var tutorial_platformer_scene: String
@export_file("*.tscn") var tutorial_stockmarket_scene: String
@export_file("*.tscn") var tutorial_shop_scene: String

@export_file("*.tscn") var platformer_scene: String
@export_file("*.tscn") var stock_market_scene: String
@export_file("*.tscn") var shop_scene: String

@export_file("*.tscn") var test_game_scene: String
@export_file("*.tscn") var test_shop_scene: String
@export_file("*.tscn") var test_bet_scene: String

static var player: Player
var player_money: int = 50

var sell_dialogue: PackedStringArray
var buy_dialogue: PackedStringArray
var small_talk_dialogue: PackedStringArray

# key: company_name (str), value company_resource (CompanyResource)
static var companies: Dictionary = {}

signal new_speech_bubble(pos: Vector2)

var volume: Dictionary = {
	"Music": 50,
	"SFX" : 50
}
var crt_ghost_intensity: float = 0.0
var scanline_intensity: float = 0.0

func _ready():
	Global.instance = self

	# I do this in global because I don't want to open files everytime a new dialogue generator is created
	setup_dialogue()
	setup_items()
	setup_companies()
	print_debug(companies)

func try_emit_time_signal():
	var parts: int = (time_limit_countdown / TIME_SEGMENT_LENGTH) + 1
	if time_limit_countdown == 0 && prev_time_signal_at != 0:
		prev_time_signal_at = 0
		time_changed.emit(0, TIME_DIVISIONS)
		time_out.emit()
	elif parts != prev_time_signal_at:
		if time_limit_countdown == 0 && prev_time_signal_at == 0:
			pass
		else:
			prev_time_signal_at = parts
			time_changed.emit(parts, TIME_DIVISIONS)

func _process(delta: float):
	if !run_timer: return
	time_limit_countdown = move_toward(time_limit_countdown, 0, delta)
	try_emit_time_signal()

func setup_items():
	# yes this is the actual way you look for all files in a path
	var items_path := "res://assets/items/"
	var dir = DirAccess.open(items_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			all_items.append(ResourceLoader.load(items_path + file_name))
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("An error occurred when trying to access " + items_path)

func setup_companies():
	var items_path := "res://assets/companies/"
	var dir = DirAccess.open(items_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			var resource = ResourceLoader.load(items_path + file_name)
			companies[resource.company_name] = resource
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
	menu,
	intro,

	tutorial_platformer,
	tutorial_stock_market,
	tutorial_shop,

	platformer,
	stock_market,
	shop,

	test_platformer,
	test_shop,
	test_bet
}

var current_phase: GamePhase = GamePhase.intro

func store_player_and_transition_to(next_scene: String):
	if player:
		player.physics_enabled = false
	await FadeTransition.instance.transition_to(next_scene, store_player)

func set_track(file: String):
	if file == current_track: return
	current_track = file
	audio_stream = load(file)
	var position := audio_player.get_playback_position()
	audio_player.stream = audio_stream
	audio_player.play(position)

func go_to_phase(phase: GamePhase):
	current_phase = phase
	run_timer = false
	match (phase):
		GamePhase.menu:
			set_track(menu_music)
			FadeTransition.instance.transition_to(menu_scene)
		GamePhase.intro:
			set_track(intro_music)
			store_player_and_transition_to(intro_scene)
		GamePhase.tutorial_platformer:
			set_track(game_music)
			store_player_and_transition_to(tutorial_platformer_scene)
			reset_timer()
		GamePhase.tutorial_stock_market:
			set_track(stock_market_music)
			store_player_and_transition_to(tutorial_stockmarket_scene)
			zero_timer()
		GamePhase.tutorial_shop:
			set_track(shop_music)
			store_player_and_transition_to(tutorial_shop_scene)
			zero_timer()

		GamePhase.platformer:
			set_track(game_music)
			store_player_and_transition_to(platformer_scene)
			reset_timer()
			run_timer = true
		GamePhase.stock_market:
			set_track(stock_market_music)
			store_player_and_transition_to(stock_market_scene)
			zero_timer()
		GamePhase.shop:
			set_track(shop_music)
			store_player_and_transition_to(shop_scene)
			zero_timer()

		GamePhase.test_platformer:
			set_track(game_music)
			store_player_and_transition_to(test_game_scene)
			reset_timer()
			run_timer = true
		GamePhase.test_bet:
			set_track(stock_market_music)
			store_player_and_transition_to(test_bet_scene)
			zero_timer()
		GamePhase.test_shop:
			set_track(shop_music)
			store_player_and_transition_to(test_shop_scene)
			zero_timer()

func go_to_next_phase():
	time_limit_countdown = 0
	match (current_phase):
		GamePhase.menu: go_to_phase(GamePhase.intro)
		GamePhase.intro: go_to_phase(GamePhase.tutorial_platformer)

		GamePhase.tutorial_platformer: go_to_phase(GamePhase.tutorial_stock_market)
		GamePhase.tutorial_stock_market: go_to_phase(GamePhase.tutorial_shop)
		GamePhase.tutorial_shop: go_to_phase(GamePhase.platformer)

		GamePhase.platformer: go_to_phase(GamePhase.stock_market)
		GamePhase.stock_market: go_to_phase(GamePhase.shop)
		GamePhase.shop: go_to_phase(GamePhase.platformer)

		GamePhase.test_platformer: go_to_phase(GamePhase.test_bet)
		GamePhase.test_bet: go_to_phase(GamePhase.test_shop)
		GamePhase.test_shop: go_to_phase(GamePhase.test_platformer)

func update_money(change: int):
	player_money += change

func zero_timer():
	time_limit_countdown = 0
	prev_time_signal_at = 0
	time_changed.emit(0, TIME_DIVISIONS)

func reset_timer():
	time_limit_countdown = TIME_LIMIT
	prev_time_signal_at = TIME_DIVISIONS
	time_changed.emit(TIME_DIVISIONS, TIME_DIVISIONS)

func new_notification_no_texture(text: String, length: float = Notification.DEFAULT_DESPAWN_TIME) -> Notification:
	return player.ui.new_notification_no_texture(text, length)

func new_notification_with_texture(text: String, texture: Texture, dark: bool, length: float = Notification.DEFAULT_DESPAWN_TIME) -> Notification:
	return player.ui.new_notification_with_texture(text, texture, dark, length)

static func is_tutorial() -> bool:
	return instance.current_phase == GamePhase.tutorial_platformer \
	|| instance.current_phase == GamePhase.tutorial_shop \
	|| instance.current_phase == GamePhase.tutorial_stock_market


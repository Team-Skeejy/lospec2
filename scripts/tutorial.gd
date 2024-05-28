class_name Tutorial
extends Node2D

static var PARTS := 14

@export var tutorial_item: ItemResource
@export var tutorial_door: Interactable

var player_pressed_left_right := false
var player_pressed_a := false
var player_pressed_down := false

var player_has_interacted := false
var player_has_got_item := false
var player_has_opened_inventory := false
var player_has_closed_inventory := false

var player_has_talked_to_coworker_1 := false
var player_has_talked_to_coworker_2 := false
var player_has_talked_to_coworker_3 := false
var player_has_talked_to_coworker_4 := false
var player_has_talked_to_coworker_5 := false

func set_time(part: int):
	Global.instance.time_limit_countdown = (Global.TIME_LIMIT / PARTS) * (PARTS - part)
	Global.instance.try_emit_time_signal()

func _input(_event: InputEvent):
	if Input.is_action_just_pressed("Left") || Input.is_action_just_pressed("Right"):
		player_pressed_left_right = true
	if Input.is_action_just_pressed("A"):
		player_pressed_a = true
	if Input.is_action_just_pressed("Down"):
		player_pressed_down = true


func door_interacted():
	pass

func item_added(item: ItemResource):
	if item == tutorial_item:
		player_has_got_item = true


# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.instance.current_phase != Global.GamePhase.tutorial_platformer: queue_free()
	await get_tree().process_frame

	Global.player.item_added.connect(item_added)

	Global.instance.reset_timer()
	await get_tree().create_timer(2.).timeout

	# salutations
	await Global.instance.new_notification_no_texture("Hello!", 2).notification_ended
	await Global.instance.new_notification_no_texture("Lets get you started", 3).notification_ended
	set_time(1)


	# movement
	var notif: Notification = Global.instance.new_notification_no_texture("Press [<] and [>] to move", 0)
	while (!player_pressed_left_right): await get_tree().process_frame
	notif.close()
	set_time(2)

	# a to jump
	notif = Global.instance.new_notification_no_texture('Press [A] to jump', 0)
	while (!player_pressed_a): await get_tree().process_frame
	notif.close()
	set_time(3)

	# down to drop down
	notif = Global.instance.new_notification_no_texture('Press [v] to drop down platforms', 0)
	while (!player_pressed_down): await get_tree().process_frame
	notif.close()
	set_time(3)

	# press b to interact
	await Global.instance.new_notification_no_texture('Press [B] on objects to interact').notification_ended
	notif = Global.instance.new_notification_no_texture('Lets open that door by pressing [B]', 0)
	while (!player_has_interacted): await get_tree().process_frame
	notif.close()
	set_time(4)

	# press b to pick up item
	notif = Global.instance.new_notification_no_texture('Press [B] over that book to pick it up', 0)
	while (!player_has_got_item): await get_tree().process_frame
	notif.close()
	set_time(5)

	# press start to open menu
	notif = Global.instance.new_notification_no_texture('Nice, what did you get?\nPress [START] to open your inventory', 0)
	while (!player_has_opened_inventory): await get_tree().process_frame
	notif.close()
	set_time(6)

	# press start to close menu
	notif = Global.instance.new_notification_no_texture('Nice, a book on small talk!\nPress [START] again to close your inventory', 0)
	while (!player_has_closed_inventory): await get_tree().process_frame
	notif.close()
	set_time(7)

	# talk to coworkers
	await Global.instance.new_notification_no_texture('Lets small talk to some "coworkers"', 3).notification_ended
	notif = Global.instance.new_notification_no_texture('Press [^] to talk to coworkers', 0)
	while (!player_has_talked_to_coworker_1): await get_tree().process_frame
	notif.close()
	set_time(8)

	notif = Global.instance.new_notification_no_texture('Talk to 4 more "coworkers"', 0)
	while (!player_has_talked_to_coworker_2): await get_tree().process_frame
	notif.close()
	set_time(9)

	notif = Global.instance.new_notification_no_texture('Talk to 3 more "coworkers"', 0)
	while (!player_has_talked_to_coworker_3): await get_tree().process_frame
	notif.close()
	set_time(10)

	notif = Global.instance.new_notification_no_texture('Talk to 2 more "coworkers"', 0)
	while (!player_has_talked_to_coworker_4): await get_tree().process_frame
	notif.close()
	set_time(11)

	notif = Global.instance.new_notification_no_texture('Talk to 1 more "coworker"', 0)
	while (!player_has_talked_to_coworker_5): await get_tree().process_frame
	notif.close()
	set_time(12)

	await Global.instance.new_notification_no_texture('Good Job!', 3).notification_ended
	await Global.instance.new_notification_no_texture("There's a clock in the bottom left of your screen", 3).notification_ended
	await Global.instance.new_notification_no_texture("It shows how much time you have left", 3).notification_ended
	await Global.instance.new_notification_no_texture("It looks like everyone's about to go home...", 3).notification_ended
	Global.instance.run_timer = true

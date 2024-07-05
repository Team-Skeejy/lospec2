class_name UI
extends CanvasLayer

var open_close_speed := 0.5

var is_opened: bool = false
#const open_menu_position := Vector2(-128, -112)
const open_menu_position := Vector2()
const closed_menu_position := Vector2(0, 192)

var tween: Tween
@export var notification_scene: PackedScene
@export var menu: TextureRect
@export var interaction_name: Label
@export var interaction_texture: TextureRect
@export var money_label: Label
@export var settings_menu: SettingsMenu
@export var crt_effects: ColorRect
@export var info_ui: InformationUI
@export var inventory: Inventory
@export var notification_holder: Control
@export var close_map_label: Label

func _ready():
	info_ui.retract()
	pass

func _process(_delta: float):
	if Global.player.interact_target && is_instance_valid(Global.player.interact_target):
		interaction_name.text = Global.instance.player.interact_target.interaction_name
		interaction_texture.show()
	elif interaction_name:
		interaction_name.text = ""
		interaction_texture.hide()

	money_label.text = str(Global.instance.player_money) + "$"

	if Input.is_action_just_pressed("Start") and not Global.instance.player.zoomed_out:
		if is_opened:
			close()
		else:
			open()

	# only check for other inputs if it's not opened

	if Input.is_action_just_pressed("Select"):
		if is_opened:
			settings_menu.visible = not settings_menu.visible
		elif Global.instance.current_phase == Global.GamePhase.platformer or Global.instance.current_phase == Global.GamePhase.tutorial_platformer:
			if Global.instance.player.zoomed_out:
				Global.instance.player.camera.zoom = Vector2(1, 1)
				Global.instance.player.camera.limit_bottom = 32
				Global.instance.player.zoomed_out = false
				_unpause()
				close_map_label.hide()

			else:
				Global.instance.player.camera.zoom = Vector2(0.25, 0.25)
				Global.instance.player.camera.limit_bottom = 32 * 4
				Global.instance.player.zoomed_out = true
				_pause()
				close_map_label.show()


	elif is_opened and Input.is_action_just_pressed("A") and not settings_menu.visible:
		info_ui.flip_expanded()

func open():
	if tween and tween.is_running():
		return

	_flip_paused()

	tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(menu, "position", open_menu_position, open_close_speed)
	tween.tween_callback(_is_opened_true)
	tween.tween_callback(_pause)

func close():
	print_debug("closing time")
	if tween and tween.is_running():
		return

	settings_menu.hide()
	info_ui.retract()
	tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(menu, "position", closed_menu_position, open_close_speed)
	tween.tween_callback(_is_opened_false)
	tween.tween_callback(_unpause)
	return tween.tween_callback

func _flip_is_opened():
	is_opened = not is_opened

func _is_opened_true():
	is_opened = true

func _is_opened_false():
	is_opened = false

func _flip_paused():
	get_tree().paused = not get_tree().paused

func _pause():
	get_tree().paused = true

func _unpause():
	get_tree().paused = false

func update_items():
	inventory.update_items()

func new_notification_no_texture(text: String, length: float = Notification.DEFAULT_DESPAWN_TIME) -> Notification:
	var notif := notification_scene.instantiate()
	notif.despawn_time = length
	if Global.is_tutorial(): add_child(notif)
	else: notification_holder.add_child(notif)
	notif.start_no_texture(text)
	return notif

func new_notification_with_texture(text: String, texture: Texture, dark: bool, length: float = Notification.DEFAULT_DESPAWN_TIME) -> Notification:
	var notif := notification_scene.instantiate()
	notif.despawn_time = length
	if Global.is_tutorial(): add_child(notif)
	else: notification_holder.add_child(notif)
	notif.start_with_texture(text, texture, dark)
	return notif

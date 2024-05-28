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
@export var money_label: Label
@export var settings_menu: SettingsMenu
@export var crt_effects: ColorRect
@export var info_ui: InformationUI
@export var inventory: Inventory
@export var notification_holder: Control
func _ready():
	info_ui.retract()
	pass

func _process(_delta: float):
	if Global.player.interact_target && is_instance_valid(Global.player.interact_target):
		interaction_name.text = Global.player.interact_target.interaction_name
	elif interaction_name:
		interaction_name.text = ""

	money_label.text = str(Global.instance.player_money) + "$"

	if Input.is_action_just_pressed("Start"):
		if is_opened:
			close()
		else:
			open()

	# only check for other inputs if it's not opened
	if not is_opened:
		return

	if Input.is_action_just_pressed("Select"):
		settings_menu.visible = not settings_menu.visible


	elif Input.is_action_just_pressed("A") and not settings_menu.visible:
		info_ui.flip_expanded()

func open():
	if tween and tween.is_running():
		return

	_flip_paused()

	tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(menu, "position", open_menu_position, open_close_speed)
	tween.tween_callback(_flip_is_opened)

func close():
	if tween and tween.is_running():
		return

	settings_menu.hide()
	info_ui.retract()
	tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(menu, "position", closed_menu_position, open_close_speed)
	tween.tween_callback(_flip_is_opened)
	tween.tween_callback(_flip_paused)

func _flip_is_opened():
	is_opened = not is_opened

func _flip_paused():
	get_tree().paused = not get_tree().paused

func update_items():
	inventory.update_items()

func new_notification_no_texture(text: String, length: float = Notification.DEFAULT_DESPAWN_TIME) -> Notification:
	var notif := notification_scene.instantiate()
	notif.despawn_time = length
	notification_holder.add_child(notif)
	notif.start_no_texture(text)
	return notif

func new_notification_with_texture(text: String, texture: Texture, dark: bool, length: float = Notification.DEFAULT_DESPAWN_TIME) -> Notification:
	var notif := notification_scene.instantiate()
	notif.despawn_time = length
	notification_holder.add_child(notif)
	notif.start_with_texture(text, texture, dark)
	return notif

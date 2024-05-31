class_name SettingsMenu
extends CenterContainer


@export var settings_container: VBoxContainer
@export var ghost_setting: GhostSetting
@export var scan_line_setting: ScanLineSetting
@export var crt_texture: ColorRect

var selected_row: int = 0


func _ready():
	select(selected_row)
	ghost_setting.init(crt_texture)
	scan_line_setting.init(crt_texture)

func select(row):
	settings_container.get_children()[selected_row].deselect()

	if row < 0:
		row = len(settings_container.get_children()) - 1
	if row == len(settings_container.get_children()):
		row = 0

	selected_row = row
	settings_container.get_children()[selected_row].select()

func get_selected_row():
	return settings_container.get_children()[selected_row]

func _process(delta):
	if not visible:
		return
	if Input.is_action_just_pressed("Left"):
		Global.instance.positive_sfx.play()
		get_selected_row().left()
	elif Input.is_action_just_pressed("Right"):
		Global.instance.positive_sfx.play()
		get_selected_row().right()
	elif Input.is_action_just_pressed("Up"):
		Global.instance.positive_sfx.play()
		select(selected_row -1)
	elif Input.is_action_just_pressed("Down"):
		Global.instance.positive_sfx.play()
		select(selected_row + 1)
	elif Input.is_action_just_pressed("B"):
		Global.instance.positive_sfx.play()
		hide()

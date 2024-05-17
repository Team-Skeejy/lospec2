class_name SettingsMenu
extends CenterContainer


@export var settings_container : VBoxContainer

var selected_row : int = 0

func _ready():
	select(selected_row)

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
	if Input.is_action_just_pressed("Left"):
		get_selected_row().left()
	elif Input.is_action_just_pressed("Right"):
		get_selected_row().right()
	elif Input.is_action_just_pressed("Up"):
		select(selected_row-1)
	elif Input.is_action_just_pressed("Down"):
		select(selected_row+1)
	elif Input.is_action_just_pressed("B"):
		hide()
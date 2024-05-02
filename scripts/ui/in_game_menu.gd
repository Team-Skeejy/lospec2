extends Control

var open_close_speed := 0.5

var is_opened : bool = false
#const open_menu_position := Vector2(-128, -112)
const open_menu_position := Vector2()
const closed_menu_position := Vector2(0, 192)

var tween : Tween

@onready var menu : TextureRect = $TextureRect

func _ready():
	pass



func _process(_delta: float):
	if Input.is_action_just_pressed("Start"):
		if is_opened:
			close()
		else:
			open()
			
func open():
	_flip_paused()
	get_tree().paused = true
	if tween and tween.is_running():
		tween.kill()
	tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(menu, "position", open_menu_position, open_close_speed)
	tween.tween_callback(_flip_is_opened)
	
func close():
	if tween and tween.is_running():
		tween.kill()
	tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(menu, "position", closed_menu_position, open_close_speed)
	tween.tween_callback(_flip_is_opened)
	tween.tween_callback(_flip_paused)
	
	

func _flip_is_opened():
	is_opened = not is_opened



func _flip_paused():
	get_tree().paused = not get_tree().paused
	

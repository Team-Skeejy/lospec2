extends Control

var open_close_speed := 0.5

var is_opened : bool = false
const closed_menu_position := Vector2(0, 192)

var tween : Tween

func _ready():
	pass



func _process(delta):
	print(delta)
	if Input.is_action_just_pressed("Start") :
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
	tween.tween_property($ColorRect, "position", Vector2(0, 0), open_close_speed)
	tween.tween_callback(_flip_is_opened)
	
func close():
	if tween and tween.is_running():
		tween.kill()
	tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property($ColorRect, "position", closed_menu_position, open_close_speed)
	tween.tween_callback(_flip_is_opened)
	#tween.tween_callback(_flip_paused)
	

func _flip_is_opened():
	is_opened = not is_opened

func _flip_paused():
	get_tree().paused = not get_tree().paused
	

extends Control

var open_close_speed := 0.5


func _ready():
	var tween = get_tree().create_tween()
	tween.tween_property($ColorRect, "position", Vector2(), open_close_speed)



func _process(delta):
	pass

extends HBoxContainer

@export var hour_texture : TextureRect
@export var minute_texture : TextureRect
@export var ten_min_timer : Timer 

var hour_length : float = 1.
var t : float = hour_length

var n_hours := 8
var n_minutes := 5

var h := n_hours
var m := 0

var h0_pos = Vector2(0, 64)
var m0_pos = Vector2(16, 64)

signal day_over 

func _ready():
	start()

func start():
	h = n_hours
	m = 0
	set_textures()

func _on_ten_minute_timer_timeout():
	m -= 1
	if m < 0:
		m = n_minutes
		h -= 1
	
	if h < 0:
		day_over.emit()
	
	set_textures()

func set_textures():
	hour_texture.texture.region.position = h0_pos + Vector2(0, 16) * h
	minute_texture.texture.region.position = m0_pos + Vector2(0, 16) * m

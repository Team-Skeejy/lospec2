extends HBoxContainer

@export var hour_texture: TextureRect
@export var minute_texture: TextureRect

var h0_pos = Vector2(0, 64)
var m0_pos = Vector2(16, 64)

static var HOURS_IN_DAY = 8

func update_time(part: int, of: int):
	print_debug(part, of)
	var parts_per_hour := of / 8
	var hrs := part / parts_per_hour
	var mins_bit := part % parts_per_hour
	set_time(hrs, mins_bit)


func _ready():
	Global.instance.time_changed.connect(update_time)
	update_time(Global.instance.prev_time_signal_at, Global.TIME_DIVISIONS)

func set_time(hours: int, ten_minutes: int):
	hour_texture.texture.region.position = h0_pos + Vector2(0, 16) * hours
	minute_texture.texture.region.position = m0_pos + Vector2(0, 16) * ten_minutes

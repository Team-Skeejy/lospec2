class_name VolumeSetting
extends SettingRow

@export var slider : HSlider
@export var bus : String

func _ready():
	slider.value_changed.connect(_on_h_slider_value_changed)
	slider.value = Global.instance.volume[bus]

func left():
	slider.value -= slider.step
	
func right():
	slider.value += slider.step
	

func _on_h_slider_value_changed(value):
	Global.instance.volume[bus] = value
	var volume_db: float = remap(value, 0, 100, -40, -4)
	if value == 0:
		volume_db = -INF
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus), volume_db)
	

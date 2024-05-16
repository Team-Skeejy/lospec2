class_name VolumeSetting
extends SettingRow

var volume : int = 50
@export var slider : HSlider


func _ready():
	slider.value = volume

func left():
	slider.value -= slider.step
	
func right():
	slider.value += slider.step
	

func _on_h_slider_value_changed(value):
	var volume_db: float = remap(value, 0, 100, -40, -4)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume_db)
	

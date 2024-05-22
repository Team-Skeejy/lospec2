class_name GhostSetting
extends SettingRow

var ghosting : float = 0.3
@export var slider : HSlider

var crt_texture : ColorRect
var crt_material : ShaderMaterial

func init(texture: ColorRect):
	crt_texture = texture
	crt_material = crt_texture.material
	slider.value = ghosting

func left():
	slider.value -= slider.step
	
func right():
	slider.value += slider.step
	

func _on_h_slider_value_changed(value):
	crt_material.set_shader_parameter("crt_ghost", value)

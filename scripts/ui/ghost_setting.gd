class_name GhostSetting
extends SettingRow

var ghosting : float = 0.3
@export var slider : HSlider

@export var crt_ghost_texture : ColorRect
var crt_ghost_material : ShaderMaterial
var ghost_scale:float = 0.7

func _ready():
	crt_ghost_material = crt_ghost_texture.material
	slider.value = ghosting

func left():
	slider.value -= slider.step
	
func right():
	slider.value += slider.step
	

func _on_h_slider_value_changed(value):
	crt_ghost_material.set_shader_parameter("crt_ghost", value*ghost_scale)

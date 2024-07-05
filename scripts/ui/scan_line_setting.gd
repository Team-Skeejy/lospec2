class_name ScanLineSetting
extends SettingRow


@export var slider: HSlider

var crt_texture: ColorRect
var crt_material: ShaderMaterial

func init(texture: ColorRect):
	crt_texture = texture
	crt_material = crt_texture.material
	slider.value = Global.instance.scanline_intensity
	crt_material.set_shader_parameter("scan_line_intensity", Global.instance.scanline_intensity)

func left():
	slider.value -= slider.step

func right():
	slider.value += slider.step


func _on_h_slider_value_changed(value):
	Global.instance.scanline_intensity = value
	crt_material.set_shader_parameter("scan_line_intensity", value)

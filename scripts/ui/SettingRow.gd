class_name SettingRow
extends HBoxContainer

@onready var indicator : TextureRect = $Indicator # It always needs to be the first child, so it's fine

func select():
	indicator.texture.region.position.x = 16

func deselect():
	indicator.texture.region.position.x = 0
	
func left():
	pass

func right():
	pass

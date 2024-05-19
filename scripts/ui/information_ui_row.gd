class_name InformationUIRow
extends HBoxContainer


@export var info_textures : Array[TextureRect]
@export var company_label : Label
var info_gathered = 0

var red_position := Vector2(32, 34)
var green_position := Vector2(48, 34)
var invisible_position := Vector2(64, 34)

signal full

func _ready():
	for t : TextureRect in info_textures:
		t.texture.region.position = invisible_position

func set_company(company: String):
	company_label.text = company

func add_buy_info():
	print_debug('buyinfo')
	info_textures[info_gathered].texture.region.position = green_position
	info_gathered += 1
	
func add_sell_info():
	print_debug('sellinfo')
	info_textures[info_gathered].texture.region.position = red_position
	info_gathered += 1
	


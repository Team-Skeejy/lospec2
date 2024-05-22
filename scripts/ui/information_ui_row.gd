class_name InformationUIRow
extends HBoxContainer


@export var info_textures : Array[TextureRect]
@export var company_label : Label
@export var tickbox : TextureRect
var tickbox_empty_pos = Vector2(35, 99)
var tickbox_full_pos = Vector2(35, 83)
var info_gathered = 0

var red_position := Vector2(32, 34)
var green_position := Vector2(48, 34)
var empty_position := Vector2(64, 34)

signal full

func _ready():
	for t : TextureRect in info_textures:
		t.texture.region.position = empty_position

func set_company(company: String):
	company_label.text = company

func reset():
	company_label.text = "........................"
	tickbox.texture.region.position = tickbox_empty_pos
	info_gathered = 0
	for texture in info_textures:
		texture.texture.region.position = empty_position

func add_buy_info():
	info_textures[info_gathered].texture.region.position = green_position
	incr_info()
	
func add_sell_info():
	info_textures[info_gathered].texture.region.position = red_position
	incr_info()

func incr_info():
	info_gathered += 1	
	if info_gathered == InformationManager.MAX_INFO_PER_COMPANY:
		tickbox.texture.region.position = tickbox_full_pos

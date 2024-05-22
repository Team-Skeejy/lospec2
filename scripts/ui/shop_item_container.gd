class_name ShopItemContainer
extends PanelContainer

@export var item_resource: ItemResource
@export var style_box: StyleBoxTexture
@export var item_texture: TextureRect
@export var sold_out_texture: AtlasTexture

var selected: bool = false
var sold_out: bool = false

signal on_selected(sic: ShopItemContainer)

func _ready():
	item_texture.texture = item_resource.texture


func buy() -> ItemResource:
	if sold_out:
		print_debug("This shouldn't be happening")
		return null
	sold_out = true
	item_texture.texture = sold_out_texture
	item_resource.for_sale = false
	return item_resource

func select():
	if selected: return
	selected = true
	style_box.region_rect.position.x += 32
	on_selected.emit(self)

func deselect():
	if not selected: return
	style_box.region_rect.position.x -= 32
	selected = false

func darken():
	item_texture.modulate = Color.hex(0x0000000FF)
	
func brighten():
	item_texture.modulate = Color.hex(0x0FFFFFFFF)
	

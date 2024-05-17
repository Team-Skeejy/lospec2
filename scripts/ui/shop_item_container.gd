class_name ShopItemContainer
extends PanelContainer

@export_category("Item Parameters")
@export var item_name: String = "Item Name"
@export var price: int = 420
@export var item: Item = null
@export var description: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam vitae lorem sit amet purus malesuada feugiat non vel nibh."

@export var style_box: StyleBoxTexture
# @export var item_sprite: TextureRect

var selected: bool = false
var sold: bool = false

signal on_selected(sic: ShopItemContainer)

func _ready():
	pass
	# var atlas_texture: AtlasTexture = item_sprite.texture
	# atlas_texture.region.position.x = (randi() % 8) * 32


func select():
	if selected: return
	selected = true
	style_box.region_rect.position.x += 32
	on_selected.emit(self)

func deselect():
	if not selected: return
	style_box.region_rect.position.x -= 32
	selected = false

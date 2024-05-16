class_name ShopItemContainer
extends PanelContainer

var item : String # TODO switch to whatever changyi makes
@export var style_box : StyleBoxTexture
@export var item_sprite : TextureRect

var selected : bool = false

signal on_selected(sic: ShopItemContainer)

func _ready():
	item = "something"
	var atlas_texture : AtlasTexture = item_sprite.texture
	atlas_texture.region.position.x = (randi() % 8) * 32


func select():
	if selected:
		return
	style_box.region_rect.position.x += 32
	selected = true
	on_selected.emit(self)

func deselect():
	if not selected:
		return
	style_box.region_rect.position.x -= 32
	selected = false

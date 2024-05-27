class_name Inventory
extends GridContainer


@export var item_container_scene: PackedScene
@export var name_label: Label
@export var description_label: Label
@export var container_stylebox : StyleBoxTexture

var item_container_array : Array[ShopItemContainer]
var selected_container_idx: int = 0
var description_text_duration: float = 0.5
var description_tween: Tween

func _ready():
	setup_items()
	pass # Replace with function body.

func setup_items():
	for item in Global.instance.all_items:
		var texture_rect : TextureRect = TextureRect.new()
		texture_rect.texture = item.texture
		texture_rect.modulate = Color.hex(0x0000000FF)
		add_child(texture_rect)
		#var item_container: ShopItemContainer = item_container_scene.instantiate()
		#item_container.item_resource = item
		#add_child(item_container)
		#item_container_array.append(item_container)
		#item_container.on_selected.connect(start_description)
		#item_container.darken()

func update_items():
	for i in range(len(Global.instance.all_items)):
		if Global.player.has_item(Global.instance.all_items[i]):
			get_children()[i].modulate = Color.hex(0x0FFFFFFFF)
	#for item_container in item_container_array:
		#if Global.player.has_item(item_container.item_resource):
			#item_container.brighten()

func _process(delta):
	pass

func start_description(sic: ShopItemContainer):
	name_label.text = sic.item_resource.name
	description_label.text = sic.item_resource.description

	if description_tween:
		description_tween.kill()

	description_label.visible_ratio = 0
	description_tween = get_tree().create_tween()
	description_tween.tween_property(description_label, "visible_ratio", 1.0, description_text_duration)

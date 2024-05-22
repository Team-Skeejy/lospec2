class_name Inventory
extends GridContainer


@export var item_container_scene: PackedScene
@export var name_label: Label
@export var description_label: Label

var item_container_array : Array[ShopItemContainer]
var selected_container_idx: int = 0
var description_text_duration: float = 0.5
var description_tween: Tween

func _ready():
	setup_items()
	pass # Replace with function body.

func setup_items():
	for item in Global.instance.all_items:
		var item_container: ShopItemContainer = item_container_scene.instantiate()
		item_container.item_resource = item
		add_child(item_container)
		item_container_array.append(item_container)
		item_container.on_selected.connect(start_description)
		item_container.darken()

func update_items():
	for item_container in item_container_array:
		if not item_container.item_resource.for_sale:
			item_container.brighten()

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

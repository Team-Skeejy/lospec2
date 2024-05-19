extends Control

@export_category("Inventory")
@export var items_inventory : Array[ItemResource]
@export_category("Nodes")
@export var item_container_container: HBoxContainer
@export var item_container_scene: PackedScene
@export var name_label: Label
@export var description_label: Label
@export var cost_label: Label
var item_container_array: Array[ShopItemContainer] = []
var selected_container_idx: int = 0
var num_items_for_sale: int = 4
var description_text_duration: float = 0.5
var cost_label_pattern: String = "COST: $%s"

var description_tween: Tween

func _ready():
	print_debug("lol, i'm here for some reason")
	for _i in num_items_for_sale:
		var item_container: ShopItemContainer = item_container_scene.instantiate()
		item_container.item_resource = items_inventory.pick_random()
		item_container_container.add_child(item_container)
		item_container_array.append(item_container)
		item_container.on_selected.connect(start_description)

	item_container_array[selected_container_idx].select()

func _process(delta):
	if Input.is_action_just_pressed("Left"):
		item_container_array[selected_container_idx].deselect()
		selected_container_idx -= 1
		if selected_container_idx < 0:
			selected_container_idx = num_items_for_sale - 1
		item_container_array[selected_container_idx].select()
	elif Input.is_action_just_pressed("Right"):
		item_container_array[selected_container_idx].deselect()
		selected_container_idx += 1
		if selected_container_idx >= num_items_for_sale:
			selected_container_idx = 0
		item_container_array[selected_container_idx].select()
	elif Input.is_action_just_pressed("A"):
		buy()
	elif Input.is_action_just_pressed("B"):
		Global.instance.go_to_next_phase()

func start_description(sic: ShopItemContainer):
	name_label.text = sic.item_resource.name
	description_label.text = sic.item_resource.description
	cost_label.text = cost_label_pattern % sic.item_resource.cost

	if description_tween:
		description_tween.kill()

	description_label.visible_ratio = 0
	description_tween = get_tree().create_tween()
	description_tween.tween_property(description_label, "visible_ratio", 1.0, description_text_duration)

func get_currently_selected_container() -> ShopItemContainer:
	return item_container_array[selected_container_idx]

func buy():
	var selected_container : ShopItemContainer = get_currently_selected_container()
	var item_cost = selected_container.item_resource.cost
	if selected_container.sold_out or Global.instance.player_money < item_cost:
		# TODO incredibly loud buzzer sound
		return
	
	var item : Item = selected_container.buy()
	Global.player.add_item(item)
	Global.instance.update_money(-item_cost)
	print_debug("buying " + str(selected_container.item_resource.name))

extends Control


@export_category("Nodes")
@export var item_container_container: HBoxContainer
@export var item_container_scene: PackedScene
@export var name_label: Label
@export var description_label: Label
@export var cost_label: Label

@export var tutorial_items: Array[ItemResource] = []
@export var game_items: Array[ItemResource] = []

var item_container_array: Array[ShopItemContainer] = []
var selected_container_idx: int = 0
var num_items_for_sale: int = 4
var cost_label_pattern: String = "COST: $%s"
var description_text_duration: float = 0.5

var description_tween: Tween

func add_item(item: ItemResource):
	var item_container: ShopItemContainer = item_container_scene.instantiate()
	item_container.item_resource = item
	item_container_container.add_child(item_container)
	item_container_array.append(item_container)
	item_container.on_selected.connect(start_description)

func tutorial():
	var notif: Notification = Global.instance.new_notification_no_texture("Buy goods with your rightfully gotten gains", 0)
	while (!bought): await get_tree().process_frame
	notif.close()
	await Global.instance.new_notification_no_texture("It's just that easy!", 2).notification_ended
	await Global.instance.new_notification_no_texture("Now go forth, and find Isaia Panduri", 3).notification_ended
	await Global.instance.new_notification_no_texture("Make him PAY!", 2).notification_ended

func _ready():
	if Global.is_tutorial():
		tutorial()
		for item in tutorial_items:
			item.cost = Global.instance.player_money - 50
			add_item(item)
	else:
		for item in game_items:
			if item.for_sale:
				add_item(item)
			if len(item_container_array) >= num_items_for_sale:
				break
		if len(item_container_array) == 0:
			Global.instance.new_notification_no_texture("Out of stock!")
			Global.instance.go_to_next_phase()



	item_container_array[selected_container_idx].select()

func _input(_inp: InputEvent):
	if Input.is_action_just_pressed("Left"):
		Global.instance.positive_sfx.play()
		item_container_array[selected_container_idx].deselect()
		selected_container_idx -= 1
		if selected_container_idx < 0:
			selected_container_idx = len(item_container_array) - 1
		item_container_array[selected_container_idx].select()
	elif Input.is_action_just_pressed("Right"):
		Global.instance.positive_sfx.play()
		item_container_array[selected_container_idx].deselect()
		selected_container_idx += 1
		if selected_container_idx >= len(item_container_array):
			selected_container_idx = 0
		item_container_array[selected_container_idx].select()
	elif Input.is_action_just_pressed("A"):
		buy()
	elif Input.is_action_just_pressed("B"):
		if Global.instance.current_phase == Global.GamePhase.tutorial_shop:
			if item_container_array.any(func(item): return !item.sold_out):
				# sad noise
				Global.instance.denied_sfx.play()
				return
		Global.instance.positive_sfx.play()
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

var bought: bool = false
func buy():
	bought = true
	var selected_container: ShopItemContainer = get_currently_selected_container()
	var item_cost = selected_container.item_resource.cost
	if selected_container.sold_out or Global.instance.player_money < item_cost:
		Global.instance.denied_sfx.play()
		return
	Global.instance.pickup_sfx.play()
	Global.instance.update_money(-item_cost)
	var item: ItemResource = selected_container.buy()
	Global.player.add_item(item)
	print_debug("buying " + str(selected_container.item_resource.name))

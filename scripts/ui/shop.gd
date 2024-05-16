extends Control

@export var item_container_container : HBoxContainer
@export var item_container_scene : PackedScene
@export var description_lebel : Label
@export var cost_label : Label 
var item_container_array : Array[ShopItemContainer] = []
var selected_container_idx : int = 0
var num_items_for_sale : int = 4
var description_text_duration : float = 0.5
var cost_label_pattern : String = "COST: %s$" 

var description_tween : Tween

func _ready():
	for _i in num_items_for_sale:
		var item_container : ShopItemContainer = item_container_scene.instantiate()
		# TODO edit what item is in the container
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

func start_description(sic:ShopItemContainer):
	var item = sic.item # doesn't do anything now lmao
	description_lebel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam vitae lorem sit amet purus malesuada feugiat non vel nibh."
	cost_label.text = cost_label_pattern % (randi() % 20)
	
	if description_tween:
		description_tween.kill()
	
	description_lebel.visible_ratio = 0
	description_tween = get_tree().create_tween()
	description_tween.tween_property(description_lebel, "visible_ratio", 1.0, description_text_duration)
	
func buy():
	var thing_youre_buying = item_container_array[selected_container_idx].item
	print_debug("buying " + str(thing_youre_buying))

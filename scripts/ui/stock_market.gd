extends Control

@export_category("Nodes")
@export var graph_panel: Panel
@export var graph_line: Line2D
@export var graph_origin_node: Node2D

@export var buy_container: PanelContainer
@export var sell_container: PanelContainer

@export var buy_chance_label: Label
@export var sell_chance_label: Label
@export var buy_payout_label: Label
@export var sell_payout_label: Label

@export var company_name_label: Label
@export var info_textures: Array[TextureRect]
@export var stock_market_ui: VBoxContainer
@export var not_enough_info_label: Label
@export_category("SFX")
@export var animation_sound: AudioStreamPlayer
@export var win_sound: AudioStreamPlayer
@export var lose_sound: AudioStreamPlayer

var animation_step_duration := 0.03
static var GRAPH_ANIMATION_NUM_POINTS := 40

var bright_green_color = Color.hex(0x00aff0aff)
var bright_red_color = Color.hex(0x0ff032bff)

var dark_green_color = Color.hex(0x0007062ff)
var dark_red_color = Color.hex(0x0800034ff)

var red_info_position := Vector2(32, 34)
var green_info_position := Vector2(48, 34)

# I use ints for the chance to make sure what I'm showing is consistrnt
var base_buy_chance: int
var base_sell_chance: int
var base_buy_payout: int
var base_sell_payout: int

var buy_chance: int
var sell_chance: int
var buy_payout: int
var sell_payout: int

enum ButtonType {
	BUY,
	SELL
}

var allow_input: bool = false
var selected_button: ButtonType = ButtonType.SELL

var companies_left: Array
var selected: bool = false


signal animation_done

func tutorial():
	await Global.instance.new_notification_no_texture("Now... with your new found knowledge", 3).notification_ended
	var notif: Notification = Global.instance.new_notification_no_texture("Buy or sell your stocks", 0)
	while (!selected): await get_tree().process_frame
	notif.close()

func _ready():
	if Global.is_tutorial():
		tutorial()

	# print_debug("It is I, the stock market, generating sample information")
	# InformationManager.instance.generate_sample_info() # TODO REMOVE

	flip_selected()
	companies_left = InformationManager.instance.completed_companies
	animation_done.connect(start_next_company)
	if len(InformationManager.instance.completed_companies) > 0:
		start_next_company()
	else:
		stock_market_ui.hide()
		not_enough_info_label.show()
		await get_tree().create_timer(2.0).timeout
		start_next_company()

func _process(_delta: float):
	if not allow_input:
		return

	if Input.is_action_just_pressed("Left") or Input.is_action_just_pressed("Right"):
		flip_selected()
	elif Input.is_action_just_pressed("A"):
		select()

func select():
	selected = true
	if selected_button == ButtonType.BUY:
		buy(Global.instance.current_phase == Global.GamePhase.tutorial_stock_market)
	else:
		sell(Global.instance.current_phase == Global.GamePhase.tutorial_stock_market)

func buy(guaranteed_win: bool = false):
	if guaranteed_win || randf() < buy_chance / 100.:
		graph_animation("up")
		await animation_done
		Global.instance.update_money(buy_payout)
		win()
	else:
		graph_animation("down")
		await animation_done
		lose()

func sell(guaranteed_win: bool = false):
	if guaranteed_win || randf() < sell_chance / 100.:
		graph_animation("down")
		await animation_done
		Global.instance.update_money(sell_payout)
		win()
	else:
		graph_animation("up")
		await animation_done
		lose()

func win():
	win_sound.play()

func lose():
	lose_sound.play()


func flip_selected():
	if selected_button == ButtonType.BUY:
		selected_button = ButtonType.SELL
		sell_container.modulate = bright_red_color
		buy_container.modulate = dark_green_color
	else:
		selected_button = ButtonType.BUY
		sell_container.modulate = dark_red_color
		buy_container.modulate = bright_green_color
	update_odds_payout()


func start_next_company():
	if len(companies_left) == 0:
		InformationManager.instance.clear_information()
		Global.instance.go_to_next_phase()
		return

	var company = companies_left.pop_back()
	company_name_label.visible_ratio = 0.0
	company_name_label.text = company
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(company_name_label, "visible_ratio", 1.0, animation_step_duration * 15)
	var info = InformationManager.instance.information_gathered[company]
	var n_sell := 0
	var n_buy := 0
	for i in len(info):
		if info[i] == InformationManager.Type.SELL:
			n_sell += 1
			info_textures[i].texture.region.position = red_info_position
		else:
			n_buy += 1
			info_textures[i].texture.region.position = green_info_position

	var base_payout: int = Global.instance.companies[company].company_base_payout

	base_buy_chance = n_buy * 100 / InformationManager.MAX_INFO_PER_COMPANY
	base_sell_chance = 100 - base_buy_chance

	if n_buy == InformationManager.MAX_INFO_PER_COMPANY:
		base_buy_payout = base_payout * 3
		base_sell_payout = base_payout * 10
	elif n_sell == InformationManager.MAX_INFO_PER_COMPANY:
		base_buy_payout = base_payout * 10
		base_sell_payout = base_payout * 3
	else:
		base_buy_payout = n_sell * base_payout
		base_sell_payout = n_buy * base_payout
	update_odds_payout()
	await get_tree().create_timer(animation_step_duration * 10).timeout
	InformationManager.instance.remove_company(company)
	graph_line.clear_points()
	allow_input = true

func update_odds_payout():

	buy_chance = base_buy_chance
	sell_chance = base_sell_chance

	buy_payout = base_buy_payout + Modifiers.payout_bonus
	sell_payout = base_sell_payout + Modifiers.payout_bonus

	if selected_button == ButtonType.BUY:
		buy_chance += Modifiers.luck
		sell_chance -= Modifiers.luck
	else:
		sell_chance += Modifiers.luck
		buy_chance -= Modifiers.luck

	buy_chance = clamp(buy_chance, 1, 99)
	sell_chance = clamp(sell_chance, 1, 99)

	set_odds_payout_labels()



func set_odds_payout_labels():
	var chance_template: String = "Chance: %d"
	var payout_template: String = "Payout: $%d"

	buy_chance_label.text = (chance_template % buy_chance) + "%"
	sell_chance_label.text = (chance_template % sell_chance) + "%"
	buy_payout_label.text = payout_template % buy_payout
	sell_payout_label.text = payout_template % sell_payout


func graph_animation(direction: String = "down"):
	allow_input = false
	animation_sound.play()
	allow_input = false
	graph_line.clear_points()

	var graph_width = graph_panel.size.x
	var graph_height = graph_panel.size.y
	var graph_origin: Vector2 = graph_origin_node.global_position
	var inc_x: float
	var inc_y: float

	graph_line.add_point(graph_origin)
	for i in range(1, GRAPH_ANIMATION_NUM_POINTS - 2):
		inc_x = i * graph_width / float(GRAPH_ANIMATION_NUM_POINTS)
		inc_y = clamp(randfn(0.0, 0.15), -0.9, 0.9) * graph_height / 2.

		if inc_y < 0:
			graph_line.default_color = dark_green_color
		else:
			graph_line.default_color = dark_red_color


		graph_line.add_point(graph_origin + Vector2(inc_x, inc_y))
		await get_tree().create_timer(animation_step_duration).timeout

	await get_tree().create_timer(animation_step_duration * 10).timeout

	if direction == "down":
		inc_y = 0.9 * graph_height / 2.
		graph_line.default_color = bright_red_color
	else:  # direction == "down":
		inc_y = -0.9 * graph_height / 2.
		graph_line.default_color = bright_green_color

	inc_x = graph_width * 0.98
	graph_line.add_point(graph_origin + Vector2(inc_x, inc_y))
	await get_tree().create_timer(animation_step_duration * 5).timeout
	animation_done.emit()


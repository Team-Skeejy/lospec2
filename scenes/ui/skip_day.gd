extends SettingRow

@export var settings_menu: SettingsMenu

func detect_phase():
	match Global.instance.current_phase:
		Global.GamePhase.platformer, Global.GamePhase.tutorial_platformer, Global.GamePhase.test_platformer:
			visible = true
		_:
			visible = false
			if settings_menu.get_selected_row() == self:
				settings_menu.select(settings_menu.selected_row + 1)

func on_phase_transition(_phase: Global.GamePhase):
	detect_phase()

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.instance.phase_transition.connect(on_phase_transition)
	await get_tree().process_frame
	detect_phase()

func a():
	settings_menu.hide()
	Global.player.ui.close()
	Global.instance.go_to_next_phase()

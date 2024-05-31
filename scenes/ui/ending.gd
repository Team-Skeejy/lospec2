extends CanvasLayer

@export_file("*.tscn") var next_scene: String
var next_triggered = false

func _process(_delta: float):
	if Input.get_axis("A", "B") && !next_triggered:
		if next_scene: FadeTransition.instance.transition_to(next_scene)
		else: Global.instance.go_to_phase(Global.GamePhase.menu)
		next_triggered = true


func _on_timer_timeout():
	if !next_triggered:
		if next_scene: FadeTransition.instance.transition_to(next_scene)
		else: Global.instance.go_to_phase(Global.GamePhase.menu)
		next_triggered = true


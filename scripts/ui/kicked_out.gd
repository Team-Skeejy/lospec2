extends CanvasLayer

func _process(delta):
	if Input.get_axis("A", "B"):
		Global.instance.go_to_phase(Global.GamePhase.stock_market)


func _on_timer_timeout():
	Global.instance.go_to_phase(Global.GamePhase.stock_market)


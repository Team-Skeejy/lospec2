extends Node2D

@export var panels: Array[Control]
@export var animation: AnimationPlayer

# func _on_timer_timeout():

var panel := 0

func next():
	if panel > len(panels): return

	if !animation.is_playing():
		panel += 1
		if panel > len(panels):
			Global.instance.go_to_next_phase()
		else:
			animation.play("dither_out")
			await animation.animation_finished
			for i in len(panels):
				panels[i].visible = panel == i
			animation.play("dither_in")
			await animation.animation_finished
	else:
		animation.advance(1)

func _ready():
	for i in len(panels):
		panels[i].visible = panel == i

func _input(_inp: InputEvent):
	if Input.is_action_just_pressed("Left") \
		|| Input.is_action_just_pressed("Right") \
		|| Input.is_action_just_pressed("Up") \
		|| Input.is_action_just_pressed("Down") \
		|| Input.is_action_just_pressed("A") \
		|| Input.is_action_just_pressed("B") \
		|| Input.is_action_just_pressed("Select") \
		|| Input.is_action_just_pressed("Start"):
		next()

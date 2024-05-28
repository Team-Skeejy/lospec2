extends Node2D

var notification: Notification

func _input(_ev: InputEvent) -> void:
	if Input.is_action_just_pressed("Up"):
		if is_instance_valid(notification): notification.close()
		Global.instance.new_notification_no_texture("this is a fast message")
	if Input.is_action_just_pressed("Down"):
		if is_instance_valid(notification): notification.close()
		Global.instance.new_notification_no_texture("this is a slow message", Notification.DESPAWN_TIME_LONG)
	if Input.is_action_just_pressed("Left"):
		if is_instance_valid(notification): notification.close()
		notification = Global.instance.new_notification_no_texture.call("press right to close this message", 0)
	if Input.is_action_just_pressed("Right"):
		if is_instance_valid(notification): notification.close()

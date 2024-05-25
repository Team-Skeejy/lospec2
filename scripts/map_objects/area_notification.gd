class_name AreaNotification
extends Area2D

@export var area_name: String = "Area lol"

func on_player_entered(body: Node2D):
  if body is Player:
    (body as Player).ui.new_notification_no_texture(area_name)

func _ready():
  self.body_entered.connect(on_player_entered)
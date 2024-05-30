class_name NPCBoss
extends NPCState

@export var talk_zone: Area2D

func on_body_entered(node: Node2D):
  if node is Player:
    var player := node as Player
    player.add_behaviour(BossSequence.new())

func Enter() -> void:
  talk_zone.body_entered.connect(on_body_entered)

  await get_tree().create_timer(0.5).timeout
  # place the boss on a chair so he sits immediately
  if npc.interact_target:
    npc.interact_target._interact(npc)

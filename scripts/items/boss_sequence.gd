class_name BossSequence
extends Behaviour

var player_has_landed := false

func physics_process(_delta: float) -> bool:
  # sticks the player to the floor
  if holder.is_on_floor():
    player_has_landed = true
    holder._facing = Humanoid.EDirection.right

  if player_has_landed:
    holder.velocity = Vector2.ZERO
    return true

  return false

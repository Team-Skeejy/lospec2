class_name BossSequence
extends Behaviour

signal is_ready
var player_has_landed := false

var chair: Sittable
var _boss_area: BossArea

func _init(boss_area: BossArea):
  _boss_area = boss_area

func physics_process(_delta: float) -> bool:
  # sticks the player to the floor
  if !player_has_landed && holder.is_on_floor():
    player_has_landed = true
    holder._facing = Humanoid.EDirection.right
    is_ready.emit()

  if player_has_landed:
    holder.velocity = Vector2.ZERO
    return true

  return false

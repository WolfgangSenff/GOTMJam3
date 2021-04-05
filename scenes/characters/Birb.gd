extends Enemy

const MovementSpeed = 120
const VerticalSpeed = 5
const Amplitude = 6005

var _direction = 1
var _velocity = Vector2.LEFT

func _physics_process(delta: float) -> void:
    _velocity.y = Amplitude * sin(global_position.x * delta * VerticalSpeed) * delta
    _velocity.x = _direction * Vector2.LEFT.x * MovementSpeed * -scale.x
    
    _velocity = move_and_slide(_velocity)

func _on_EnemyHead_anim_area_entered(area: Area2D) -> void:
    if HP > 0 and area.get_parent()._velocity.y > 0:
        _animation_player.play("Damage")



extends "res://scenes/characters/EnemyBase.gd"

onready var _walking_cast = $Sprite/WalkingCast
onready var _left_cliff_cast = $LeftCliffCheck
onready var _right_cliff_cast = $RightCliffCheck

export (float) var WalkingSpeed = 60
export (bool) var ShouldMove = true

var _is_awake = false

func _ready() -> void:
    _animation_player.play("Wakeup")
    yield(_animation_player, "animation_finished")
    _is_awake = true
    
func _physics_process(delta: float) -> void:
    if _is_awake:
        if _animation_player.current_animation != "Walk":
            _animation_player.queue("Walk")
        
        if _walking_cast.is_colliding() || !_left_cliff_cast.is_colliding() || !_right_cliff_cast.is_colliding():
            _sprite.scale.x = -_sprite.scale.x
        
        var movement = Vector2.DOWN * 120 * delta # gravity ?
        
        if ShouldMove:
            movement += WalkingSpeed * -_sprite.scale.x * Vector2.RIGHT
            
        move_and_slide(movement, Vector2.UP, true)
            
func _on_EnemyHead_anim_area_entered(area: Area2D) -> void:
    if HP > 0 and area.get_parent()._velocity.y > 0:
        _animation_player.play("Damage")

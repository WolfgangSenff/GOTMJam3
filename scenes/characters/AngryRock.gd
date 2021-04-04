extends Enemy

onready var _walking_cast = $Sprite/WalkingCast
onready var _left_cliff_cast = $LeftCliffCheck
onready var _right_cliff_cast = $RightCliffCheck

export (float) var WalkingSpeed = 60
export (bool) var ShouldMove = true

var _is_awake = false
var _is_flipped = false
var _flipping_time = 0.0
var _flip_direction
const FlipForce = 80
const FlipTime = .8

func _ready() -> void:
    _animation_player.play("Wakeup")
    yield(_animation_player, "animation_finished")
    _is_awake = true

func flip_enemy() -> void:
    ShouldMove = false
    _flip_direction = deg2rad(randi() % 60)
    
func _physics_process(delta: float) -> void:
    if _animation_player.current_animation != "Walk":
        _animation_player.queue("Walk")
    
    if _walking_cast.is_colliding() || !_left_cliff_cast.is_colliding() || !_right_cliff_cast.is_colliding():
        if _walking_cast.is_colliding() and _animation_player.current_animation != "Smash":
            _animation_player.play("Smash")
            yield(_animation_player, "animation_finished")
        
        _sprite.scale.x = -_sprite.scale.x
    
    var movement = Vector2.DOWN * 120 # gravity ?
    
    if ShouldMove:
        movement += WalkingSpeed * -_sprite.scale.x * Vector2.RIGHT
    elif _is_flipped:
        movement = Vector2.UP.rotated(_flip_direction).normalized() * FlipForce
        _flip_direction += delta
        _flipping_time += delta
        if _flipping_time >= FlipTime:
            movement = Vector2.DOWN * 120
        
    move_and_slide(movement, Vector2.UP, true)
    
    if _is_flipped and get_slide_count() > 0:
        _flip_direction = 0
        _flipping_time = FlipTime
        
func _on_EnemyHead_anim_area_entered(area: Area2D) -> void:
    if HP > 0 and area.get_parent()._velocity.y > 0:
        _animation_player.play("Damage")

func _check_death() -> void:
    if HP <= 0 and ShouldMove:
        is_alive = false
        Globals.enemy_killed(self)
        ShouldMove = false
        _is_flipped = true
        flip_enemy()
        _animation_player.play("Death")
        _animation_tree.active = false

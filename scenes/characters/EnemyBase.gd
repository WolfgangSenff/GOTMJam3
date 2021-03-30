class_name Enemy
extends KinematicBody2D

onready var _animation_tree = $AnimationTree
onready var _animation_player = $AnimationPlayer
onready var _head = $EnemyHead
onready var _hit = $EnemyHit
onready var _sprite = $Sprite
onready var _damage_timer = $DamageTimer
export (int) var HP = 4

var _can_take_damage = true

func _on_EnemyHead_area_entered(area: Area2D) -> void:
    var area_parent = area.get_parent()
    if area_parent._velocity.y > 0 and _can_take_damage:
        HP -= 1
        _can_take_damage = false
        _damage_timer.start()
        if HP <= 0:
            set_physics_process(false)
            _animation_player.play("Death")
            _animation_tree.active = false
            yield(_animation_player, "animation_finished")
            queue_free()

func _on_DamageTimer_timeout() -> void:
    _can_take_damage = true

extends Node2D

const WalkSpeed = 40
export var Damage = 3

onready var sprite = $Sprite
onready var left_cast = $LeftCast
onready var right_cast = $RightCast
onready var wall_cast = $Sprite/WallCast

func _physics_process(delta: float) -> void:
    global_position += delta * WalkSpeed * Vector2.RIGHT * sprite.scale.x
    if wall_cast.is_colliding():
        sprite.scale.x = -sprite.scale.x
    elif not left_cast.is_colliding():
        sprite.scale.x = 1
    elif not right_cast.is_colliding():
        sprite.scale.x = -1

class_name CharacterBase
extends KinematicBody2D

onready var _animation_tree = $AnimationTree
onready var _sprite = $Sprite
onready var _collision_shape = $CollisionShape2D
onready var _camera_transform = $CameraTransform

func set_camera(cam : Camera2D) -> void:
    _camera_transform.remote_path = cam.get_path()

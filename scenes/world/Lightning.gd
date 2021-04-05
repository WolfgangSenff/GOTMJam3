extends Node2D

onready var _anim = $AnimationPlayer

var damage = 5
var is_alive = true

func strike() -> void:
    position = Vector2.RIGHT * (randi() % 180) * pow(-1, randi() % 2)
    _anim.play("Strike")

func _on_Area2D_body_entered(body: Node) -> void:
    body._on_Hit_body_entered(self)

extends StaticBody2D

onready var platforms = $LeafPlatforms
onready var anim = $AnimationPlayer
onready var collision_shape = $CollisionShape2D

func _ready() -> void:
    platforms.hide()
    for child in platforms.get_children():
        child.MoveSpeed = 0

func _on_Area2D_body_entered(body: Node) -> void:
    anim.play("Rock")
    yield(anim, "animation_finished")
    for child in platforms.get_children():
        child.MoveSpeed = (randi() % 60) + 30
    collision_shape.disabled = true
    platforms.show()

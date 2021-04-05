extends Area2D

export var damage = 2
var is_ground = false

const is_alive = true
var DropSpeed = 50
var Acceleration = 600

func _ready() -> void:
    set_physics_process(false)

func drop() -> void:
    var tree = get_tree()
    var parent = get_parent()
    var height = $Sprite.texture.get_height()
    parent.remove_child(self)
    tree.call_group("Level", "add_child", self)
    set_physics_process(true)
    set_deferred("global_position", Vector2(parent.global_position.x, parent.global_position.y + height))
    
func _physics_process(delta: float) -> void:
    global_position += delta * Vector2.DOWN * DropSpeed
    DropSpeed += Acceleration * delta

func _on_BirbBomb_area_entered(area: Area2D) -> void:
    Globals.player_take_damage(2)
    
func _on_BirbBomb_body_entered(body: Node) -> void:
    DropSpeed = 0
    Acceleration = 0
    $Sprite.hide()
    $CPUParticles2D.emitting = true
    yield(get_tree().create_timer(2), "timeout")
    queue_free()

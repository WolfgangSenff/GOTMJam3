extends Area2D

export (NodePath) onready var AssociatedExitPath
onready var associated_exit = get_node(AssociatedExitPath)

func _on_ExitKey_body_entered(body: Node) -> void:
    if associated_exit:
        associated_exit.open()
        
    queue_free()

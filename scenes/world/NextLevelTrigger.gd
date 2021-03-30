extends Area2D

signal opened
signal closed

export (Resource) var NextLevelResource

onready var anim = $AnimationPlayer

var player_can_transfer = true

func _on_NextLevelTrigger_area_entered(area: Area2D) -> void:
    if player_can_transfer:
        Globals.level_transfer_resource = NextLevelResource
        Globals.is_level_transfer = true
        anim.play("Open")
        yield(anim, "animation_finished")
        emit_signal("opened")
        yield(get_tree().create_timer(0.5), "timeout")
        anim.play("Close")
        emit_signal("closed")
        yield(anim, "animation_finished")
        Globals.change_levels()

func _on_NextLevelTrigger_area_exited(area: Area2D) -> void:
    player_can_transfer = true

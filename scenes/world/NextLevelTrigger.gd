extends Area2D

signal about_to_open
signal opened
signal closed

export (Resource) var NextLevelResource

onready var anim = $AnimationPlayer

func _on_NextLevelTrigger_area_entered(area: Area2D) -> void:
    emit_signal("about_to_open")
    anim.play("Open")
    yield(anim, "animation_finished")
    emit_signal("opened")
    yield(get_tree().create_timer(0.5), "timeout")
    anim.play("Close")
    emit_signal("closed")
    yield(anim, "animation_finished")
    Globals.change_levels()

extends Area2D

func _on_Aphid_area_entered(area: Area2D) -> void:
    Globals.player_take_damage(-3)
    Globals.spawn_on_main(preload("res://scenes/world/Hearticles.tscn"), global_position)
    queue_free()

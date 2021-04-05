extends "res://scenes/characters/Birb.gd"



func _on_DropArea_area_entered(area: Area2D) -> void:
    var birb_bomb = get_node_or_null("BirbBomb")
    if birb_bomb and is_instance_valid(birb_bomb):
        birb_bomb.drop()

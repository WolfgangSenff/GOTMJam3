extends Node2D

func _on_new_ground_enemy(enemy) -> void:
    var spawn_pos = 0
    var children = get_children()
    for child in children:
        if child.is_current and child.IsGround:
            spawn_pos += 1
            break
            
    if spawn_pos < get_child_count():
        children[spawn_pos].SceneToSpawn = enemy
    else:
        spawn_pos = 0
        for child in children:
            if child.IsGround:
                children[spawn_pos].SceneToSpawn = enemy
            
            spawn_pos += 1

func _on_new_air_enemy(enemy) -> void:    
    var spawn_pos = 0
    var children = get_children()
    for child in children:
        if child.is_current and not child.IsGround:
            spawn_pos += 1
            break
            
    if spawn_pos < get_child_count():
        children[spawn_pos].SceneToSpawn = enemy
    else:
        spawn_pos = 0
        for child in children:
            if not child.IsGround:
                children[spawn_pos].SceneToSpawn = enemy
            
            spawn_pos += 1

extends Area2D

export var should_self_delete := true
export (String, "rain", "lightning", "clouds") var action_name = "rain"
export (String, "all", "random") var action_target = "all"

func _on_Pickup_area_entered(area: Area2D) -> void:
    if action_target == "all":
        Globals.send_action_to_all({"action_name": action_name})
    elif action_target == "random":
        Globals.send_action({"action_name": action_name})
    if should_self_delete:
        queue_free()
        

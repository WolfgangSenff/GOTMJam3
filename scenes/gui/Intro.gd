extends Control


func _on_Button_pressed() -> void:
    Globals.change_levels()


func _on_Button2_pressed() -> void:
    Globals.go_multiplayer()

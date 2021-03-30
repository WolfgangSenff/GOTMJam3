extends Node2D

onready var camera = $Camera2D
onready var aunt = $Auntie
onready var exits = $Exits
onready var count_down = $CanvasLayer/Root/MarginContainer/MainContainer/CountDownLabel
onready var gui_animator = $CanvasLayer/Root/MarginContainer/MainContainer/DeathVisual/AnimationPlayer

func _ready() -> void:
    aunt.set_physics_process(false)
    if Globals.is_level_transfer:
        for child in exits.get_children():
            connect_to_exit(child)
            if child.NextLevelResource == Globals.previous_level_resource:
                aunt.global_position = child.global_position
                child.player_can_transfer = false
                break
    else:
        for child in exits.get_children():
            connect_to_exit(child)
                
    aunt.set_camera(camera)
    var game_over_triggers = get_tree().get_nodes_in_group("GameOverTrigger")
    for trigger in game_over_triggers:
        trigger.connect("game_over", self, "_on_game_over", [], CONNECT_ONESHOT)

    count_down.start_timer()
    aunt.set_physics_process(true)

func connect_to_exit(exit) -> void:
    exit.connect("opened", self, "_on_exit_opened")
    exit.connect("closed", self, "_on_exit_closed")

func _on_exit_opened() -> void:
    aunt.set_physics_process(false)
    
func _on_exit_closed() -> void:
    aunt.hide()

func _on_game_over() -> void:
    gui_animator.play("Death")

extends Node2D

signal game_over

onready var camera = $Camera2D
onready var aunt = $Auntie
onready var exits = $Exits
onready var count_down = $CanvasLayer/Root/MarginContainer/MainContainer/CountDownLabel
onready var gui_animator := $CanvasLayer/Root/MarginContainer/MainContainer/DeathVisual/AnimationPlayer
onready var rain_particles := $Camera2D/Rain
onready var cloud_particles := $Camera2D/Cloud
onready var lightning := $Camera2D/Lightning
onready var hp_meter := $CanvasLayer/Root/MarginContainer/MainContainer/HPMeter

func _ready() -> void:
    hp_meter.value = Globals.current_player_hp
    aunt.set_physics_process(false)
    aunt.connect("took_damage", self, "_on_damage_taken")
    for child in exits.get_children():
        connect_to_exit(child)
                
    aunt.set_camera(camera)
    var game_over_triggers = get_tree().get_nodes_in_group("GameOverTrigger")
    for trigger in game_over_triggers:
        trigger.connect("game_over", self, "_on_game_over", [], CONNECT_ONESHOT)

    count_down.start_timer()
    aunt.set_physics_process(true)

func _on_damage_taken() -> void:
    hp_meter.value = Globals.current_player_hp

func connect_to_exit(exit) -> void:
    exit.connect("about_to_open", self, "_on_exit_opened")
    exit.connect("opened", self, "_on_exit_opened")
    exit.connect("closed", self, "_on_exit_closed")

func _on_exit_opened() -> void:
    aunt.set_physics_process(false)
    
func _on_exit_closed() -> void:
    aunt.hide()

func make_it_lightning() -> void:
    lightning.strike()
    
func make_it_cloudy() -> void:
    cloud_particles.emitting = true

func make_it_rain() -> void:
    rain_particles.emitting = true

func _on_game_over() -> void:
    gui_animator.play("Death")
    yield(gui_animator, "animation_finished")
    yield(get_tree().create_timer(1.0), "timeout")
    Globals.reset_game()

func _on_FallDeath_area_entered(area: Area2D) -> void:
    emit_signal("game_over")
    aunt.hide()
    aunt.set_physics_process(false)
    aunt.queue_free()

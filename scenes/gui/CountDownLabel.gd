extends Label

signal game_over

export (int) onready var InitialTime

var _current_time

onready var timer = $Timer

func _ready() -> void:
    _current_time = InitialTime if InitialTime != 0 else Globals.current_time        
    text = str(_current_time)

func start_timer() -> void:
    timer.start()

func _on_Timer_timeout() -> void:
    _current_time -= 1
    Globals.current_time = _current_time
    text = str(_current_time)
    if _current_time <= 0:
        emit_signal("game_over")
        timer.stop()

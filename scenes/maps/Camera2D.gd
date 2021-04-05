extends Camera2D

const TimeBetween = 8.0
const PossibleEffects = ["make_it_rain", "make_it_cloudy", "make_it_lightning"]

var _current_time = 0.0

func _process(delta: float) -> void:
    _current_time += delta
    if _current_time > TimeBetween:
        _current_time = 0
        if Globals._players.size() == 0:
            var rand = randf()
            if rand < .40:
                var random_effect = PossibleEffects[randi() % PossibleEffects.size()]
                get_parent().call(random_effect)

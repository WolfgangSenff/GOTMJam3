extends KinematicBody2D

var points := [] setget set_points
var reverse_points := []
var _target
var MoveSpeed
var _velocity = Vector2.ZERO

func set_points(value) -> void:
    points = value
    _target = points[0]
    
func _physics_process(delta: float) -> void:
    if _target.distance_squared_to(global_position) < 5:
        reverse_points.push_back(points.pop_front())
        if points.size() > 0:
            _target = points[0]
    
    if points.empty():
        points = reverse_points.duplicate()
        _target = points[0]
        reverse_points.clear()
        
    var destination = (_target - global_position).normalized()
    global_position += destination * MoveSpeed * delta

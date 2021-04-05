extends Path2D

onready var _leaf = $Leaf

export (float) onready var MoveSpeed = 50.0

func _ready() -> void:
    _leaf.points = self.curve.get_baked_points()
    _leaf.MoveSpeed = MoveSpeed

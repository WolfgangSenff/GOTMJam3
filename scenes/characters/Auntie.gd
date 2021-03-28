extends CharacterBase

onready var _is_walking : bool = false setget set_is_walking, get_is_walking
onready var _is_idle : bool = true setget set_is_idle, get_is_idle
onready var _is_jumping : bool = true setget set_is_jumping, get_is_jumping
onready var _is_in_air : bool = true setget set_is_in_air, get_is_in_air

func set_is_walking(value) -> void:
    set_condition("is_walking", value)
    _is_walking = value
    if _is_walking:
        self._is_idle = false
        self._is_jumping = false
        self._is_in_air = false

func get_is_walking() -> bool:
    return _is_walking
    
func set_is_idle(value) -> void:
    set_condition("is_idle", value)
    _is_idle = value
    if _is_idle:
        set_random_idle_blend()
        self._is_walking = false
        self._is_jumping = false
        self._is_in_air = false

func get_is_idle() -> bool:
    return _is_idle
    
func set_is_jumping(value) -> void:
    set_condition("is_jumping", value)
    _is_jumping = value
    if _is_jumping:
        self._is_walking = false
        self._is_idle = false
        self._is_in_air = false

func get_is_jumping() -> bool:
    return _is_jumping
    
func set_is_in_air(value) -> void:
    set_condition("is_in_air", value)
    _is_in_air = value
    if _is_in_air:
        self._is_walking = false
        self._is_idle = false

func get_is_in_air() -> bool:
    return _is_in_air
    
func set_condition(cond : String, value : bool) -> void:
    _animation_tree.set("parameters/conditions/" + cond, value)
    
func set_random_idle_blend() -> void:
    _animation_tree.set("parameters/Idle/blend_position", pow(-1, randi() % 2))
    

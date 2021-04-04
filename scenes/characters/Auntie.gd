extends CharacterBase

signal game_over
signal took_damage

onready var _is_walking : bool = false setget set_is_walking, get_is_walking
onready var _is_idle : bool = true setget set_is_idle, get_is_idle
onready var _is_in_air : bool = true setget set_is_in_air, get_is_in_air
onready var _invincibility_timer = $InvincibilityTimer

export (float) var JumpStrength = 400
export (float) var JumpMultiplier = 1.4
export (float) var MovementSpeed = 20
export (float) var Gravity = 1000
export (float) var Friction = 420
export (float) var MaxSpeed = 150
export var HitStrength := 1000

var _can_take_damage := true
var _jump_count = 0
var _snap_vector = 1 setget , get_snap_vector
var _velocity = Vector2.ZERO
var _is_in_enemy_head := false setget set_is_in_enemy_head
var _current_enemy_jump = null
var _can_jump
var is_alive = true

onready var _feet = $Feet

func _ready() -> void:
    set_random_idle_blend()

func set_is_walking(value) -> void:
    set_condition("is_walking", value)
    _is_walking = value
    if _is_walking:
        self._is_idle = false
        self._is_in_air = false

func get_is_walking() -> bool:
    return _is_walking
    
func set_is_idle(value) -> void:
    set_condition("is_idle", value)
    _is_idle = value
    if _is_idle:
        set_random_idle_blend()
        self._is_walking = false
        self._is_in_air = false

func get_is_idle() -> bool:
    return _is_idle
    
func set_is_in_air(value) -> void:
    set_condition("is_in_air", value)
    _is_in_air = value
    if _is_in_air:
        self._is_walking = false
        self._is_idle = false

func get_is_in_air() -> bool:
    return _is_in_air

func get_snap_vector() -> int:
    return 1 if not _is_in_air else 0
    
func set_is_in_enemy_head(value) -> void:
    _is_in_enemy_head = value
    
func set_condition(cond : String, value : bool) -> void:
    _animation_tree.set("parameters/conditions/" + cond, value)
    
func set_random_idle_blend() -> void:
    _animation_tree.set("parameters/Idle/blend_position", pow(-1, randi() % 2))
    
func _physics_process(delta: float) -> void:
    var on_floor := is_on_floor()
    var has_pressed_jump = Input.is_action_just_pressed("jump")
    var x_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
    var sign_x = sign(x_input)
    var sign_y = sign(_velocity.y)
    var x_is_zero = is_zero_approx(x_input)
    
    if has_pressed_jump and on_floor:
        _velocity.y = -JumpStrength
        on_floor = false
        
    if not on_floor:
        self._is_in_air = true     
        
    if not x_is_zero:
        if (not has_pressed_jump and not _is_in_air) or on_floor:
            self._is_walking = true
        _velocity.x += x_input * MovementSpeed
        _sprite.scale.x = sign_x if sign_x != 0 else _sprite.scale.x
    else:
        _velocity.x = move_toward(_velocity.x, 0, delta * Friction)

    if is_zero_approx(_velocity.x) and on_floor:
        self._is_idle = true   
        
    _velocity.x = clamp(_velocity.x, -MaxSpeed, MaxSpeed) 
    var overlapping_feet = _feet.get_overlapping_areas()
    var has_overlap_with_head = false
    for area in overlapping_feet:
        if area.collision_layer == 8:
            has_overlap_with_head = true
            break
    if not on_floor or has_overlap_with_head:
        _velocity.y += Gravity * delta
    else:
        _velocity.y = 0
        
    _velocity = move_and_slide_with_snap(_velocity, Vector2.DOWN * 8 if (on_floor and not has_overlap_with_head) else Vector2.DOWN * 0, Vector2.UP, true)
    
    for i in get_slide_count():
        var collision := get_slide_collision(i)
        var collider := collision.collider
        var is_stomping := (collider is Enemy and (on_floor or _is_in_enemy_head)) and collision.normal.is_equal_approx(Vector2.UP)
        
        if is_stomping:
            _velocity.y = -JumpStrength if not has_pressed_jump else -JumpStrength * JumpMultiplier

func _moving_downward() -> bool:
    return _velocity.y > 0

func _on_Feet_area_entered(area: Area2D) -> void:
    if _moving_downward() and (area != _current_enemy_jump or _current_enemy_jump == null):
        _is_in_enemy_head = true
        _current_enemy_jump = area
    
func _on_Feet_area_exited(area: Area2D) -> void:
    if area == _current_enemy_jump:
        _is_in_enemy_head = false

func _on_Hit_body_entered(body: Node) -> void:
    if body.is_alive and is_alive and _can_take_damage:
        Globals.player_take_damage(body.damage)
        emit_signal("took_damage")
        _can_take_damage = false
        if Globals.current_player_hp > 0:
            var direction_of_hit = (body.global_position - global_position).normalized()
            _velocity.x -= direction_of_hit.x * HitStrength
            _playback.travel("Damage")
            _invincibility_timer.start()
        else:
            is_alive = false
            emit_signal("game_over")

func _on_InvincibilityTimer_timeout() -> void:
    _can_take_damage = true

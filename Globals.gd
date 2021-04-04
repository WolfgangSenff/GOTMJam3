extends Node

var is_level_transfer = false
var level_transfer_resource setget set_level_transfer_resource
onready var previous_level_resource = preload("res://resources/levels/level1.tres")
var current_time

var current_db_ref
var player_db_ref
var dynamic_link
var user_name
var is_my_game = false
var _players = []
var current_player_hp = 10
var max_player_HP = 10

onready var levels = {
    preload("res://resources/levels/level1.tres") : "Level1",
    preload("res://resources/levels/level2.tres") : "Level2",
    preload("res://resources/levels/level3.tres") : "Level3",
   }

func _ready() -> void:
    if Firebase.Auth != null:
        Firebase.Auth.connect("signup_succeeded", self, "_on_login_succeeded")
        Firebase.Auth.login_anonymous()

func spawn_on_main(scene, pos) -> Node:
    var instance = scene.instance()
    get_tree().call_group("Level", "add_child", instance)
    instance.global_position = pos
    return instance
        
func reset_game() -> void:
    if current_db_ref:
        current_db_ref.push({"action":"player_died", "player":user_name})
    current_player_hp = max_player_HP
    _players.clear()
    if player_db_ref:
        player_db_ref.queue_free()
    is_my_game = false
    current_time = 999
    get_tree().change_scene("res://scenes/gui/Intro.tscn")

func set_level_transfer_resource(value) -> void:
    previous_level_resource = level_transfer_resource
    level_transfer_resource = value
    
func _on_login_succeeded(auth_token) -> void:
    print(auth_token)

func change_levels() -> void:
    if level_transfer_resource and is_level_transfer and levels.has(level_transfer_resource):
        var next_level = levels[level_transfer_resource]
        get_tree().change_scene("res://scenes/maps/" + next_level + ".tscn")
    else:
        get_tree().change_scene("res://scenes/maps/Level1.tscn")
        
func go_multiplayer() -> void:
    get_tree().change_scene("res://scenes/gui/SendToFriends.tscn")

func go_to_lobby() -> void:
    get_tree().change_scene("res://scenes/gui/Lobby.tscn")
    yield(get_tree(), "idle_frame")
    current_db_ref.connect("new_data_update", self, "_action_received")

func start_game() -> void:
    current_db_ref.push({ "action": "start_game" })

func add_player(player_name) -> void:
    if player_name != user_name:
        _players.push_back(player_name)

func player_take_damage(value) -> void:
    current_player_hp -= value
    current_player_hp = clamp(current_player_hp, 0, max_player_HP)
    if current_player_hp <= 0:
        get_tree().call_group("Level", "_on_game_over")

func enemy_killed(enemy) -> void:
    if _players.size() > 0:
        var random_player = _players[randi() % _players.size()]
        # Doesn't matter if this picks someone who is then immediately
        # deleted because they died; no real race condition, just means
        # the enemy doesn't go anywhere, which isn't a big deal
        current_db_ref.push({ "player": random_player, "enemy": enemy.filename, "is_ground": enemy.is_ground, "action": "spawn_enemy" })

func send_action(action) -> void:
    if _players.size() > 0:
        var random_player = _players[randi() % _players.size()]
        current_db_ref.push({"player": random_player, "action": action["action_name"]})

func send_action_to_all(action) -> void:
    if _players.size() > 0:
        for player in _players:
            current_db_ref.push({"player": player, "action": action["action_name"]})

#_on_new_ground_enemy
func _action_received(update_data) -> void:
    var action_data = update_data["data"]
    var action = action_data["action"]
    if action == "spawn_enemy":
        if action_data["player"] == user_name:
            var enemy = load(action_data["enemy"])
            if action_data["is_ground"]:
                get_tree().call_group("EnemySpawners", "_on_new_ground_enemy", enemy)
            else:
                get_tree().call_group("EnemySpawners", "_on_new_air_enemy", enemy)
    elif action == "start_game":
        change_levels()
    elif action == "player_died":
        var player = action_data["player"]
        if _players.has(player):
            _players.erase(player)
    elif action == "rain":
        get_tree().call_group("Level", "make_it_rain")
    elif action == "lightning":
        get_tree().call_group("Level", "make_it_lightning")
    elif action == "clouds":
        get_tree().call_group("Level", "make_it_cloudy")

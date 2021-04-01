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

onready var _levels = {
    preload("res://resources/levels/level1.tres") : "Level1",
    preload("res://resources/levels/level2.tres") : "Level2",
    preload("res://resources/levels/level3.tres") : "Level3",
   }

func _ready() -> void:
    if Firebase.Auth != null:
        Firebase.Auth.connect("signup_succeeded", self, "_on_login_succeeded")
        Firebase.Auth.login_anonymous()

func set_level_transfer_resource(value) -> void:
    previous_level_resource = level_transfer_resource
    level_transfer_resource = value
    
func _on_login_succeeded(auth_token) -> void:
    print(auth_token)

func change_levels() -> void:
    if level_transfer_resource and is_level_transfer and _levels.has(level_transfer_resource):
        var next_level = _levels[level_transfer_resource]
        get_tree().change_scene("res://scenes/maps/" + next_level + ".tscn")
    else:
        get_tree().change_scene("res://scenes/maps/Level1.tscn")
        
func go_multiplayer() -> void:
    get_tree().change_scene("res://scenes/gui/SendToFriends.tscn")

func go_to_lobby() -> void:
    get_tree().change_scene("res://scenes/gui/Lobby.tscn")

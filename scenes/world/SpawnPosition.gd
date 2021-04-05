extends Area2D

export (PackedScene) onready var SceneToSpawn setget set_scene_to_spawn, get_scene_to_spawn
export (bool) var IsGround
var is_current = false

var _spawns = []

func set_scene_to_spawn(value) -> void:
    if value:
        _spawns.push_back(value)

func get_scene_to_spawn() -> PackedScene:
    if _spawns.size() > 0:
        return _spawns.pop_front()
    
    return null

func _on_SpawnPosition_area_entered(area: Area2D) -> void:
    is_current = true

func _on_SpawnPosition_area_exited(area: Area2D) -> void:
    is_current = false

func _physics_process(delta: float) -> void:
    var scene = self.SceneToSpawn
    if scene:
        var spawned_scene = scene.instance()
        get_tree().get_nodes_in_group("Enemies")[0].add_child(spawned_scene)
        spawned_scene.global_position = global_position

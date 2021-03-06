extends Control

onready var grid = $MarginContainer/Control/GridContainer

func _ready() -> void:
    if not Globals.is_my_game:
        $MarginContainer/Control/Button.hide()
    Globals.current_db_ref = Firebase.Database.get_database_reference("AuntieAnt/games/" + Globals.dynamic_link + "/actions", { })
    Globals.player_db_ref = Firebase.Database.get_database_reference("AuntieAnt/games/" + Globals.dynamic_link + "/players", { })
    Globals.player_db_ref.connect("new_data_update", self, "on_new_player_joined")
    var random_id = randi()
    Globals.user_id = random_id
    Globals.player_db_ref.push({ "Name" : Globals.user_name, "ID": random_id })
    
func on_new_player_joined(player_data) -> void:
    var label = Label.new()
    label.text = player_data["data"]["Name"]
    grid.add_child(label)    
    Globals.add_player(label.text, player_data["data"]["ID"])

func _on_Button_pressed() -> void:
    Globals.start_game()

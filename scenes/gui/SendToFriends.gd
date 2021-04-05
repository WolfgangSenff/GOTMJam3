extends Control
const ColorWords = [
    "Purple", "Red", "Brown", "Blue", "Black", "Green", "Yellow",
    "Teal", "Puce", "Gray", "Lilac", "Orange", "Hungry", "Thirsty",
    "Cream"
   ]

const VerbWords = [
    "Smell", "Taste", "See", "Vote", "Eat", "Hear", "Drink",
    "Lift", "Throw", "Kick", "Crawl", "Paint", "Shave", "Pet",
    "Nust", "Drive", "Trust", "Call", "Run", "Melt", "Cheat",
    "Punch", "Open", "Close", "Turn", "Shake"
   ]

const NounWords = [
    "Bread", "Toast", "Cat", "Dog", "Table", "Chips", "Ground",
    "Leaf", "Elephant", "Giraffe", "Lambo", "Fish", "Carrot",
    "Lettuce", "Cereal", "Celery", "Fire", "Car", "Truck",
    "Corn", "Chicken", "Turkey", "Beef", "Peanut", "Kale", "Dino",
    "Pizza", "Bear", "Coat", "Godot", "Person", "Animal", "Place",
    "Thing", "Vehicle", "Cow", "Drink"
   ]

onready var link = $MarginContainer/Control/DynamicLink
onready var user_name = $MarginContainer/Control/LineEdit2
onready var fremb_hint = $MarginContainer/Control/LineEdit

func _ready() -> void:
    randomize()
    var verb = get_random_word(VerbWords)
    var color = get_random_word(ColorWords)
    var noun = get_random_word(NounWords)
    if Globals.user_name:
        user_name.text = Globals.user_name
    link.text = verb + "-" + color + "-" + noun
    Globals.dynamic_link = verb + "-" + color + "-" + noun
    
static func get_random_word(word_list : Array) -> String:
    return word_list[randi() % word_list.size()]

func _on_Button_pressed() -> void:
    if fremb_hint and fremb_hint.text and user_name and user_name.text:
        Globals.dynamic_link = fremb_hint.text
        Globals.user_name = user_name.text
        Globals.is_my_game = false
        Globals.go_to_lobby()
    elif user_name and user_name.text and link and link.text:
        Globals.dynamic_link = link.text
        Globals.user_name = user_name.text
        Globals.is_my_game = true
        Globals.go_to_lobby()
        

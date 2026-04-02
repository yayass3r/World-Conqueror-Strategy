extends Control

func _ready() -> void:
    var play_btn = get_node_or_null("ButtonsContainer/PlayBtn")
    var easy_btn = get_node_or_null("ButtonsContainer/EasyBtn")
    var medium_btn = get_node_or_null("ButtonsContainer/MediumBtn")
    var hard_btn = get_node_or_null("ButtonsContainer/HardBtn")
    var quit_btn = get_node_or_null("ButtonsContainer/QuitBtn")
    if play_btn and play_btn is Button:
        play_btn.pressed.connect(func(): _start_game(1))
    if easy_btn and easy_btn is Button:
        easy_btn.pressed.connect(func(): _start_game(0))
    if medium_btn and medium_btn is Button:
        medium_btn.pressed.connect(func(): _start_game(1))
    if hard_btn and hard_btn is Button:
        hard_btn.pressed.connect(func(): _start_game(2))
    if quit_btn and quit_btn is Button:
        quit_btn.pressed.connect(get_tree().quit)

func _start_game(difficulty: int) -> void:
    GameManager.difficulty = difficulty
    get_tree().change_scene_to_file("res://scenes/Game.tscn")

extends Node

enum GameState { MAIN_MENU, PLAYING, GAME_OVER, VICTORY }
enum Difficulty { EASY, MEDIUM, HARD }
enum Team { PLAYER, ENEMY, NEUTRAL }

signal game_over(won: bool)
signal unit_selected(unit)
signal unit_deselected()

var current_state: int = GameState.MAIN_MENU
var difficulty: int = Difficulty.MEDIUM
var current_turn: int = 1
var selected_unit: Node2D = null
var all_units: Array = []
var map_node: Node2D = null

func start_game(diff: int) -> void:
    difficulty = diff
    current_turn = 1
    current_state = GameState.PLAYING
    selected_unit = null
    all_units.clear()

func register_unit(unit: Node2D) -> void:
    if unit != null and not all_units.has(unit):
        all_units.append(unit)

func unregister_unit(unit: Node2D) -> void:
    if unit != null:
        all_units.erase(unit)
        if selected_unit == unit:
            selected_unit = null

func select_unit(unit: Node2D) -> void:
    if unit != null:
        selected_unit = unit
        unit_selected.emit(unit)

func deselect_unit() -> void:
    selected_unit = null
    unit_deselected.emit()

func get_units_of_team(team: int) -> Array:
    var result: Array = []
    for u in all_units:
        if is_instance_valid(u) and u.get("team") == team:
            result.append(u)
    return result

func check_win_conditions() -> void:
    if current_state != GameState.PLAYING:
        return
    var p_units := get_units_of_team(Team.PLAYER)
    var e_units := get_units_of_team(Team.ENEMY)
    if e_units.size() == 0:
        current_state = GameState.VICTORY
        game_over.emit(true)
    elif p_units.size() == 0:
        current_state = GameState.GAME_OVER
        game_over.emit(false)

func get_difficulty_modifier() -> float:
    if difficulty == Difficulty.EASY:
        return 0.7
    elif difficulty == Difficulty.HARD:
        return 1.4
    return 1.0

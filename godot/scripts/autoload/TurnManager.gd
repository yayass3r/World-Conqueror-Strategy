extends Node

enum Phase { PLAYER_START, PLAYER_MOVE, PLAYER_ATTACK, ENEMY_TURN, TURN_END }

signal phase_changed(new_phase: int)
signal player_turn_started()
signal enemy_turn_started()
signal turn_ended(turn_number: int)

var current_phase: int = Phase.PLAYER_MOVE
var _ai_timer: Timer = null
var _ai_units: Array = []
var _ai_index: int = 0

func _ready() -> void:
    _ai_timer = Timer.new()
    _ai_timer.wait_time = 0.7
    _ai_timer.one_shot = true
    _ai_timer.timeout.connect(_on_ai_tick)
    add_child(_ai_timer)

func start_player_turn() -> void:
    if GameManager.current_state != GameManager.GameState.PLAYING:
        return
    current_phase = Phase.PLAYER_MOVE
    phase_changed.emit(current_phase)
    _reset_units(GameManager.Team.PLAYER)
    EconomyManager.collect_income()
    player_turn_started.emit()

func start_enemy_turn() -> void:
    if GameManager.current_state != GameManager.GameState.PLAYING:
        return
    current_phase = Phase.ENEMY_TURN
    phase_changed.emit(current_phase)
    _reset_units(GameManager.Team.ENEMY)
    EconomyManager.collect_enemy_income()
    enemy_turn_started.emit()
    _ai_units = GameManager.get_units_of_team(GameManager.Team.ENEMY)
    _ai_index = 0
    if _ai_units.size() > 0:
        _ai_timer.start()
    else:
        _finish_enemy()

func end_player_turn() -> void:
    if current_phase != Phase.PLAYER_MOVE:
        return
    GameManager.deselect_unit()
    current_phase = Phase.TURN_END
    phase_changed.emit(current_phase)
    await get_tree().create_timer(0.3).timeout
    start_enemy_turn()

func is_player_phase() -> bool:
    return current_phase == Phase.PLAYER_MOVE or current_phase == Phase.PLAYER_ATTACK

func _reset_units(team: int) -> void:
    for u in GameManager.all_units:
        if is_instance_valid(u) and u.get("team") == team:
            u.set("has_moved", false)
            u.set("has_attacked", false)
            if u.get("max_movement_points") != null:
                u.set("movement_points", u.max_movement_points)

func _on_ai_tick() -> void:
    if GameManager.current_state != GameManager.GameState.PLAYING:
        return
    if _ai_index >= _ai_units.size():
        _finish_enemy()
        return
    var unit = _ai_units[_ai_index]
    if is_instance_valid(unit) and unit.get("is_alive"):
        AIController.process_unit(unit)
    _ai_index += 1
    if _ai_index < _ai_units.size():
        _ai_timer.start()
    else:
        _ai_timer.start()

func _finish_enemy() -> void:
    _ai_timer.stop()
    GameManager.current_turn += 1
    turn_ended.emit(GameManager.current_turn)
    GameManager.check_win_conditions()
    if GameManager.current_state == GameManager.GameState.PLAYING:
        await get_tree().create_timer(0.4).timeout
        start_player_turn()

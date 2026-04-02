extends Node2D

const TILE_SIZE = Vector2(100, 100)
const TILE_TEX = {
    0: "res://assets/terrain/plains.png",
    1: "res://assets/terrain/forest.png",
    2: "res://assets/terrain/mountain.png",
    3: "res://assets/terrain/desert.png",
    4: "res://assets/terrain/sea.png",
    5: "res://assets/terrain/city.png",
}

var selected_unit = null
var movement_tiles: Array = []
var attack_targets: Array = []

func _ready() -> void:
    GameManager.current_state = GameManager.GameState.PLAYING
    GameManager.map_node = self
    EconomyManager.initialize_gold()
    if MapGenerator.terrain_map.is_empty():
        MapGenerator.generate_terrain_map()
        MapGenerator.generate_starting_units()
    _setup_camera()
    _build_terrain()
    _spawn_units()
    await get_tree().create_timer(0.3).timeout
    TurnManager.start_player_turn()
    await get_tree().create_timer(0.5).timeout
    UIManager.update_mini_map()

func _setup_camera() -> void:
    var cam = $Camera2D
    if cam:
        cam.limit_left = -100
        cam.limit_top = -100
        cam.limit_right = MapGenerator.MAP_WIDTH * TILE_SIZE.x + 100
        cam.limit_bottom = MapGenerator.MAP_HEIGHT * TILE_SIZE.y + 100
        cam.position = Vector2(MapGenerator.MAP_WIDTH * TILE_SIZE.x / 2.0, MapGenerator.MAP_HEIGHT * TILE_SIZE.y / 2.0)
        cam.zoom = Vector2(0.85, 0.85)

func _build_terrain() -> void:
    var layer = $TerrainLayer
    for y in range(MapGenerator.MAP_HEIGHT):
        for x in range(MapGenerator.MAP_WIDTH):
            var tid: int = MapGenerator.get_terrain_at(Vector2i(x, y))
            var path: String = TILE_TEX.get(tid, TILE_TEX[0])
            var spr = Sprite2D.new()
            if ResourceLoader.exists(path):
                spr.texture = load(path)
            spr.scale = Vector2(TILE_SIZE.x / 1024.0, TILE_SIZE.y / 1024.0)
            spr.position = Vector2(x * TILE_SIZE.x + TILE_SIZE.x / 2.0, y * TILE_SIZE.y + TILE_SIZE.y / 2.0)
            spr.z_index = 0
            layer.add_child(spr)

func _spawn_units() -> void:
    for team_key in [0, 1]:
        var data: Array = MapGenerator.starting_units.get(team_key, [])
        for d in data:
            _create_unit(d["unit_type"], team_key, d["pos"])

func _create_unit(type: int, team: int, pos: Vector2i) -> void:
    var unit = Sprite2D.new()
    unit.set_script(load("res://scripts/units/Unit.gd"))
    unit.setup(type, team, pos, TILE_SIZE)
    $UnitsContainer.add_child(unit)
    GameManager.register_unit(unit)

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventScreenTouch and event.pressed and not event.is_echo():
        _handle_tap(event.position)
    elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and not event.is_echo():
        _handle_tap(event.position)

func _handle_tap(screen_pos: Vector2) -> void:
    if not TurnManager.is_player_phase():
        return
    var world_pos: Vector2 = get_canvas_transform().affine_inverse() * screen_pos
    var gx: int = int(world_pos.x / TILE_SIZE.x)
    var gy: int = int(world_pos.y / TILE_SIZE.y)
    var grid_pos = Vector2i(gx, gy)
    if not MapGenerator._valid(grid_pos):
        _clear_selection()
        return

    var clicked = _get_unit_at(grid_pos)
    if selected_unit:
        if clicked and clicked.team == 0:
            _select(clicked)
        elif clicked and clicked.team != 0 and selected_unit.can_attack_unit(clicked):
            _do_attack(selected_unit, clicked)
        elif grid_pos in movement_tiles and selected_unit.can_move_to(grid_pos):
            selected_unit.move_to(grid_pos, TILE_SIZE)
            _clear_overlays()
            _show_attack_range(selected_unit)
            UIManager.update_mini_map()
        else:
            _clear_selection()
    else:
        if clicked and clicked.team == 0:
            _select(clicked)

func _get_unit_at(pos: Vector2i) -> Node2D:
    for u in GameManager.all_units:
        if is_instance_valid(u) and u.grid_position == pos and u.is_alive:
            return u
    return null

func _select(unit) -> void:
    _clear_selection()
    selected_unit = unit
    GameManager.select_unit(unit)
    unit.show_selection()
    UIManager.show_unit_info(unit)
    _show_movement_range(unit)

func _clear_selection() -> void:
    if selected_unit and is_instance_valid(selected_unit):
        selected_unit.hide_selection()
    selected_unit = null
    GameManager.deselect_unit()
    UIManager.hide_unit_info()
    _clear_overlays()

func _show_movement_range(unit) -> void:
    _clear_overlays()
    movement_tiles = unit.get_movement_range()
    for pos in movement_tiles:
        var r = ColorRect.new()
        r.size = TILE_SIZE
        r.position = Vector2(pos.x * TILE_SIZE.x, pos.y * TILE_SIZE.y)
        r.color = Color(0.2, 0.5, 1.0, 0.3)
        r.z_index = 3
        $MovementOverlay.add_child(r)

func _show_attack_range(unit) -> void:
    for ch in $AttackOverlay.get_children():
        ch.queue_free()
    attack_targets.clear()
    for t in unit.get_attack_targets():
        var r = ColorRect.new()
        r.size = TILE_SIZE
        r.position = Vector2(t.grid_position.x * TILE_SIZE.x, t.grid_position.y * TILE_SIZE.y)
        r.color = Color(1.0, 0.2, 0.2, 0.3)
        r.z_index = 3
        $AttackOverlay.add_child(r)

func _do_attack(attacker, defender) -> void:
    var tname: String = "plains"
    if MapGenerator:
        tname = MapGenerator.get_terrain_name(defender.grid_position)
    var result: Dictionary = CombatSystem.resolve_combat(attacker, defender, tname)
    CombatSystem.apply_combat(attacker, defender, result)
    attacker.has_attacked = true
    var msg: String = "Dealt %d dmg" % result.get("damage", 0)
    if result.get("counter_damage", 0) > 0:
        msg += " | Took %d" % result["counter_damage"]
    if not result.get("defender_survives", true):
        msg += " | DESTROYED!"
    UIManager.show_toast(msg)
    _clear_selection()
    await get_tree().create_timer(0.5).timeout
    UIManager.update_mini_map()

func _clear_overlays() -> void:
    for ch in $MovementOverlay.get_children():
        ch.queue_free()
    movement_tiles.clear()
    for ch in $AttackOverlay.get_children():
        ch.queue_free()
    attack_targets.clear()

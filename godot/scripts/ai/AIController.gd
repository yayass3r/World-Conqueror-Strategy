extends Node

func process_unit(unit) -> void:
    if not is_instance_valid(unit) or not unit.get("is_alive"):
        return
    if unit.team != 1:
        return
    await get_tree().create_timer(0.3).timeout

    if not unit.has_attacked:
        var targets: Array = unit.get_attack_targets()
        if targets.size() > 0:
            targets.sort_custom(func(a, b): return a.hp < b.hp)
            _attack(unit, targets[0])
            await get_tree().create_timer(0.2).timeout

    if not unit.has_moved and unit.is_alive:
        var target_pos: Vector2i = _find_target(unit)
        var move_range: Array = unit.get_movement_range()
        _move_to(unit, target_pos, move_range)
        await get_tree().create_timer(0.2).timeout

    if not unit.has_attacked and unit.is_alive:
        var targets: Array = unit.get_attack_targets()
        if targets.size() > 0:
            targets.sort_custom(func(a, b): return a.hp < b.hp)
            _attack(unit, targets[0])

    if unit.is_alive and MapGenerator:
        var cd: Dictionary = MapGenerator.get_city_at(unit.grid_position)
        if not cd.is_empty() and cd.get("team", -1) != unit.team:
            MapGenerator.set_city_owner(unit.grid_position, unit.team)

func _attack(attacker, defender) -> void:
    var tname: String = "plains"
    if MapGenerator:
        tname = MapGenerator.get_terrain_name(defender.grid_position)
    var result: Dictionary = CombatSystem.resolve_combat(attacker, defender, tname)
    CombatSystem.apply_combat(attacker, defender, result)
    attacker.has_attacked = true

func _find_target(unit) -> Vector2i:
    if not MapGenerator:
        return unit.grid_position
    var best_pos: Vector2i = unit.grid_position
    var best_score: float = -999999.0
    var w: int = MapGenerator.MAP_WIDTH
    var h: int = MapGenerator.MAP_HEIGHT

    for x in range(w):
        for y in range(h):
            var pos := Vector2i(x, y)
            var score: float = 0.0
            for pu in GameManager.all_units:
                if pu.team == 0 and pu.is_alive:
                    var d: int = abs(pos.x - pu.grid_position.x) + abs(pos.y - pu.grid_position.y)
                    if d <= unit.attack_range + unit.movement_points:
                        score += 100.0
                    score -= float(d) * 2.0
            for c in MapGenerator.city_positions:
                if c.get("team", -1) != 1:
                    var d: int = abs(pos.x - c["pos"].x) + abs(pos.y - c["pos"].y)
                    score -= float(d) * 5.0
            var tname: String = MapGenerator.get_terrain_name(pos)
            if tname == "sea":
                score -= 1000.0
            if not MapGenerator.is_passable(pos):
                score -= 1000.0
            for ou in GameManager.all_units:
                if ou != unit and ou.is_alive and ou.grid_position == pos:
                    score -= 500.0
            if score > best_score:
                best_score = score
                best_pos = pos
    return best_pos

func _move_to(unit, target: Vector2i, move_range: Array) -> bool:
    if move_range.is_empty():
        return false
    var best_pos: Vector2i = unit.grid_position
    var best_dist: int = abs(unit.grid_position.x - target.x) + abs(unit.grid_position.y - target.y)
    for pos in move_range:
        var d: int = abs(pos.x - target.x) + abs(pos.y - target.y)
        if d < best_dist:
            var blocked: bool = false
            for ou in GameManager.all_units:
                if ou != unit and ou.is_alive and ou.grid_position == pos:
                    blocked = true
                    break
            if not blocked:
                best_dist = d
                best_pos = pos
    if best_pos != unit.grid_position:
        unit.move_to(best_pos, Vector2(100, 100))
        return true
    return false

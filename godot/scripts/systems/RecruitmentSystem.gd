extends Node

const UNIT_COSTS = {0: 100, 1: 200, 2: 180, 3: 300, 4: 160, 5: 120}
const UNIT_NAMES = {0: "Infantry", 1: "Tank", 2: "Artillery", 3: "Aircraft", 4: "AntiAir", 5: "Scout"}

var cities_recruited: Dictionary = {}

func can_recruit(unit_type: int, team: int, city_pos: Vector2i) -> bool:
    if cities_recruited.has(city_pos):
        return false
    if not EconomyManager.can_afford(team, UNIT_COSTS.get(unit_type, 999)):
        return false
    return true

func recruit_unit(unit_type: int, team: int, city_pos: Vector2i, units_container: Node2D) -> void:
    var cost: int = UNIT_COSTS.get(unit_type, 999)
    if not EconomyManager.spend_gold(team, cost):
        return
    cities_recruited[city_pos] = true
    var spawn_pos: Vector2i = _find_spawn(city_pos)
    var unit = Sprite2D.new()
    unit.set_script(load("res://scripts/units/Unit.gd"))
    unit.setup(unit_type, team, spawn_pos, Vector2(100, 100))
    unit.has_moved = true
    unit.has_attacked = true
    units_container.add_child(unit)
    GameManager.register_unit(unit)

func _find_spawn(city_pos: Vector2i) -> Vector2i:
    var dirs = [Vector2i(1,0),Vector2i(-1,0),Vector2i(0,1),Vector2i(0,-1)]
    for d in dirs:
        var p = city_pos + d
        if MapGenerator and MapGenerator.is_passable(p):
            var occupied: bool = false
            for u in GameManager.all_units:
                if u.grid_position == p:
                    occupied = true
                    break
            if not occupied:
                return p
    return city_pos

func on_turn_start() -> void:
    cities_recruited.clear()

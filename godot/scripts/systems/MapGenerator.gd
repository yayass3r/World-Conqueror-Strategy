extends Node

const MAP_WIDTH: int = 12
const MAP_HEIGHT: int = 8

enum Terrain { PLAINS, FOREST, MOUNTAIN, DESERT, SEA, CITY }

var terrain_map: Array = []
var city_positions: Array = []
var starting_units: Dictionary = {}

func _ready() -> void:
    generate_terrain_map()
    generate_starting_units()

func generate_terrain_map() -> void:
    terrain_map.clear()
    city_positions.clear()
    for y in range(MAP_HEIGHT):
        var row: Array = []
        for x in range(MAP_WIDTH):
            row.append(Terrain.PLAINS)
        terrain_map.append(row)
    _place_batch([Vector2i(1,1),Vector2i(2,2),Vector2i(3,5),Vector2i(1,6),Vector2i(8,2),Vector2i(9,3),Vector2i(7,5),Vector2i(10,6),Vector2i(5,1),Vector2i(6,6)], Terrain.FOREST)
    _place_batch([Vector2i(2,4),Vector2i(4,3),Vector2i(7,1),Vector2i(9,5)], Terrain.MOUNTAIN)
    _place_batch([Vector2i(4,6),Vector2i(5,5),Vector2i(6,4)], Terrain.DESERT)
    _place_batch([Vector2i(0,0),Vector2i(11,0),Vector2i(11,7),Vector2i(0,7),Vector2i(5,0),Vector2i(6,0)], Terrain.SEA)
    var cities = [
        {"pos": Vector2i(1,3), "team": 0, "name": "Westgate"},
        {"pos": Vector2i(2,5), "team": 0, "name": "Ironhold"},
        {"pos": Vector2i(0,4), "team": 0, "name": "Stormhaven"},
        {"pos": Vector2i(5,3), "team": 2, "name": "Crossroads"},
        {"pos": Vector2i(6,2), "team": 2, "name": "Highpass"},
        {"pos": Vector2i(9,4), "team": 1, "name": "Blackrock"},
        {"pos": Vector2i(10,2), "team": 1, "name": "Shadowkeep"},
        {"pos": Vector2i(11,3), "team": 1, "name": "Darkhold"},
    ]
    for c in cities:
        var p: Vector2i = c["pos"]
        if _valid(p):
            terrain_map[p.y][p.x] = Terrain.CITY
            city_positions.append(c)

func generate_starting_units() -> void:
    starting_units.clear()
    starting_units[0] = [
        {"unit_type": 0, "pos": Vector2i(1,2)},
        {"unit_type": 0, "pos": Vector2i(0,3)},
        {"unit_type": 1, "pos": Vector2i(1,4)},
        {"unit_type": 2, "pos": Vector2i(2,6)},
        {"unit_type": 5, "pos": Vector2i(3,1)},
        {"unit_type": 0, "pos": Vector2i(3,4)},
    ]
    starting_units[1] = [
        {"unit_type": 0, "pos": Vector2i(10,5)},
        {"unit_type": 0, "pos": Vector2i(11,4)},
        {"unit_type": 1, "pos": Vector2i(10,3)},
        {"unit_type": 2, "pos": Vector2i(9,1)},
        {"unit_type": 5, "pos": Vector2i(8,6)},
        {"unit_type": 0, "pos": Vector2i(8,3)},
    ]

func get_terrain_at(pos: Vector2i) -> int:
    if not _valid(pos):
        return -1
    return terrain_map[pos.y][pos.x]

func get_terrain_name(pos: Vector2i) -> String:
    var t = get_terrain_at(pos)
    if t == Terrain.FOREST:
        return "forest"
    elif t == Terrain.MOUNTAIN:
        return "mountain"
    elif t == Terrain.DESERT:
        return "desert"
    elif t == Terrain.SEA:
        return "sea"
    elif t == Terrain.CITY:
        return "city"
    return "plains"

func get_city_at(pos: Vector2i) -> Dictionary:
    for c in city_positions:
        if c["pos"] == pos:
            return c
    return {}

func set_city_owner(pos: Vector2i, team: int) -> void:
    for c in city_positions:
        if c["pos"] == pos:
            c["team"] = team
            return

func is_passable(pos: Vector2i) -> bool:
    var t = get_terrain_at(pos)
    return t != Terrain.SEA and t >= 0

func _place_batch(positions: Array, terrain_type: int) -> void:
    for p in positions:
        if _valid(p):
            terrain_map[p.y][p.x] = terrain_type

func _valid(pos: Vector2i) -> bool:
    return pos.x >= 0 and pos.x < MAP_WIDTH and pos.y >= 0 and pos.y < MAP_HEIGHT

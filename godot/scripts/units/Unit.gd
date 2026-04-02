extends Sprite2D
class_name Unit

const TYPE_INFANTRY = 0
const TYPE_TANK = 1
const TYPE_ARTILLERY = 2
const TYPE_AIRCRAFT = 3
const TYPE_ANTIAIR = 4
const TYPE_SCOUT = 5

const STATS = {
    TYPE_INFANTRY: {"hp": 100, "attack": 30, "defense": 15, "move": 3, "vision": 3, "range": 1},
    TYPE_TANK: {"hp": 150, "attack": 45, "defense": 25, "move": 4, "vision": 3, "range": 1},
    TYPE_ARTILLERY: {"hp": 80, "attack": 50, "defense": 10, "move": 2, "vision": 4, "range": 3},
    TYPE_AIRCRAFT: {"hp": 90, "attack": 40, "defense": 8, "move": 6, "vision": 5, "range": 2},
    TYPE_ANTIAIR: {"hp": 110, "attack": 35, "defense": 12, "move": 3, "vision": 4, "range": 2},
    TYPE_SCOUT: {"hp": 60, "attack": 15, "defense": 5, "move": 5, "vision": 6, "range": 1},
}

const P_SPRITES = {
    TYPE_INFANTRY: "res://assets/sprites/units/infantry.png",
    TYPE_TANK: "res://assets/sprites/units/tank.png",
    TYPE_ARTILLERY: "res://assets/sprites/units/artillery.png",
    TYPE_AIRCRAFT: "res://assets/sprites/units/aircraft.png",
    TYPE_ANTIAIR: "res://assets/sprites/units/antiair.png",
    TYPE_SCOUT: "res://assets/sprites/units/scout.png",
}

const E_SPRITES = {
    TYPE_INFANTRY: "res://assets/sprites/units/infantry_enemy.png",
    TYPE_TANK: "res://assets/sprites/units/tank_enemy.png",
    TYPE_ARTILLERY: "res://assets/sprites/units/artillery_enemy.png",
    TYPE_AIRCRAFT: "res://assets/sprites/units/aircraft_enemy.png",
    TYPE_ANTIAIR: "res://assets/sprites/units/antiair_enemy.png",
    TYPE_SCOUT: "res://assets/sprites/units/scout_enemy.png",
}

const MOVE_COST = {
    TYPE_INFANTRY: {"plains": 1, "forest": 1, "mountain": 2, "desert": 1, "city": 1, "sea": 99},
    TYPE_TANK: {"plains": 1, "forest": 2, "mountain": 99, "desert": 2, "city": 1, "sea": 99},
    TYPE_ARTILLERY: {"plains": 1, "forest": 2, "mountain": 99, "desert": 1, "city": 1, "sea": 99},
    TYPE_AIRCRAFT: {"plains": 1, "forest": 1, "mountain": 1, "desert": 1, "city": 1, "sea": 1},
    TYPE_ANTIAIR: {"plains": 1, "forest": 1, "mountain": 2, "desert": 1, "city": 1, "sea": 99},
    TYPE_SCOUT: {"plains": 1, "forest": 1, "mountain": 2, "desert": 1, "city": 1, "sea": 99},
}

var unit_type: int = 0
var team: int = 0
var grid_position: Vector2i = Vector2i.ZERO
var hp: int = 100
var max_hp: int = 100
var attack_power: int = 30
var defense: int = 15
var attack_range: int = 1
var vision_range: int = 3
var movement_points: int = 3
var max_movement_points: int = 3
var has_moved: bool = false
var has_attacked: bool = false
var is_alive: bool = true
var _sel_node: Node2D = null
var _tile_size: Vector2 = Vector2(100, 100)

func setup(type: int, team_val: int, pos: Vector2i, tile_size: Vector2 = Vector2(100, 100)) -> void:
    unit_type = type
    team = team_val
    grid_position = pos
    _tile_size = tile_size
    var s = STATS.get(type, STATS[TYPE_INFANTRY])
    max_hp = s["hp"]
    hp = max_hp
    attack_power = s["attack"]
    defense = s["defense"]
    movement_points = s["move"]
    max_movement_points = s["move"]
    vision_range = s["vision"]
    attack_range = s["range"]
    var spr_path: String = (P_SPRITES if team == 0 else E_SPRITES).get(type, "")
    if spr_path != "" and ResourceLoader.exists(spr_path):
        texture = load(spr_path)
    else:
        texture = _make_texture(type, team)
    scale = Vector2(0.08, 0.08)
    offset = Vector2(0, 512)
    z_index = 10
    _make_hp_bar()
    var lbl = Label.new()
    lbl.text = _type_name()
    lbl.position = Vector2(-20, -78)
    lbl.add_theme_font_size_override("font_size", 10)
    lbl.add_theme_color_override("font_color", Color.WHITE)
    lbl.z_index = 20
    add_child(lbl)
    name = _type_name() + ("_P" if team == 0 else "_E")
    _update_pos(tile_size)

func _make_texture(type: int, t: int) -> Texture2D:
    var img = Image.create(64, 64, false, Image.FORMAT_RGBA8)
    img.fill(Color.TRANSPARENT)
    var c: Color
    if type == 0:
        c = Color(0.2, 0.4, 1.0) if t == 0 else Color(1.0, 0.2, 0.2)
    elif type == 1:
        c = Color(0.1, 0.2, 0.7) if t == 0 else Color(0.7, 0.1, 0.1)
    elif type == 2:
        c = Color(0.0, 0.6, 0.8) if t == 0 else Color(1.0, 0.5, 0.0)
    elif type == 3:
        c = Color(0.5, 0.7, 1.0) if t == 0 else Color(1.0, 0.5, 0.5)
    elif type == 4:
        c = Color(0.4, 0.2, 0.8) if t == 0 else Color(0.8, 0.1, 0.2)
    elif type == 5:
        c = Color(0.0, 0.5, 0.5) if t == 0 else Color(1.0, 0.3, 0.5)
    else:
        c = Color.GRAY
    img.fill_rect(Rect2i(4, 4, 56, 56), c)
    return ImageTexture.create_from_image(img)

func _make_hp_bar() -> void:
    var bg = NinePatchRect.new()
    bg.texture = _solid_tex(Color(0, 0, 0, 160))
    bg.size = Vector2(64, 8)
    bg.position = Vector2(-32, -62)
    bg.z_index = 20
    add_child(bg)
    var fill = NinePatchRect.new()
    fill.name = "HPFill"
    fill.texture = _solid_tex(Color.GREEN)
    fill.size = Vector2(64, 8)
    fill.position = Vector2(-32, -62)
    fill.z_index = 21
    add_child(fill)

func _solid_tex(c: Color) -> Texture2D:
    var img = Image.create(4, 4, false, Image.FORMAT_RGBA8)
    img.fill(c)
    return ImageTexture.create_from_image(img)

func _type_name() -> String:
    if unit_type == 0: return "Infantry"
    elif unit_type == 1: return "Tank"
    elif unit_type == 2: return "Artillery"
    elif unit_type == 3: return "Aircraft"
    elif unit_type == 4: return "AntiAir"
    elif unit_type == 5: return "Scout"
    return "Unit"

func _update_pos(ts: Vector2) -> void:
    position = Vector2(grid_position.x * ts.x + ts.x / 2.0, grid_position.y * ts.y + ts.y / 2.0)

func move_to(new_pos: Vector2i, tile_size: Vector2 = _tile_size) -> bool:
    if has_moved or not is_alive:
        return false
    grid_position = new_pos
    has_moved = true
    _tile_size = tile_size
    _update_pos(tile_size)
    return true

func get_movement_range() -> Array:
    var reached: Array = []
    var visited: Dictionary = {}
    var queue: Array = [{"pos": grid_position, "cost": 0}]
    visited[grid_position] = true
    var costs: Dictionary = MOVE_COST.get(unit_type, MOVE_COST[0])
    while queue.size() > 0:
        queue.sort_custom(func(a, b): return a["cost"] < b["cost"])
        var cur = queue.pop_front()
        reached.append(cur["pos"])
        var dirs = [Vector2i(1,0),Vector2i(-1,0),Vector2i(0,1),Vector2i(0,-1),Vector2i(1,1),Vector2i(-1,-1),Vector2i(1,-1),Vector2i(-1,1)]
        for d in dirs:
            var np = cur["pos"] + d
            if not MapGenerator or not MapGenerator._valid(np):
                continue
            if visited.has(np):
                continue
            var tname: String = MapGenerator.get_terrain_name(np)
            var c: int = costs.get(tname, 1)
            if c >= 99:
                continue
            var total: int = cur["cost"] + c
            if total <= movement_points:
                var blocked: bool = false
                for ou in GameManager.all_units:
                    if ou != self and ou.grid_position == np and ou.is_alive:
                        blocked = true
                        break
                if not blocked:
                    visited[np] = true
                    queue.append({"pos": np, "cost": total})
    return reached

func get_attack_targets() -> Array:
    var targets: Array = []
    for u in GameManager.all_units:
        if u == self or not u.is_alive or u.team == team:
            continue
        var d: int = abs(u.grid_position.x - grid_position.x) + abs(u.grid_position.y - grid_position.y)
        if d <= attack_range and d > 0:
            targets.append(u)
    return targets

func can_attack_unit(target) -> bool:
    if has_attacked or not target or not target.is_alive or target.team == team:
        return false
    var d: int = abs(target.grid_position.x - grid_position.x) + abs(target.grid_position.y - grid_position.y)
    return d <= attack_range and d > 0

func can_move_to(pos: Vector2i) -> bool:
    if has_moved:
        return false
    return pos in get_movement_range()

func take_damage(amount: int) -> void:
    if not is_alive:
        return
    hp -= amount
    if hp < 0:
        hp = 0
    var fill = get_node_or_null("HPFill")
    if fill and fill is NinePatchRect:
        var ratio: float = float(hp) / float(max_hp)
        fill.size.x = 64.0 * ratio
        fill.position.x = -32.0 + (64.0 - 64.0 * ratio) / 2.0
        var c = Color.GREEN
        if ratio <= 0.3:
            c = Color.RED
        elif ratio <= 0.6:
            c = Color.YELLOW
        fill.texture = _solid_tex(c)
    if hp <= 0:
        die()

func die() -> void:
    if not is_alive:
        return
    is_alive = false
    if GameManager:
        GameManager.unregister_unit(self)
    hide_selection()
    var tw = create_tween()
    tw.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.3)
    tw.tween_callback(queue_free)

func show_selection() -> void:
    if _sel_node:
        return
    _sel_node = Node2D.new()
    _sel_node.z_index = 15
    var ring = Line2D.new()
    ring.width = 3.0
    ring.default_color = Color(1, 1, 0.3, 0.9)
    var pts: Array = []
    for i in range(33):
        var a: float = TAU * float(i) / 32.0
        pts.append(Vector2(cos(a) * 48.0, sin(a) * 48.0 - 40.0))
    ring.points = pts
    _sel_node.add_child(ring)
    add_child(_sel_node)

func hide_selection() -> void:
    if _sel_node:
        _sel_node.queue_free()
        _sel_node = null

func get_info_string() -> String:
    return "%s HP:%d/%d ATK:%d DEF:%d" % [_type_name(), hp, max_hp, attack_power, defense]

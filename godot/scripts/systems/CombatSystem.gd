extends Node

enum UnitType { INFANTRY, TANK, ARTILLERY, AIRCRAFT, ANTI_AIR, SCOUT }

const TYPE_ADV = {
    Vector2i(0, 2): 1.5,
    Vector2i(2, 1): 1.5,
    Vector2i(1, 0): 1.5,
    Vector2i(3, 1): 1.3,
    Vector2i(3, 2): 1.3,
    Vector2i(4, 3): 1.5,
}

const TERRAIN_DEF = {
    "plains": 0.0, "forest": 0.2, "mountain": 0.4,
    "desert": -0.1, "city": 0.3, "sea": 0.0,
}

static func resolve_combat(attacker, defender, terrain_type: String) -> Dictionary:
    var atk_pow: float = float(attacker.attack_power)
    var atk_type: int = attacker.unit_type
    var def_pow: float = float(defender.defense)
    var def_hp: int = defender.hp

    var key = Vector2i(atk_type, defender.unit_type)
    var type_mult: float = TYPE_ADV.get(key, 1.0)
    var terrain_def: float = TERRAIN_DEF.get(terrain_type, 0.0)
    var eff_def: float = def_pow * (1.0 + terrain_def)
    var variance: float = randf_range(0.85, 1.15)
    var is_crit: bool = randf() < 0.1
    var crit_mult: float = 1.0
    if is_crit:
        crit_mult = 1.5
    var diff_mod: float = 1.0
    if GameManager:
        if attacker.team == 1:
            diff_mod = GameManager.get_difficulty_modifier()

    var raw: float = atk_pow * type_mult * variance * diff_mod * crit_mult
    var damage: int = maxi(1, int(raw - eff_def * 0.5))
    var defender_survives: bool = (def_hp - damage) > 0

    var counter_dmg: int = 0
    if defender_survives:
        var c_variance: float = randf_range(0.85, 1.15)
        var c_raw: float = float(defender.attack_power) * 0.5 * c_variance
        counter_dmg = maxi(0, int(c_raw - float(atk_type) * 0.1))

    return {
        "damage": damage,
        "counter_damage": counter_dmg,
        "defender_survives": defender_survives,
        "critical_hit": is_crit,
        "type_multiplier": type_mult,
    }

static func apply_combat(attacker, defender, result: Dictionary) -> void:
    defender.take_damage(result["damage"])
    if result["counter_damage"] > 0 and defender.hp > 0:
        attacker.take_damage(result["counter_damage"])
    if defender.hp <= 0:
        defender.die()
    if attacker.hp <= 0:
        attacker.die()
    if GameManager:
        GameManager.check_win_conditions()

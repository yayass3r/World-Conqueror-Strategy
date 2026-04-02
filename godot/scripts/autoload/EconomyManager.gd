extends Node

signal gold_updated(team: int, new_amount: int)

var player_gold: int = 200
var enemy_gold: int = 200
var income_per_city: int = 50

func initialize_gold() -> void:
    player_gold = 200
    enemy_gold = 200
    gold_updated.emit(0, player_gold)
    gold_updated.emit(1, enemy_gold)

func collect_income() -> void:
    var cities: Array = []
    if MapGenerator:
        cities = MapGenerator.city_positions.filter(func(c): return c.get("team", -1) == 0)
    var income: int = cities.size() * income_per_city
    player_gold += income
    gold_updated.emit(0, player_gold)

func collect_enemy_income() -> void:
    var cities: Array = []
    if MapGenerator:
        cities = MapGenerator.city_positions.filter(func(c): return c.get("team", -1) == 1)
    var income: int = cities.size() * income_per_city
    enemy_gold += income
    gold_updated.emit(1, enemy_gold)

func can_afford(team: int, cost: int) -> bool:
    if team == 0:
        return player_gold >= cost
    elif team == 1:
        return enemy_gold >= cost
    return false

func spend_gold(team: int, amount: int) -> bool:
    if amount < 0 or not can_afford(team, amount):
        return false
    if team == 0:
        player_gold -= amount
    elif team == 1:
        enemy_gold -= amount
    gold_updated.emit(team, player_gold if team == 0 else enemy_gold)
    return true

func get_gold(team: int) -> int:
    if team == 0:
        return player_gold
    elif team == 1:
        return enemy_gold
    return 0

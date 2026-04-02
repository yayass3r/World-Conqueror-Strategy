extends PanelContainer

const UNIT_DATA = [
    {"type": 0, "name": "Infantry", "cost": 100},
    {"type": 1, "name": "Tank", "cost": 200},
    {"type": 2, "name": "Artillery", "cost": 180},
    {"type": 3, "name": "Aircraft", "cost": 300},
    {"type": 4, "name": "AntiAir", "cost": 160},
    {"type": 5, "name": "Scout", "cost": 120},
]

var _city_pos: Vector2i = Vector2i(-1, -1)

func show_panel(city_pos) -> void:
    if city_pos is Vector2i:
        _city_pos = city_pos
    elif city_pos is Vector2:
        _city_pos = Vector2i(int(city_pos.x), int(city_pos.y))
    visible = true
    _update_buttons()

func hide_panel() -> void:
    visible = false

func _ready() -> void:
    visible = false
    var close_btn = get_node_or_null("VBoxContainer/CloseBtn")
    if close_btn and close_btn is Button:
        close_btn.pressed.connect(hide_panel)
    var list = get_node_or_null("VBoxContainer/UnitList")
    if list and list is VBoxContainer:
        for d in UNIT_DATA:
            var btn = Button.new()
            btn.text = "%s - %d Gold" % [d["name"], d["cost"]]
            btn.custom_minimum_size = Vector2(180, 40)
            btn.pressed.connect(_recruit.bind(d["type"]))
            list.add_child(btn)

func _recruit(unit_type: int) -> void:
    if _city_pos == Vector2i(-1, -1):
        return
    var map = get_tree().current_scene
    if not map:
        return
    var container = map.get_node_or_null("UnitsContainer")
    if not container:
        return
    var rs = get_node_or_null("/root/RecruitmentSystem")
    if rs:
        rs.recruit_unit(unit_type, 0, _city_pos, container)
    UIManager.show_toast("Unit recruited!")
    _update_buttons()

func _update_buttons() -> void:
    var list = get_node_or_null("VBoxContainer/UnitList")
    if not list:
        return
    var idx: int = 0
    for child in list.get_children():
        if child is Button and idx < UNIT_DATA.size():
            var em = get_node_or_null("/root/EconomyManager")
            child.disabled = not (em and em.can_afford(0, UNIT_DATA[idx]["cost"]))
        idx += 1

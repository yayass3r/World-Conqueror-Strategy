extends Node

var hud: Control = null
var unit_info_panel: Control = null
var recruit_panel: Control = null
var turn_banner: Control = null
var mini_map: Control = null

func _ready() -> void:
    await get_tree().create_timer(0.5).timeout
    _discover_ui()

func _discover_ui() -> void:
    var root = get_tree().current_scene
    if root:
        _find_nodes(root)

func _find_nodes(node: Node) -> void:
    for child in node.get_children():
        if child.name == "HUD" and child is Control:
            hud = child
        elif child.name == "UnitInfoPanel" and child is Control:
            unit_info_panel = child
        elif child.name == "RecruitPanel" and child is Control:
            recruit_panel = child
        elif child.name == "TurnBanner" and child is Control:
            turn_banner = child
        elif child.name == "MiniMap" and child is Control:
            mini_map = child
        _find_nodes(child)

func update_hud() -> void:
    if hud and hud.has_method("update_display"):
        hud.update_display()

func show_unit_info(unit) -> void:
    if unit_info_panel and unit_info_panel.has_method("show_info"):
        unit_info_panel.show_info(unit)

func hide_unit_info() -> void:
    if unit_info_panel and unit_info_panel.has_method("hide_info"):
        unit_info_panel.hide_info()

func show_recruit_panel(city_pos) -> void:
    if recruit_panel and recruit_panel.has_method("show_panel"):
        recruit_panel.show_panel(city_pos)

func hide_recruit_panel() -> void:
    if recruit_panel and recruit_panel.has_method("hide_panel"):
        recruit_panel.hide_panel()

func show_turn_banner(text: String, duration: float = 1.5) -> void:
    if turn_banner:
        turn_banner.visible = true
        var label = turn_banner.get_node_or_null("BannerLabel")
        if label and label is Label:
            label.text = text
        await get_tree().create_timer(duration).timeout
        if turn_banner:
            turn_banner.visible = false

func show_toast(message: String, duration: float = 2.0) -> void:
    if hud and hud.has_method("show_toast"):
        hud.show_toast(message, duration)
    else:
        print("[Toast] " + message)

func update_mini_map() -> void:
    if mini_map and mini_map.has_method("update_minimap"):
        mini_map.update_minimap()

func is_recruit_panel_open() -> bool:
    return recruit_panel != null and recruit_panel.visible

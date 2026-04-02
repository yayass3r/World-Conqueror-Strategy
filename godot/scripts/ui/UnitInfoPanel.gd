extends PanelContainer

func show_info(unit) -> void:
    visible = true
    var vbox = get_node_or_null("VBoxContainer")
    if not vbox:
        return
    var names = ["UnitName", "HPLabel", "ATKLabel", "DEFLabel", "MoveLabel", "RangeLabel", "TerrainLabel"]
    if not unit:
        return
    for n in names:
        var lbl = vbox.get_node_or_null(n)
        if lbl and lbl is Label:
            if n == "UnitName":
                lbl.text = str(unit.get("_type_name") if unit.has_method("_type_name") else unit.name)
            elif n == "HPLabel":
                lbl.text = "HP: %d/%d" % [unit.hp, unit.max_hp]
            elif n == "ATKLabel":
                lbl.text = "ATK: %d" % unit.attack_power
            elif n == "DEFLabel":
                lbl.text = "DEF: %d" % unit.defense
            elif n == "MoveLabel":
                lbl.text = "Move: " + ("No" if unit.has_moved else "Yes")
            elif n == "RangeLabel":
                lbl.text = "Range: %d" % unit.attack_range
            elif n == "TerrainLabel":
                lbl.text = "Pos: " + str(unit.grid_position)

func hide_info() -> void:
    visible = false

extends Control

@onready var turn_label: Label = $TopBar/TurnLabel
@onready var gold_label: Label = $TopBar/GoldLabel
@onready var phase_label: Label = $TopBar/PhaseLabel
@onready var end_turn_btn: Button = $BottomBar/EndTurnBtn
@onready var toast_label: Label = $ToastContainer/ToastLabel
@onready var toast_timer: Timer = $ToastContainer/ToastTimer

func _ready() -> void:
    if end_turn_btn:
        end_turn_btn.pressed.connect(TurnManager.end_player_turn)
    if toast_timer:
        toast_timer.timeout.connect(_hide_toast)
    EconomyManager.gold_updated.connect(_on_gold)
    TurnManager.player_turn_started.connect(_on_player_turn)
    TurnManager.enemy_turn_started.connect(_on_enemy_turn)
    TurnManager.turn_ended.connect(_on_turn_end)

func update_display() -> void:
    if turn_label:
        turn_label.text = "Turn %d" % GameManager.current_turn
    if gold_label:
        gold_label.text = "Gold: %d" % EconomyManager.get_gold(0)

func _on_gold(_team: int, _amt: int) -> void:
    update_display()

func _on_player_turn() -> void:
    update_display()
    if phase_label:
        phase_label.text = "Your Turn"
    if end_turn_btn:
        end_turn_btn.disabled = false

func _on_enemy_turn() -> void:
    if phase_label:
        phase_label.text = "Enemy Turn..."
    if end_turn_btn:
        end_turn_btn.disabled = true

func _on_turn_end(turn: int) -> void:
    if turn_label:
        turn_label.text = "Turn %d" % turn

func show_toast(message: String, duration: float = 2.0) -> void:
    if toast_label:
        toast_label.text = message
        toast_label.visible = true
        if toast_timer:
            toast_timer.wait_time = duration
            toast_timer.start()

func _hide_toast() -> void:
    if toast_label:
        toast_label.visible = false

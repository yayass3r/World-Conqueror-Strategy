extends TextureRect

func _ready() -> void:
    custom_minimum_size = Vector2(180, 120)
    stretch_mode = 1

func update_minimap() -> void:
    if not MapGenerator:
        return
    var img = Image.create(MapGenerator.MAP_WIDTH * 10, MapGenerator.MAP_HEIGHT * 10, false, Image.FORMAT_RGBA8)
    img.fill(Color.BLACK)
    var tc = {0: Color(0.3, 0.6, 0.2), 1: Color(0.1, 0.4, 0.1), 2: Color(0.5, 0.4, 0.3), 3: Color(0.8, 0.7, 0.4), 4: Color(0.2, 0.4, 0.8), 5: Color(0.6, 0.6, 0.6)}
    for y in range(MapGenerator.MAP_HEIGHT):
        for x in range(MapGenerator.MAP_WIDTH):
            var tid: int = MapGenerator.get_terrain_at(Vector2i(x, y))
            var c: Color = tc.get(tid, Color.BLACK)
            img.fill_rect(Rect2i(x * 10, y * 10, 10, 10), c)
    if GameManager:
        for u in GameManager.all_units:
            if u.is_alive:
                var uc: Color = Color(0.2, 0.5, 1.0) if u.team == 0 else Color(1.0, 0.2, 0.2)
                img.fill_rect(Rect2i(u.grid_position.x * 10 + 3, u.grid_position.y * 10 + 3, 4, 4), uc)
    var tex = ImageTexture.create_from_image(img)
    texture = tex

func refresh() -> void:
    update_minimap()

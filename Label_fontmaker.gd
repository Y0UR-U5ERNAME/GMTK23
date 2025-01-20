tool
extends Label

func _ready():
	if not Engine.is_editor_hint(): return
	var font = BitmapFont.new()
	var texture = preload("res://font-serif-bold.png")
	var img = texture.get_data()
	img.lock()
	font.add_texture(texture)
	for i in range(32, 32 + 16 * 14):
		var x = i % 16
		# warning-ignore:integer_division
		var y = (i - 32) / 16
		var width = 8
		for j in range(8):
			if img.get_pixel(x*8+j, y * 8) == Color(1.0, 0.0, 1.0, 1.0):
				width = j
				break
		font.add_char(i, 0, Rect2(8 * x, 8 * y, width, 8))
	font.height = 5
	font.ascent = 0
	add_font_override("font", font)

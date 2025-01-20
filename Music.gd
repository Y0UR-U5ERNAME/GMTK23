extends AudioStreamPlayer

export (Resource) var music_off

func _ready():
	play(music_off.off)

func _process(delta):
	music_off.off = get_playback_position()

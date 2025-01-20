extends AnimatedSprite

var restart = false
var tm = null

func _ready():
	playing = true

func _on_DeathEffect_animation_finished():
	queue_free()
	if restart:
		tm.restart()

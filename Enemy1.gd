extends Character

onready var tm = get_parent().get_node("TransitionManager")
onready var sprite = $Sprite
export var flip_h = false

func _ready():
	JUMP_HEIGHT = 200
	sprite.frame = randi() % 2
	sprite.flip_h = flip_h

func _physics_process(delta):
	if tm.transition in [2, 4]:
		sprite.playing = false
		return
	sprite.playing = true
	if not is_controlled:
		if can_move:
			control_char(self, delta)
		else:
			move(delta, Vector2.ZERO)
	if velocity.x: sprite.flip_h = velocity.x < 0
	
	if is_controlled:
		sprite.animation = "player_controlled"
	elif not can_move:
		sprite.animation = "soulless"
	else:
		sprite.animation = "regular"

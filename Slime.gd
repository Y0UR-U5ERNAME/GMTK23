extends Character

onready var tm = get_parent().get_parent().get_node("TransitionManager")
onready var rect = get_parent().get_parent().get_node("TransitionManager/ColorRect")
onready var sprite = $Sprite

func _ready():
	JUMP_HEIGHT = 200
	is_controlled = true
	sprite.frame = randi() % 2
	rect.material["shader_param/pos"] = global_position

func _physics_process(delta):
	if tm.transition in [2, 4]:
		sprite.playing = false
		return
	sprite.playing = true
	if not is_controlled:
		move(delta, Vector2.ZERO)
	if velocity.x: sprite.flip_h = velocity.x < 0

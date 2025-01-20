extends Character

onready var tm = get_parent().get_node("TransitionManager")
onready var sprite = $Sprite
export var direction = Vector2.RIGHT
export var flip_h = false

func _ready():
	JUMP_HEIGHT = 0
	MAX_SPEED = 400
	sprite.frame = randi() % 5
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
		if abs(velocity.x) > 0.01: sprite.animation = "player_controlled"
		else: sprite.animation = "idle"
	elif not can_move:
		sprite.animation = "soulless"
	else:
		sprite.animation = "regular"

func control_char(character, delta):
	character.move(delta, direction)
	for i in character.get_slide_count():
		var coll = character.get_slide_collision(i)
		if coll.normal.y == 0:
			direction = -direction
			break
	
	var orig_pos = character.position
	var orig_mask = character.collision_mask
	character.collision_mask &= ~0b100
	character.move_and_collide(direction * 16)
	if character.move_and_slide(Vector2.DOWN).y:
		direction = -direction
		character.position = orig_pos
		
		character.move_and_collide(direction * 16)
		if character.move_and_slide(Vector2.DOWN).y:
			direction = -direction
	character.collision_mask = orig_mask
	character.position = orig_pos

extends KinematicBody2D
class_name Character

export var MAX_SPEED = 700
export var FRICTION = 50
export var ACCELERATION = 10
export var GRAVITY = 800
export var JUMP_HEIGHT = 500
var velocity = Vector2.ZERO
var grounded = false
onready var is_controlled = false
onready var can_move = true
const DEATH_EFFECT = preload("res://DeathEffect.tscn")
var soul_shape = null

func _ready():
	if name == "Slime":
		soul_shape = null
	else:
		soul_shape = get_parent().get_node("SoulManager/Soul/CollisionShape2D")

func move(delta, input_vector):
	velocity.x = lerp(velocity.x, 0, FRICTION * delta)
	
	velocity.x = lerp(velocity.x, input_vector.x, ACCELERATION * delta)
	velocity.y += GRAVITY * delta
	if grounded and input_vector.y: velocity.y = input_vector.y * JUMP_HEIGHT
	
	velocity.y = move_and_slide(velocity * Vector2(MAX_SPEED, 1), Vector2.UP).y
	grounded = is_on_floor()

	for i in get_slide_count():
		var coll = get_slide_collision(i)
		var collider = coll.collider
		if collider.name == "Slime":
			if coll.normal.y < 0:
				# bounce on slime
				velocity.y = -300
		
				velocity.y = move_and_slide(velocity * Vector2(MAX_SPEED, 1), Vector2.UP).y
				grounded = is_on_floor()
			else:
				# slime dies
				collider.die()
			break
		elif name == "Slime" and (collider.get_class() == "Character" and not (collider.global_position.y < global_position.y - 1)):
			die()
			break
	
	if name != "Slime" and soul_shape:
		var soul_array = get_tree().get_nodes_in_group("SoulShape")
		if not soul_array.size(): soul_shape = null
		if soul_shape: soul_shape.disabled = true
	if test_move(global_transform, Vector2.ZERO):
		if test_move(global_transform, Vector2.UP):
			if test_move(global_transform, Vector2.DOWN):
				die()
	if name != "Slime" and soul_shape: soul_shape.disabled = false

func control_char(character, delta):
	character.move(delta, Vector2.ZERO)

func get_class():
	return "Character"

func _die():
	queue_free()
	var effect = DEATH_EFFECT.instance()
	get_parent().add_child(effect)
	effect.global_position = global_position
	effect.restart = is_controlled or name == "Slime"
	if effect.restart:
		if name == "Slime":
			effect.tm = get_parent().get_parent().get_node("TransitionManager")
		else:
			effect.tm = get_parent().get_node("TransitionManager")

func die():
	if is_controlled or name == "Slime":
		var sm
		if name == "Slime":
			sm = get_parent()
		else:
			sm = get_parent().get_node("SoulManager")
		sm.is_dying = true
		sm.soul.queue_free()
		_die()
	else:
		_die()

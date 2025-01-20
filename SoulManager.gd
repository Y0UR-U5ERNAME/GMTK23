extends Node2D

onready var slime = $Slime
onready var slime_sprite = $Slime/Sprite
onready var controlled : Character = slime
onready var soul = $Soul
onready var aim = $Soul/Aim
onready var sprite = $Soul/Sprite
onready var coll_shape = $Soul/CollisionShape2D
onready var tm = get_parent().get_node("TransitionManager")

const SOUL_SPEED = 500

var shoot_vec = Vector2.ZERO
var pre_controlled = null
var is_dying = false

export var flip_h = false


func _ready():
	aim.visible = false
	sprite.visible = false
	slime.get_node("Sprite").flip_h = flip_h

func _physics_process(delta):
	if tm.transition in [2, 4] or is_dying: return
	
	sprite.visible = controlled == null
	aim.visible = controlled != null
	
	if controlled:
		var input_vector = Vector2.ZERO
		input_vector.x += Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		input_vector.y = -Input.get_action_strength("jump")
		controlled.move(delta, input_vector)
		
		soul.global_position = controlled.global_position
		shoot_vec = (get_global_mouse_position() - aim.global_position).normalized()
		aim.rotation = shoot_vec.angle()
	else:
		var coll = soul.move_and_collide(shoot_vec * SOUL_SPEED * delta)
		if coll:
			var collider = coll.collider
			pre_controlled.can_move = true
			if collider.get_class() != "Character":
				controlled = pre_controlled
				controlled.is_controlled = true
				#soul_die()
				#return
			else:
				var sound = preload("res://SwapSound.tscn").instance()
				add_child(sound)
				controlled = collider
				soul.collision_mask ^= 0b1010
				soul.global_position = controlled.global_position
				coll_shape.disabled = true
				coll_shape.set_deferred("disabled", false)
				controlled.is_controlled = true
	
	if controlled and Input.is_action_just_pressed("shoot"):
		pre_controlled = controlled
		controlled.is_controlled = false
		controlled = null
	if not controlled and pre_controlled != slime:
		pre_controlled.can_move = false
		pre_controlled.control_char(slime, delta)
	if controlled and controlled != slime:
		controlled.control_char(slime, delta)
	
	if controlled == slime:
		slime_sprite.animation = "controlled"
	elif pre_controlled == slime and not controlled:
		slime_sprite.animation = "soulless"
	else:
		slime_sprite.animation = "enemy_controlled"

	if Input.is_action_just_pressed("restart"):
		tm.restart()

func soul_die():
	is_dying = true
	soul.queue_free()
	
	var effect = preload("res://DeathEffect.tscn").instance()
	add_child(effect)
	effect.global_position = soul.global_position
	effect.restart = true
	effect.tm = get_parent().get_node("TransitionManager")

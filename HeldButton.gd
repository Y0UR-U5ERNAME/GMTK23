extends KinematicBody2D

onready var blocker = $Node/Blocker
onready var endpos = $Node/EndPos

const MAX_PRESSED = 3
const PRESS_SPEED = 50
const BLOCKER_SPEED = 50
var y_off = 0
onready var start_pos = position
onready var blocker_start = blocker.position
onready var blocker_target = blocker_start
onready var tm = get_parent().get_node("TransitionManager")

func _ready():
	pass

func _physics_process(delta):
	if tm.transition: return
	var t = test_move(transform, Vector2.UP)
	if t:
		y_off = min(y_off + delta * PRESS_SPEED, MAX_PRESSED)
		blocker_target = endpos.position
	else: 
		y_off = max(y_off - delta * PRESS_SPEED, 0)
		blocker_target = blocker_start
	
	position = start_pos + Vector2.DOWN * y_off 
	
	if blocker_target.distance_to(blocker.position) <= BLOCKER_SPEED * delta:
		blocker.position = blocker_target
	else:
		blocker.position += blocker.position.direction_to(blocker_target) * BLOCKER_SPEED * delta

extends Node2D

onready var rect = $ColorRect
enum {
	NO_TRANSITION
	TRANSITION_IN
	TRANSITION_OUT
	TRANSITION_CIRCLE_IN
	TRANSITION_CIRCLE_OUT
}
var transition
const SPEED = 700
const CIRCLE_SPEED = 500
signal finished
var to_scene = null
onready var curr_scene = get_tree().current_scene.filename

func _ready():
	visible = true
	if curr_scene.substr(6, 5) == "Level":
		transition = TRANSITION_CIRCLE_IN
	else:
		transition = TRANSITION_IN
	rect.material["shader_param/size"] = 0

func _process(delta):
	match transition:
		NO_TRANSITION:
			pass
		TRANSITION_IN:
			if position.y >= 192:
				transition = NO_TRANSITION
				emit_signal("finished")
			position.y += SPEED * delta
		TRANSITION_OUT:
			if position.y >= 0:
				position.y = 0
				transition = NO_TRANSITION
				emit_signal("finished")
				get_tree().change_scene(to_scene)
			position.y += SPEED * delta
		TRANSITION_CIRCLE_IN:
			if rect.material["shader_param/size"] >= Vector2(256, 192).length() + 1:
				transition = NO_TRANSITION
				emit_signal("finished")
			rect.material["shader_param/size"] += CIRCLE_SPEED * delta
		TRANSITION_CIRCLE_OUT:
			if rect.material["shader_param/size"] <= 0:
				transition = NO_TRANSITION
				emit_signal("finished")
				get_tree().change_scene(to_scene)
			rect.material["shader_param/size"] -= CIRCLE_SPEED * delta

func change_scene(scene, t=TRANSITION_OUT):
	if t == TRANSITION_CIRCLE_OUT:
		rect.material["shader_param/size"] = Vector2(256, 192).length() + 1
		position.y = 0
	else:
		position.y = -192
		rect.material["shader_param/size"] = 0
	transition = t
	to_scene = scene

func restart():
	change_scene(curr_scene)

func next_level():
	var sub = curr_scene.substr(0, curr_scene.length()-5) # res://Level1
	var num = int(sub.substr(11)) # 1
	var path = "res://Level" + str(num + 1) + ".tscn"
	if ResourceLoader.exists(path):
		change_scene(path, TRANSITION_CIRCLE_OUT)
	else:
		change_scene("res://LevelsEnd.tscn", TRANSITION_CIRCLE_OUT)

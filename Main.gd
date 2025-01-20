extends Node2D

onready var tm = $TransitionManager
onready var sprite = $Sprite
onready var start_y = sprite.position.y
onready var time = 0
onready var text = $Texts/Text

func _process(delta):
	if not(tm.transition in [2, 4]) and Input.is_action_just_pressed("ui"):
		tm.change_scene("res://Level1.tscn")
	time += delta
	sprite.position.y = sin(time * 2) * 4 + start_y
	
	text.visible = int(time * 3) % 2 == 0

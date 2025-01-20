extends Node2D

onready var tm = $TransitionManager

func _process(delta):
	if tm.transition: return
	if Input.is_action_just_pressed("ui"):
		tm.change_scene("res://Main.tscn")

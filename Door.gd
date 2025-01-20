extends Area2D

onready var slime = get_parent().get_node("SoulManager/Slime")
onready var tm = get_parent().get_node("TransitionManager")
onready var rect = get_parent().get_node("TransitionManager/ColorRect")

func _ready():
	pass

func _on_Door_body_entered(body):
	if body == slime and slime.is_controlled:
		rect.material["shader_param/pos"] = slime.global_position
		tm.next_level()

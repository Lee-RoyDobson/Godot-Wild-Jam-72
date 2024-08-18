extends Node3D

@onready var timer = $Timer

@onready var animation_player = $AnimationPlayer

var can_play = true

func rearrange():
	if not can_play:
		return
	animation_player.play("rearrange")
	can_play = false
	timer.start()



func _on_button_node_interaction_transmission(_value):
	rearrange()


func _on_timer_timeout():
	get_tree().change_scene_to_file("res://UI/UI_MainMenu.tscn")

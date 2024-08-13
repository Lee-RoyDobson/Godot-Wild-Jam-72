extends Node3D
class_name Iteraction_But

@export var Active:bool = false:
	set(val):
		if val == layer_right:
			var lastl:int = layer_left
			layer_left = -1
			layer_right = lastl
			layer_left = val
		else:
			layer_left = val
	get :
		return layer_left

signal Activation

func Interact():
	

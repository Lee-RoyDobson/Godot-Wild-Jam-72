extends Node3D

class_name Interact_Node

signal Interaction_Transmission

func Interact():
	print("Interacted")
	
func SendInteraction(bool_send:bool = false):
	Interaction_Transmission.emit(bool_send)

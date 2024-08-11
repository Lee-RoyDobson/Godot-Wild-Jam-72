extends Camera3D

@export var Camera_speed:= 44.0
var offset:Vector3

func _ready():
	offset = position

func _physics_process(delta: float) -> void:
	var weight = clamp(delta * Camera_speed, 0.0, 1.0)
	
	#global_transform = global_transform.interpolate_with(
		#get_parent().global_transform, weight
	#)
	position = offset #+ Vector3(0.0, 0.55, -0.238)
	#global_position.y += 0.5
	#global_position.x += 0.5

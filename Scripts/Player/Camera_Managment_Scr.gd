extends Node3D

class_name Camera_Management

var Cam:Camera3D
var Cam_Offset:Vector3

var Sub_Contain:SubViewportContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	Cam = $SubViewportContainer/SubViewport/SmoothCamera
	Sub_Contain = $SubViewportContainer
	Cam_Offset = Cam.position
	
	get_viewport().size_changed.connect(ViewportResize)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Cam.global_position = $"..".global_position + Cam_Offset
	Cam.global_rotation_degrees.x = global_rotation_degrees.x
	Cam.global_rotation_degrees.y = global_rotation_degrees.y-180
	
	pass
	
func ViewportResize():
	var NewView:Vector2i = get_viewport().get_window().size
	Sub_Contain.size = Vector2i(NewView.x, NewView.y)
	Sub_Contain.scale = Vector2(1152/NewView.x,648/NewView.y)
	#PreviousSize = Vector2I(NewView.X, NewView.Y);

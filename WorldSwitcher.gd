extends Node

## Only change this if you want a level to start in the dark world
@export var b_is_light: bool = true

# List of light only objects
var light_only_objects = []

# List of dark only objects
var dark_only_objects = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_world") and b_is_light:
		switch_to_dark()
	if Input.is_action_just_pressed("toggle_world") and not b_is_light:
		switch_to_light()

## Methods are called like this to make expanding them to public and other call methods easier later.
func switch_to_light() -> void:
	_switch_world(b_is_light)
	b_is_light = false

func switch_to_dark() -> void:
	_switch_world(b_is_light)	
	b_is_light = true

func _switch_world(b_switch_to_light:bool) -> void:
	pass
	
# Public method to add light only objects to the list
func add_light_object(obj):
	light_only_objects.append(obj)
	print("Object added. Current list: ", light_only_objects)
	
# Public method to add light only objects to the list
func add_dark_object(obj):
	dark_only_objects.append(obj)
	print("Object added. Current list: ", dark_only_objects)

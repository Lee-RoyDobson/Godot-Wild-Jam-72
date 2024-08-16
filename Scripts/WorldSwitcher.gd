extends Node

## Only change this if you want a level to start in the dark world
@export var b_is_light: bool = true

# List of light only objects
var light_only_objects = []

# List of dark only objects
var dark_only_objects = []

#var b_run_once = false;
# Set this after an object is created to ensure the level gets setup
var b_setup_level = false;

## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#	call_deferred("_post_ready")

#Call this just before exiting a level
func clear_objects():
	light_only_objects = []
	dark_only_objects = []

func _setup_level():
	# This code runs only once after the _ready() function
	print("All initial _ready() calls are done.")
	_switch_world(b_is_light)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if b_setup_level:
		_setup_level()
		b_setup_level = false
	if Input.is_action_just_pressed("toggle_world") and b_is_light:
		switch_to_dark()
	elif Input.is_action_just_pressed("toggle_world") and not b_is_light:
		switch_to_light()

## Methods are called like this to make expanding them to public and other call methods easier later.
func switch_to_light() -> void:
	b_is_light = true
	_switch_world(b_is_light)
	

func switch_to_dark() -> void:
	b_is_light = false
	_switch_world(b_is_light)	
	

func _switch_world(b_switch_to_light: bool) -> void:
	# Update light-only objects
	call_deferred("update_objects", light_only_objects, b_switch_to_light)

	# Update dark-only objects (with the opposite of b_switch_to_light)
	call_deferred("update_objects", dark_only_objects, !b_switch_to_light)

	# Output the new world state for debugging
	print("Switched to " + ("light" if b_switch_to_light else "dark") + " world.")
	
func update_objects(objects, is_light_world: bool):
	for obj in objects:
		if obj:  # Check if the object is not null
			obj.visible = is_light_world  # Set visibility based on the mode
			# Set process mode based on the mode
			obj.process_mode = Node.PROCESS_MODE_INHERIT if is_light_world else Node.PROCESS_MODE_DISABLED
	
# Public method to add light only objects to the list
func add_light_object(obj):
	light_only_objects.append(obj)
	print("Object added. Current list: ", light_only_objects)
	b_setup_level = true
	
# Public method to add light only objects to the list
func add_dark_object(obj):
	dark_only_objects.append(obj)
	print("Object added. Current list: ", dark_only_objects)
	b_setup_level = true

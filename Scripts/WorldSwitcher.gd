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

var b_player_controlls_switch = false

## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#	call_deferred("_post_ready")

#Call this just before exiting a level
func clear_objects():
	print("Clearing objects lists")
	light_only_objects = []
	dark_only_objects = []

## Explicitly set the player control
func set_player_control(has_control: bool):
	print("Setting player control: ", has_control)
	b_player_controlls_switch = has_control

## Explicitly disable the player control	
func disable_player_control():
	b_player_controlls_switch = false

## Explicitly enable the player control
func enable_player_control():
	b_player_controlls_switch = true
	
func _setup_level():
	# This code runs only once after the _ready() function
	#print("All initial _ready() calls are done.")
	_switch_world(b_is_light)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_initial_setup()
	_process_inputs()	

## This runs on the frame immediately after an object registers its existence as light/dark
func _initial_setup():
	if b_setup_level:
		_setup_level()
		b_setup_level = false

func _process_inputs():
	if !b_player_controlls_switch: return	#Early exit if player doesnt have control yet
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
	
func toggle_world() -> void:
	if b_is_light:
		switch_to_dark()
	else:
		switch_to_light()
		
func _switch_world(b_switch_to_light: bool) -> void:
	# Update light-only objects
	call_deferred("update_objects", light_only_objects, b_switch_to_light)

	# Update dark-only objects (with the opposite of b_switch_to_light)
	call_deferred("update_objects", dark_only_objects, !b_switch_to_light)

	# Output the new world state for debugging
	print("Switched to " + ("light" if b_switch_to_light else "dark") + " world.")
	
func update_objects(objects, is_light_world: bool):
	print(objects)
	for obj in objects:
		print("toggling, ", obj.name)
		if obj:  # Check if the object is not null
			obj.visible = is_light_world  # Set visibility based on the mode
			# Set process mode based on the mode
			obj.process_mode = Node.PROCESS_MODE_INHERIT if is_light_world else Node.PROCESS_MODE_DISABLED
		else:
			print("Not an object")
	
# Public method to add light only objects to the list
func add_light_object(obj):
	light_only_objects.append(obj)
	print("Object added. Current list: ", light_only_objects.size())
	b_setup_level = true
	
# Public method to add light only objects to the list
func add_dark_object(obj):
	print(" Adding dark object ", obj.name)
	dark_only_objects.append(obj)
	print(dark_only_objects)
	print("Object added. Current list: ", dark_only_objects.size())
	b_setup_level = true

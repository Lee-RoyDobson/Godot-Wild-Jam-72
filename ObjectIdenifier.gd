extends Node

# Define the enum for world options
enum World {Light, Dark}

# Variable to hold a reference to the parent node
var parent_node

# Export the world variable so it shows as a dropdown in the editor
@export var world_type: World = World.Light

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_store_parent()
	_find_world_switcher()

func _store_parent() -> void:
	# Get the parent node and store it
	parent_node = get_parent()
	if parent_node:
		print("Parent node found and stored: ", parent_node.name)
	else:
		print("No parent node found.")
		
func _find_world_switcher() -> void:
	var world_switcher = WorldSwitcher
	print("World Switcher accessed globally: ", world_switcher.name)
	if world_type == World.Light:
		world_switcher.add_light_object(parent_node)
		print("Object added as light object ", parent_node.name)
	elif world_type == World.Dark:
		world_switcher.add_dark_object(parent_node)
		print("Object added as dark object ", parent_node.name)

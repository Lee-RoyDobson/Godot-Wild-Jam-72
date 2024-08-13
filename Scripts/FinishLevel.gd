extends Node3D

@export var next_level = "res://UI/UI_MainMenu.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_3d_body_entered(body: Node3D) -> void:
	print(body.name)
	if body.name != "Duck":
		print("Not a player, ignoring")
		return

	# Clear any object references before moving levels
	var world_switcher = WorldSwitcher

	# Defer the clearing of objects and scene change to avoid physics processing conflicts
	call_deferred("deferred_clear_and_change_scene", world_switcher)

	print("Flag reached")

func deferred_clear_and_change_scene(world_switcher):
	world_switcher.clear_objects()
	get_tree().change_scene_to_file(next_level)

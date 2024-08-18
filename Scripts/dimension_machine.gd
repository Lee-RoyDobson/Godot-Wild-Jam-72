extends Node3D


# When the player enters, switch to the other dimension
func _on_area_3d_body_entered(body):
	# Check if the player entered, if not escape.
	if not body is Player:
		return
	WorldSwitcher.toggle_world()

extends Node3D


# When the player enters, switch to the other dimension
func _on_area_3d_body_entered(body):
	# Check if the player entered, if not escape.
	if not body is Player:
		return
	# Play the sfx for changing dimension
	body.play_dimension_switch()
	if WorldSwitcher.b_is_light:
		WorldSwitcher.switch_to_dark()
	else:
		WorldSwitcher.switch_to_light()

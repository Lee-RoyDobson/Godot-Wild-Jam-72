extends Node

var sound_player: AudioStreamPlayer = null
const LIGHT: AudioStreamMP3 = preload("res://Sounds/Ambient/light.mp3")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sound_player = AudioStreamPlayer.new()
	
	add_child(sound_player)
	play_light()

func play_light() -> void:
	sound_player.stream = LIGHT
	
	sound_player.play(0)

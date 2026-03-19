extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlSignalBus.connect('smiley_caught_player', _handle_smiley_caught_player)


func _handle_smiley_caught_player() :
	# change to jumpscare
	get_tree().change_scene_to_file("res://scenes/level_scenes/jump_scare.tscn")

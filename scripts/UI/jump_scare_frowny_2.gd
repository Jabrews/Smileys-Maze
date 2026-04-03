extends Control

func _on_durr_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/level_scenes/death_screen.tscn")

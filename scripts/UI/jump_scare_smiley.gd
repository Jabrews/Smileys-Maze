extends Control

@onready var durr_timer : Timer = $DuriationTimer

func _ready() -> void:
	print('ready')
	durr_timer.start()


func _on_duriation_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/level_scenes/death_screen.tscn")

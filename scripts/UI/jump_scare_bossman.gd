extends Node

@onready var face_sprite : Sprite2D = $face

func _ready() -> void:
	flash_face_startup()


func _on_durr_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/level_scenes/death_screen.tscn")

func flash_face_startup():
	var tween = create_tween()
	tween.set_loops()
	
	tween.tween_property(face_sprite, "modulate:a", 0.0, 0.05)
	tween.tween_property(face_sprite, "modulate:a", 1.0, 0.05)

extends Button


func _on_button_down() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.9, 0.9), 0.08).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.12).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2.ONE, 0.08).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	get_tree().change_scene_to_file("res://scenes/level_scenes/level.tscn")

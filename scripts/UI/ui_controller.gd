extends Control

@export var stamina_bar: Control
@export var paper_count : Control
@export var blood_lust_coins : Control
@export var minimap_control : Control
@export var minimap_floor_one : Control
@export var fade_to_black_rect : ColorRect



func _ready() -> void:
	GlSignalBus.connect('game_end_fade', _handle_game_end_fade)
	
	fade_to_black_rect.modulate.a = 0.0


func _handle_game_end_fade() :
	var tween = create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	# fade OUT UI elements
	tween.tween_property(stamina_bar, "modulate:a", 0.0, 20.0)
	tween.tween_property(paper_count, "modulate:a", 0.0, 20.0)
	tween.tween_property(blood_lust_coins, "modulate:a", 0.0, 20.0)
	tween.tween_property(minimap_control, "modulate:a", 0.0, 20.0) # ✅ FIX
	tween.tween_property(minimap_floor_one, "modulate:a", 0.0, 20.0) # ✅ FIX
	
	# fade IN black screen
	tween.tween_property(fade_to_black_rect, "modulate:a", 1.0, 20.0)	
	
	await tween.finished	
	get_tree().change_scene_to_file("res://scenes/level_scenes/completion_screen.tscn")
		
	
	
	

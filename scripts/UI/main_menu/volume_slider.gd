extends HSlider

@export var is_music_slider : bool = false
@export var sfx_audio_test : AudioStreamPlayer2D
@export var music_audio_test : AudioStreamPlayer2D



func _ready() -> void:
	await get_tree().process_frame

	if not is_music_slider:
		set_value_no_signal(GlSettings.sfx_slider_value)
		AudioServer.set_bus_volume_db(
			AudioServer.get_bus_index("Master"),
			linear_to_db(GlSettings.sfx_slider_value)
		)
	else:
		set_value_no_signal(GlSettings.music_slider_value)
		AudioServer.set_bus_volume_db(
			AudioServer.get_bus_index("Music"),
			linear_to_db(GlSettings.music_slider_value)
		)

func _on_value_changed(new_value: float) -> void:
	if not is_music_slider:
		
		sfx_audio_test.play()		
		
		GlSettings.sfx_slider_value = new_value
		AudioServer.set_bus_volume_db(
			AudioServer.get_bus_index("Master"),
			linear_to_db(new_value)
		)
	else:
		
		music_audio_test.play()
		
		GlSettings.music_slider_value = new_value
		AudioServer.set_bus_volume_db(
			AudioServer.get_bus_index("Music"),
			linear_to_db(new_value)
		)

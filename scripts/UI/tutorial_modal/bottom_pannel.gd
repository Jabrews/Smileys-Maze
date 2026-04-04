extends Control


@onready var slider : TextureRect = $Slider

func _on_slider_mouse_entered() -> void:
	slider.material.set_shader_parameter("hover_strength", 1.0)

func _on_slider_mouse_exited() -> void:
	slider.material.set_shader_parameter("hover_strength", 0.0)

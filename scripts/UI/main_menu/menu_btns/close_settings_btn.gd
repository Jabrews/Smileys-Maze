extends Button

@onready var settings : Control = $".."

func _ready() -> void:
	pivot_offset = size /  2

func _on_button_down() -> void:
	
	GlSignalBus.emit_signal('btn_pressed')
	
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.9, 0.9), 0.08).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.12).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2.ONE, 0.08).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	
	
	await tween.finished
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	settings.visible = false 
	GlSignalBus.emit_signal('exit_settings_btn_dwn')
	


func _on_mouse_entered() -> void:
	scale = Vector2(1.1, 1.1)
	
	GlSignalBus.emit_signal('btn_hovered')


func _on_mouse_exited() -> void:
	scale = Vector2(1,1)

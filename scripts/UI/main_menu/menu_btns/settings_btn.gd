extends Button

@onready var settings : Control = $"../Settings"

func _ready() -> void:
	pivot_offset = size /  2

func _on_button_down() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.9, 0.9), 0.08).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.12).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2.ONE, 0.08).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	
	await tween.finished
	
	GlSignalBus.emit_signal('pause_btn_down')
	
	settings.visible = true
	


func _on_mouse_entered() -> void:
	scale = Vector2(1.1, 1.1)
	GlSignalBus.emit_signal('btn_hovered')


func _on_mouse_exited() -> void:
	scale = Vector2(1,1)

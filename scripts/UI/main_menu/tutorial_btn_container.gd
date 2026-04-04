extends Control

var hover_tween : Tween

@onready var tutorial_modal : Control = $"../TutorialModal"

var btn_hovered : bool = false

func _ready() -> void:
	var movement_tween = create_tween()
	movement_tween.set_loops()
	movement_tween.tween_property(self, "position:y", position.y + 1, 0.5)
	movement_tween.tween_property(self, "position:y", position.y - 1, 0.5)

func _process(delta: float) -> void: 
	if Input.is_action_just_pressed('select') :
		if btn_hovered :
			_on_button_down()			


func _on_mouse_entered() -> void:
	
	GlSignalBus.emit_signal('btn_hovered')
	
	if hover_tween:
		hover_tween.kill()
	
	hover_tween = create_tween()
	hover_tween.set_trans(Tween.TRANS_SINE)
	hover_tween.set_ease(Tween.EASE_OUT)
	
	# scale up slightly
	hover_tween.parallel().tween_property(self, "scale", Vector2(1.1, 1.1), 0.2)
	
	# slight tilt (degrees → radians)
	hover_tween.parallel().tween_property(self, "rotation", deg_to_rad(3), 0.2)
	
	btn_hovered = true


func _on_mouse_exited() -> void:
	if hover_tween:
		hover_tween.kill()
	
	hover_tween = create_tween()
	hover_tween.set_trans(Tween.TRANS_SINE)
	hover_tween.set_ease(Tween.EASE_OUT)
	
	# return to normal
	hover_tween.parallel().tween_property(self, "scale", Vector2(1, 1), 0.2)
	hover_tween.parallel().tween_property(self, "rotation", 0.0, 0.2)
	
	btn_hovered = false 
	

func _on_button_down() -> void:
		
	GlSignalBus.emit_signal('btn_pressed')
	
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.9, 0.9), 0.08).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.12).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2.ONE, 0.08).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	
	await tween.finished 	
	tutorial_modal.visible = true
	
	


extends Sprite2D

@onready var mat := material as ShaderMaterial
@export var finale_chase_number : Label

var reveal_active := false
var reveal_progress := 0.0
var reveal_speed := 0.4

func start_reveal():
	reveal_active = true
	reveal_progress = 0.0
	mat.set_shader_parameter("progress", reveal_progress)
	
func _ready() -> void:
	await finale_chase_number.loader_complete
	start_reveal()
	

func _process(delta):
	if reveal_active:
		reveal_progress += delta * reveal_speed
		reveal_progress = min(reveal_progress, 1.0)
		mat.set_shader_parameter("progress", reveal_progress)

		if reveal_progress >= 1.0:
			reveal_active = false

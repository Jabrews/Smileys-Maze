extends Sprite2D


var tween : Tween


func _ready() -> void:
	tween = create_tween()
	tween.set_loops()
	tween.tween_property(self, 'position:y', position.y + 2, 3.0)
	tween.tween_property(self, 'position:y', position.y - 2, 3.0)

		

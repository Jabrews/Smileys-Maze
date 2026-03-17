extends Control 

@onready var curr_papers_label : Label = $Label

func _ready() -> void:
	GlLightingManager.connect('paper_collected', _handle_paper_collected)
	
	size_tween()
	color_tween()


func _handle_paper_collected () :
	curr_papers_label.text = str(GlLightingManager.totalPapersCollected)

	# flash modulate white breifly and scale
	size_tween()
	color_tween()


func size_tween() :
	var tween : Tween = create_tween()
	tween.tween_property(self, 'scale:x', 1.1, 0.5)
	tween.tween_property(self, 'scale:x', 1.0, 0.5)
	tween.tween_property(self, 'scale:x', 1.1, 0.5)
	tween.tween_property(self, 'scale:x', 1.0, 0.2)
	

func color_tween() :
	var tween : Tween = create_tween()
	var curr_modulate = self.modulate
	
	tween.tween_property(self, 'modulate', Color.WHITE, 0.5)
	tween.tween_property(self, 'modulate', Color.BLACK, 0.2)
	tween.tween_property(self, 'modulate', Color.WHITE, 0.5)
	tween.tween_property(self, 'modulate', curr_modulate, 0.5)

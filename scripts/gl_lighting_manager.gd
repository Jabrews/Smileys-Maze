extends Node

# for handling dimming of lights

## signals
signal paper_collected

var totalPapersCollected : int = 5

func _ready() -> void:
	connect('paper_collected', _handle_paper_collected)	
	
	# for resetting level
	GlSignalBus.connect('smiley_caught_player', _handle_smiley_caught_player)
	
	
func _handle_paper_collected() :
	totalPapersCollected += 1
	
func _handle_smiley_caught_player() :
	totalPapersCollected = 0

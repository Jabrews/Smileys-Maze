extends Control 

@onready var curr_papers_label : Label = $Label
@onready var curr_papers_label_two : Label = $Label3
@onready var sprite_bg : Sprite2D = $background

var floor_one_clear : bool = false
var floor_two_clear : bool = false
var floor_three_clear : bool = false

var all_papers_collected_tween : Tween 
var player_last_floor : int = 1
var curr_modulate 



func _ready() -> void:
	GlLightingManager.connect('paper_collected', _handle_paper_collected)
	GlSignalBus.connect('all_papers_collected', _handle_all_papers_collected)
	
	# when changing floor
	GlSignalBus.connect('player_changed_floor', _handle_player_changed_floor)		
	# when clearing floor	
	GlSignalBus.connect('floor_cleared', _handle_floor_cleared)
	curr_modulate = self.modulate
	
	
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
	
	tween.tween_property(self, 'modulate', Color.BLACK, 0.2)
	tween.tween_property(self, 'modulate', Color.WHITE, 0.5)
	tween.tween_property(self, 'modulate', curr_modulate, 0.5)

func _handle_all_papers_collected() :
	visible = false	
	
	
func _handle_floor_cleared(cleared_floor_num : int) :
	match cleared_floor_num :
		1 : 
			floor_one_clear = true
		2 :
			floor_two_clear = true
		3 : 
			floor_three_clear = true
	toggle_no_paper_styling(true)
		
func _handle_player_changed_floor(player_new_floor : int):

	var should_show_empty := false

	if player_new_floor == 1 and floor_one_clear:
		should_show_empty = true
	elif player_new_floor == 2 and floor_two_clear:
		should_show_empty = true
	elif player_new_floor == 3 and floor_three_clear:
		should_show_empty = true

	toggle_no_paper_styling(should_show_empty)
		
func toggle_no_paper_styling(toggleValue : bool):

	if toggleValue:
		# kill any existing tween FIRST
		if all_papers_collected_tween:
			all_papers_collected_tween.kill()

		curr_papers_label.modulate.a = 0.5
		sprite_bg.modulate.a = 0.5
		curr_papers_label_two.modulate.a = 0.5

		all_papers_collected_tween = create_tween()
		all_papers_collected_tween.set_loops()


		all_papers_collected_tween.tween_property(self, "modulate", Color.BLACK, 0.2)
		all_papers_collected_tween.tween_property(self, "modulate", Color.WHITE, 0.5)
		all_papers_collected_tween.tween_property(self, "modulate", curr_modulate, 0.5)

	else:
		if all_papers_collected_tween:
			all_papers_collected_tween.kill()
			all_papers_collected_tween = null

		
		# fade label
		curr_papers_label.modulate.a = 1.0
		sprite_bg.modulate.a = 1.0
		curr_papers_label_two.modulate.a = 1.0
		modulate = curr_modulate
	

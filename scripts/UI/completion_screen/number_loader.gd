extends Label 

signal loader_complete

@export var chosen_num = '0'
@export var total_random_tries : int = 5

var curr_try : int = 0

# componnets
@onready var change_interval_timer : Timer = $ChangeInterval
@onready var dud_sound : AudioStreamPlayer2D = $"../../DudSound"
@onready var real_sound : AudioStreamPlayer2D = $"../../RealSound"


func _ready() -> void: 
	change_interval_timer.timeout.connect(_handle_timeout)

func roll_number():
	curr_try = 0
	change_interval_timer.start()

func _handle_timeout():
	curr_try += 1
	
	#  color styling
	switch_color()

	if curr_try < total_random_tries:
		var random_num = randi_range(0, 100)
		text = str(random_num)
		dud_sound.play()

	else:
		text = str(chosen_num)
		real_sound.play()
		change_interval_timer.stop()
		emit_signal("loader_complete")
	
	
func switch_color() :
	
	if curr_try == total_random_tries :
		var color = Color.WHITE		
		add_theme_color_override("font_color", color)
	else : 
		var color = Color.from_hsv(randf(), 0.4, 1.0)
		add_theme_color_override("font_color", color)

extends Control 

# components
@onready var bell_ring_sound : AudioStreamPlayer2D = $BellRing
@onready var whoosh_sound : AudioStreamPlayer2D = $Whoosh
@onready var timer_increment : Timer = $TimerIncrement
@onready var label : Label = $Label2

# pos vars
var time : int = 130
var finale_position : Vector2 = Vector2(260, 29) # 290
var finale_scale : Vector2 = Vector2(1,1)
var starting_position : Vector2 = Vector2(160, 120)
var starting_scale : Vector2 = Vector2(5,5)

var up_and_down_tween : Tween
var left_and_right_tween : Tween
var flash_tween : Tween


func _ready() -> void:
	GlSignalBus.connect('all_papers_collected', _handle_start_countdown)
	GlSignalBus.connect('stop_end_time_ticking', _handle_timer_stop)


func _handle_start_countdown() :
	timer_increment.start()
	
	var inital_scale = starting_scale - Vector2(1,1)
	scale = inital_scale
	
	visible = true
	bell_ring_sound.play()
	
	var inital_scale_tween = create_tween()
	inital_scale_tween.tween_property(self, 'scale', starting_scale, 0.5)	
	
	await inital_scale_tween.finished
	
	var shrink_scale_tween = create_tween()	
	shrink_scale_tween.tween_property(self, 'scale', finale_scale, 0.5)
	
	whoosh_sound.play()
	
	var position_tween = create_tween()	
	position_tween.tween_property(self, 'position', finale_position, 1.5)


func _on_timer_increment_timeout() -> void:
	time -= 1
	label.text = str(time)	
	
	handle_timer_styling()
	
	if time == 0:
		timer_increment.stop()


func handle_timer_styling() :

	# 🔴 30–10 range flashing
	if time <= 30 and time > 10:
		flash_text_red()

	# 🔴 10 and below = permanent red
	if time <= 10:
		label.add_theme_color_override("font_color", Color.RED)
		
	if time <= 0 :
		GlSignalBus.emit_signal('smiley_caught_player')
		

	match time :

		128:
			kill_tweens()

			var base_y = finale_position.y
			var base_x = finale_position.x

			up_and_down_tween = create_tween()
			up_and_down_tween.set_loops()
			
			up_and_down_tween.tween_property(self, "position:y", base_y + 1.0, 0.25)
			up_and_down_tween.tween_property(self, "position:y", base_y - 1.0, 0.25)
			up_and_down_tween.tween_property(self, "position:y", base_y, 0.25)

			left_and_right_tween = create_tween()
			left_and_right_tween.set_loops()
			
			left_and_right_tween.tween_property(self, "position:x", base_x + 0.3, 0.25)
			left_and_right_tween.tween_property(self, "position:x", base_x - 0.3, 0.25)
			left_and_right_tween.tween_property(self, "position:x", base_x, 0.25)


		90:
			kill_tweens()

			var base_y = finale_position.y
			var base_x = finale_position.x

			up_and_down_tween = create_tween()
			up_and_down_tween.set_loops()
			
			up_and_down_tween.tween_property(self, "position:y", base_y + 1.5, 0.2)
			up_and_down_tween.tween_property(self, "position:y", base_y - 1.5, 0.2)
			up_and_down_tween.tween_property(self, "position:y", base_y, 0.2)

			left_and_right_tween = create_tween()
			left_and_right_tween.set_loops()
			
			left_and_right_tween.tween_property(self, "position:x", base_x + 0.6, 0.2)
			left_and_right_tween.tween_property(self, "position:x", base_x - 0.6, 0.2)
			left_and_right_tween.tween_property(self, "position:x", base_x, 0.2)


		60:
			kill_tweens()

			var base_y = finale_position.y
			var base_x = finale_position.x

			text_shake_start()

			up_and_down_tween = create_tween()
			up_and_down_tween.set_loops()
			
			up_and_down_tween.tween_property(self, "position:y", base_y + 2.5, 0.25)
			up_and_down_tween.tween_property(self, "position:y", base_y - 2.5, 0.25)
			up_and_down_tween.tween_property(self, "position:y", base_y, 0.25)

			left_and_right_tween = create_tween()
			left_and_right_tween.set_loops()
			
			left_and_right_tween.tween_property(self, "position:x", base_x + 1.5, 0.25)
			left_and_right_tween.tween_property(self, "position:x", base_x - 1.5, 0.25)
			left_and_right_tween.tween_property(self, "position:x", base_x, 0.25)


func flash_text_red():
	if flash_tween:
		flash_tween.kill()

	flash_tween = create_tween()
	
	label.add_theme_color_override("font_color", Color.RED)
	
	flash_tween.tween_method(
		func(val): label.add_theme_color_override("font_color", val),
		Color.RED,
		Color.WHITE,
		0.5
	)


func text_shake_start():
	var text_shake_tween = create_tween()	
	text_shake_tween.set_loops()	
	
	var base_pos = label.position.y
	
	text_shake_tween.tween_property(label, "position:y", base_pos + 0.5, 0.2)
	text_shake_tween.tween_property(label, "position:y", base_pos - 0.5, 0.2)
	text_shake_tween.tween_property(label, "position:y", base_pos, 0.2)


func kill_tweens():
	if up_and_down_tween:
		up_and_down_tween.kill()
	if left_and_right_tween:
		left_and_right_tween.kill()

func _handle_timer_stop() :
	whoosh_sound.play()
	timer_increment.stop()
	kill_tweens()
	visible = false

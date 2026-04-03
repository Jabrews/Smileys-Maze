extends Node

# components
@onready var run_increment_down_timer : Timer = $RunIncrementDown
@onready var run_increment_up_timer : Timer = $RunIncrementUp
@onready var texture_progress_bar : TextureProgressBar = $TextureProgressBar

# vars
var run_value = 15 #default
# for shaking
var progress_bar_org_pos 
var shake_time := 0.0
var shake_strength := 1.0  # very small
var shake_speed := 40.

func _ready() -> void:
	progress_bar_org_pos = texture_progress_bar.position
	GlSignalBus.connect('player_started_running', _handle_player_started_running)
	GlSignalBus.connect('player_stopped_running', _handle_player_stopped_running)
	
	# stop stamina being effect when chase start
	GlSignalBus.connect('smiley_chase_intro_scene_start', _handle_intro_start)
	GlSignalBus.connect('smiley_chase_intro_scene_end', _handle_intro_end)

func _process(delta: float) -> void:
	
	## handle shake if run_val low
	if run_value < 5 && run_value != 0 && run_increment_up_timer.is_stopped():
		
		shake_time += delta * shake_speed
		
		var offset_x = sin(shake_time) * shake_strength
		var offset_y = cos(shake_time * 1.3) * shake_strength
		
		texture_progress_bar.position = progress_bar_org_pos + Vector2(offset_x, offset_y)
	else:
		texture_progress_bar.position = progress_bar_org_pos 


## sig. handlers
func _handle_player_started_running() :
	run_increment_down_timer.start()
	run_increment_up_timer.stop()
	

func _handle_player_stopped_running() :
	run_increment_down_timer.stop()
	run_increment_up_timer.start()
###

## timer handlers
func _on_run_increment_down_timeout() -> void:
	# still run
	if run_value > 0:
		run_value -= 1
		texture_progress_bar.value -= 1
	# stop run
	elif run_value == 0:
		GlSignalBus.emit_signal('stamina_bar_depleted_status', true)

func _on_run_increment_up_timeout() -> void:
	if run_value > 0 :
		GlSignalBus.emit_signal('stamina_bar_depleted_status', false)
	
	if run_value <= 15 :
		run_value += 1		
		# change bar sprite
		texture_progress_bar.value += 1
###

func _handle_intro_start(_smiley_floor_num : int) :
	run_increment_down_timer.stop()
	
func _handle_intro_end() :
	run_increment_down_timer.start()

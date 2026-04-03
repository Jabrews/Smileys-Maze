extends Node

# components
@onready var player : CharacterBody3D = $".."

var walk_active : bool = false
var run_active : bool = false


func _process(_delta: float) -> void:
	
	var move_input = Input.get_vector("left", "right", "up", "down")
	var is_moving = move_input.length() > 0
	var is_running = Input.is_action_pressed("run")

	# STOP everything if not moving
	if !is_moving:
		if walk_active:
			GlSoundManager.emit_signal("player_stopped_walking")
		if run_active:
			GlSoundManager.emit_signal("player_stopped_running")
			
		walk_active = false
		run_active = false
		return

	# RUN state
	if is_running:
		if !run_active:
			GlSoundManager.emit_signal("player_running")
			GlSoundManager.emit_signal("player_stopped_walking")
		
		run_active = true
		walk_active = false

	# WALK state
	else:
		if !walk_active:
			GlSoundManager.emit_signal("player_walked")
			GlSoundManager.emit_signal("player_stopped_running")
		
		walk_active = true
		run_active = false
	
	
	
	

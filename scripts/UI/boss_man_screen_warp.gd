extends ColorRect


var bossman_refrence : CharacterBody3D

# components
@onready var player : CharacterBody3D = $"../../../Player"
@onready var distance_timer : Timer = $DistanceIntervalTimer

func _ready() -> void:
	# start / end
	GlSignalBus.connect('bossman_intro_start', _handle_bossman_encounter_start)
	GlSignalBus.connect('bossman_killed', _handle_bossman_killed)
	
	# distance timer
	distance_timer.connect('timeout', _handle_distance_timeout)

func _handle_bossman_encounter_start(bossman_charcter: CharacterBody3D) :
	bossman_refrence = bossman_charcter
	# start timer
	distance_timer.start()
	# set visibiltiy
	visible = true 
	
func _handle_bossman_killed() :
	bossman_refrence = null
	#stop timer
	distance_timer.stop()
	# reset cam
	reset_camera_to_default()
	# set visibiltiy
	visible = false
	
func _handle_distance_timeout():
	if not bossman_refrence :
		return	
	
	var dist_sq = bossman_refrence.global_position.distance_squared_to(player.global_position)
	
	if GlSignalBus.bossman_floor_num != GlSignalBus.player_floor_num :
		reset_camera_to_default()
			

	if dist_sq < 40: 
		material.set_shader_parameter("layer_count", 3)
		material.set_shader_parameter("wave_strength", 0.01) 
		material.set_shader_parameter("wave_speed", 4.0) 
		material.set_shader_parameter("tint_strength", 0.07) 
		material.set_shader_parameter("opacity", 0.40)

	elif dist_sq < 300: 
		material.set_shader_parameter("layer_count", 2)
		material.set_shader_parameter("wave_strength", 0.01) 
		material.set_shader_parameter("wave_speed", 3.0) 
		material.set_shader_parameter("tint_strength", 0.05) 
		material.set_shader_parameter("opacity", 0.35)
		
	elif dist_sq < 2000: 
		material.set_shader_parameter("layer_count", 1)
		material.set_shader_parameter("wave_strength", 0.01) 
		material.set_shader_parameter("wave_speed", 3.0) 
		material.set_shader_parameter("tint_strength", 0.05) 
		material.set_shader_parameter("opacity", 0.40)
		
	elif dist_sq < 4000: 
		material.set_shader_parameter("layer_count", 1)
		material.set_shader_parameter("wave_strength", 0.01) 
		material.set_shader_parameter("wave_speed", 2.0) 
		material.set_shader_parameter("tint_strength", 0.05) 
		material.set_shader_parameter("opacity", 0.20)
		
	else :
		material.set_shader_parameter("layer_count", 0)
		material.set_shader_parameter("opacity", 0)
		
func reset_camera_to_default() :
	material.set_shader_parameter("layer_count", 1)
	material.set_shader_parameter("wave_strength", 0.01) 
	material.set_shader_parameter("wave_speed", 2.0) 
	material.set_shader_parameter("tint_strength", 0.05) 
	material.set_shader_parameter("opacity", 0.20)
	
	
	
	
	
	

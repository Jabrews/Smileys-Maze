extends CharacterBody3D

var player : CharacterBody3D
@onready var nav_agent : NavigationAgent3D = $NavigationAgent3D
@onready var body : Node3D = $Body

@onready var spawn_wait_timer : Timer = $spawn_delay_timer
@onready var minimap_update_timer : Timer = $MiniMapUpdate
@onready var bossman_sound_controller : Node = $SoundController
@onready var spawning_particle_controller : Node3D = $SpawningSpriteController
@onready var stuck_detect_timer : Timer = $StuckDetect
@onready var player_detect_area : Area3D = $PlayerDetectArea

var being_looked_at : bool = false
var spawn_loop : bool = false
var last_position : Vector3 = Vector3.ZERO
var prevent_movement : bool = false





func _ready() -> void:
	
	await get_tree().process_frame
	GlSignalBus.connect('player_looking_at_bossman', _handle_player_looking_at_bossman)
	
	spawn_wait_timer.connect('timeout', _handle_spawn_timeout)
	minimap_update_timer.connect('timeout', _handle_mini_map_icon_update_timeout)
	
	# for pausing movement when smiley chase
	GlSignalBus.connect('smiley_chase_intro_scene_start', _handle_intro_start)
	GlSignalBus.connect('smiley_chase_intro_scene_end', _handle_intro_end)
	

	spawn_bossman()
	
#########
## spawning logic
#########

func spawn_bossman() :
	spawn_loop = true
	#this will end spawn loop
	spawn_wait_timer.start()
	
	GlSignalBus.emit_signal('map_icon_object_init','BOSSMAN', global_position, name)
	
	# play particle. slowly increase opacoty to 100
	look_at_player()
	fade_in_character()
	spawning_particle_controller.play_particles()

func fade_in_character():
	var tween = create_tween()
	
	# get ALL MeshInstance3D nodes in the hierarchy
	var meshes = find_children("*", "MeshInstance3D")
	
	for mesh in meshes:
		var surface_count = mesh.get_surface_override_material_count()
		
		for i in range(surface_count):
			var mat = mesh.get_active_material(i)
			
			if mat:
				# make unique
				mat = mat.duplicate()
				mesh.set_surface_override_material(i, mat)
				
				# enable transparency
				mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
				
				# start invisible
				mat.albedo_color.a = 0.0
#				
				# tween to visible
				tween.parallel().tween_property(mat, "albedo_color:a", 1.0, 6.0)
				

func _handle_spawn_timeout() :
	GlSignalBus.emit_signal('bossman_intro_start', self)
	minimap_update_timer.start()
	spawn_loop = false
	spawning_particle_controller.stop_particles()
	bossman_sound_controller._handle_play_look_hum(false)
	player_detect_area.monitoring = true
	
func _handle_mini_map_icon_update_timeout() :
	GlSignalBus.emit_signal('icon_moved', name, 'BOSSMAN', global_position)

#########
## movement logic
#########

func _process(delta: float) -> void:
	# gravity stays separate
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
	else:
		velocity.y = 0
		
		
	if being_looked_at :
		stuck_detect_timer.stop()
		velocity = Vector3.ZERO
	
	if prevent_movement :
		stuck_detect_timer.stop()
		velocity = Vector3.ZERO
		 
		

	if not being_looked_at and not spawn_loop and not prevent_movement:
		
		detect_stuck(position)					
		
		var safe_target = NavigationServer3D.map_get_closest_point(
			nav_agent.get_navigation_map(),
			player.global_position
		)

		nav_agent.set_target_position(safe_target)

		var dest = nav_agent.get_next_path_position()
		var direction = (dest - global_position).normalized()

		# rotate
		var look_pos = dest
		look_pos.y = global_position.y
		if not global_position.is_equal_approx(look_pos):
			look_at(look_pos, Vector3.UP)

		velocity.x = direction.x * 15
		velocity.z = direction.z * 15
		
		last_position = position

	move_and_slide()

func look_at_player() :

	var dest = player.global_position

	# rotate
	var look_pos = dest
	look_pos.y = global_position.y
	if not global_position.is_equal_approx(look_pos):
		look_at(look_pos, Vector3.UP)
	
#########
## pausing
##########
	
func _handle_player_looking_at_bossman(toggleValue : bool) :
	being_looked_at = toggleValue	

#########
## detect pausing
########

func detect_stuck(new_position : Vector3) :
	if being_looked_at :
		stuck_detect_timer.stop()
	else :
		if new_position == last_position:
			# only if not detecting idle already
			if stuck_detect_timer.is_stopped() :
				stuck_detect_timer.start()

func _on_stuck_detect_timeout() -> void:
	GlSignalBus.emit_signal('respawn_bossman')
	
func _handle_intro_start(_floor_num : int) :
	prevent_movement = true

func _handle_intro_end() :
	prevent_movement = false
	
	

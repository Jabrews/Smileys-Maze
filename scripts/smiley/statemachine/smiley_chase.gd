extends Node

# components
@onready var smiley : CharacterBody3D = $"../.."
@export var player : CharacterBody3D 
@onready var nav_agent : NavigationAgent3D = $"../../NavigationAgent3D"
@onready var animation_player : AnimationPlayer = $"../../AnimationPlayer"

# points
var chase_points = 100 
var default_chase_speed = 5.5
var chase_speed = 5.5

var intro_movement_lock : bool 

# door
var can_open_door : bool = false
var reachable_door_pos : Vector3

func _ready() -> void:
	GlSignalBus.connect('smiley_update_points', update_chase_points)
	#light controller emits this when finished with lights flashing
	GlSignalBus.connect('smiley_chase_intro_scene_end', _on_chase_intro_scene_end)
	# for door openig
	GlSignalBus.connect('toggle_smiley_in_door_radius', _handle_in_door_radius)
	# for increasing sprint 
	GlLightingManager.connect('paper_collected', _handle_paper_collected)


func state_start() -> void:
	GlSignalBus.emit_signal('toggle_prevent_ambient_sound', true)
	
	chase_speed = default_chase_speed
	
	# look at player
	smiley.look_at(player.global_position)

	# wait untill scene ends for chase to start
	animation_player.play('ChaseStart')
	GlSignalBus.emit_signal('smiley_chase_intro_scene_start', smiley.floor_num)
	intro_movement_lock = true
	
	chase_points = 100
	
	
func _on_chase_intro_scene_end() :
	intro_movement_lock = false
	
# main movement
func state_process(_delta) :
	# wait untill lock to start
	if intro_movement_lock != true:
		
		# chase anim
		if not animation_player.is_playing() :
			animation_player.play('ChaseRun')
		
		# 1. snap target to navmesh
		var safe_target = NavigationServer3D.map_get_closest_point(
			nav_agent.get_navigation_map(),
			player.global_position
		)

		# 2. give that to agent
		nav_agent.set_target_position(safe_target)
		
		# 3. get NEXT path point (NOT the full target)
		var dest = nav_agent.get_next_path_position()

		# 4. move toward that
		var local_dest = dest - smiley.global_position
		var direction = local_dest.normalized()
		
		## smiley direction
		var look_pos = dest
		look_pos.y = smiley.global_position.y
		if not smiley.global_position.is_equal_approx(look_pos):
			smiley.look_at(look_pos, Vector3.UP)
		
		smiley.velocity.x = direction.x * chase_speed 
		smiley.velocity.z = direction.z * chase_speed 
		
		## DETECT DOOR LOOP CALL
		detect_door()
		
		smiley.move_and_slide()
	
		

		
func update_chase_points(new_points: int) -> void:
	chase_points += new_points

	if chase_points <= 100:
		chase_speed = default_chase_speed + 1
	elif chase_points <= 200:
		chase_speed = default_chase_speed + 2
	elif chase_points <= 300:
		chase_speed = default_chase_speed + 3
	
	if chase_points <= 0 : get_parent().switch_state(get_parent().State.IDLE)


func state_end() :
		# reset chase spped
		chase_points = 100
		GlSignalBus.emit_signal('smiley_chase_end')		
		intro_movement_lock = true
		animation_player.stop()
		can_open_door = false
		reachable_door_pos = Vector3.ZERO

# can be toggled on/off
func _handle_in_door_radius(toggleValue: bool, door_pos: Vector3, smiley_name):
	if smiley_name == smiley.name :
		can_open_door = toggleValue
		reachable_door_pos = door_pos # note 'off' = Vector3.ZERO

func detect_door() :  #note : called in process
	if can_open_door and reachable_door_pos != Vector3.ZERO:
		
		var dir_to_door = (reachable_door_pos - smiley.global_position).normalized()
		var smiley_forward = -smiley.global_transform.basis.z
		
		# dot product tells how aligned the directions are
		var alignment = dir_to_door.dot(smiley_forward)
		
		# SWITCH TO DOOR STATE
		if alignment > 0.2:
			GlSignalBus.emit_signal(
				"smiley_open_door",
				reachable_door_pos,
			)
		
func _handle_paper_collected() :
	print('paper colleted')
	default_chase_speed = default_chase_speed + 0.1
	#in case in chase
	chase_speed = chase_speed + 0.1
		
		

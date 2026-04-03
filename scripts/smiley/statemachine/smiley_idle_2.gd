extends Node

# components
@export var smiley_move_manager : Node
@onready var nav_agent : NavigationAgent3D = $"../../NavigationAgent3D"
@onready var smiley : CharacterBody3D = $"../.."
@export var player : CharacterBody3D
@onready var animation_player : AnimationPlayer = $"../../AnimationPlayer"

# move nodes / dice roll
var curr_target : Vector3 
@onready var force_move_timer : Timer = $"../../ForceMoveTimer"

# for updating smiley if stuick
var last_pos : Vector3
var force_unstuck_loop : bool = false

# switch to door state
var can_open_door : bool = false
var reachable_door_pos = Vector3.ZERO

func _ready() -> void:
	nav_agent.connect('navigation_finished', _handle_nav_finished)
	GlSignalBus.connect('toggle_smiley_in_door_radius', _handle_in_door_radius)
	GlSignalBus.connect('smiley_chase_intro_scene_start', _handle_chase_start)

func state_start() :
	GlSignalBus.emit_signal('toggle_prevent_ambient_sound', false)
	animation_player.speed_scale = 0.5
	
func state_process(_delta) -> void :
	
	if last_pos == smiley.position :
		if not force_unstuck_loop :
			force_move_timer.start()
			force_unstuck_loop = true

	if last_pos != smiley.position :
		force_move_timer.stop()
		force_unstuck_loop = false
				
	
	last_pos = smiley.position
	
	if not animation_player.is_playing() :
		animation_player.play('Walk')
	
	# get new target node pos
	if curr_target == Vector3.ZERO:
		curr_target = move_node_dice_roll()
		smiley.velocity = Vector3.ZERO

	if curr_target != Vector3.ZERO:

		var nav_map = nav_agent.get_navigation_map()

		var agent_pos = NavigationServer3D.map_get_closest_point(nav_map, smiley.global_position)
		var safe_target = NavigationServer3D.map_get_closest_point(nav_map, curr_target)

		# critical: ensure both points are actually on navmesh
		if agent_pos.distance_to(smiley.global_position) > 1.0:
			return 

		if safe_target.distance_to(curr_target) > 2.0:
			return 

		nav_agent.set_target_position(safe_target)
	
		# get dest
		var dest = nav_agent.get_next_path_position()
		var direction = dest - smiley.global_position
		direction.y = 0

		if direction.length() > 0.05:
			direction = direction.normalized()

		# handle where smiley is rotated
		var look_pos = dest
		look_pos.y = smiley.global_position.y
		if not smiley.global_position.is_equal_approx(look_pos):
			smiley.look_at(look_pos, Vector3.UP)

		# moving smiley
		smiley.velocity.x = direction.x * get_parent().speed
		smiley.velocity.z = direction.z * get_parent().speed
	#else:
		#smiley.velocity.x = 0.0
		#smiley.velocity.z = 0.0
		
		## DETECT DOOR LOOP CALL
		detect_door()
		
		
		smiley.move_and_slide()
	
	
func state_end() :
	#curr_target = null
	can_open_door = false
	reachable_door_pos = Vector3.ZERO
	
# runs after reaching move node
func _handle_nav_finished() :
	curr_target = Vector3.ZERO
	smiley.velocity = Vector3.ZERO
	nav_agent.set_target_position(Vector3.ZERO)
	
# use paper, player pos to decide wherist to go
func move_node_dice_roll() -> Vector3:
	var movement_node = smiley_move_manager.dice_roll_for_pos(smiley.floor_num)

	if movement_node is Vector3:
		return movement_node
	
	if movement_node is Node3D:
		return movement_node.global_position

	return Vector3.ZERO

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
			
			var path = nav_agent.get_current_navigation_path()

			var next_path_pos : Vector3

			if path.size() > 2:
				next_path_pos = path[2]

			#elif path.size() > 3:
				#next_path_pos = path[3]

			else:
				next_path_pos = nav_agent.get_next_path_position()

			GlSignalBus.emit_signal(

				"smiley_door_state_info",
				reachable_door_pos,
				next_path_pos
			)
			# switch state
			force_move_timer.stop()
			force_unstuck_loop = false
			get_parent().switch_state(get_parent().State.DOOROPEN)


func _on_force_move_timer_timeout() -> void:
	var offset_right := smiley.global_transform.basis.x * 2
	var offset_back := smiley.global_transform.basis.z * 2

	var new_pos := smiley.global_position + offset_right + offset_back

	# keep same height
	new_pos.y = smiley.global_position.y
	
	smiley.global_position = new_pos

# player in look radius


# for reset once chase starts
func _handle_chase_start(_floor_num : int) :
	smiley.velocity = Vector3.ZERO
	

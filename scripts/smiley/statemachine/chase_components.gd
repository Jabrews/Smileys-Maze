extends Node3D

@export var smiley_state_machine : Node

@onready var raycast : RayCast3D = $RayCast
@onready var cone_vision_area : Area3D = $ConeVision
@onready var player_exit_delay_timer : Timer = $PlayerExitDelayTimer
@onready var chase_point_increment_timer : Timer = $ChasePointIncrementTimer
@onready var proximity_point_increment_timer : Timer = $ProximityPointIncrementTimer
@onready var chase_point_decrement_timer : Timer = $ChasePointDecrement

## collision shapes for area exspansion with paper collected
@onready var coll_shape_foward : CollisionShape3D = $ConeVision/CollisionShapeFoward
@onready var coll_shape_backward : CollisionShape3D = $ConeVision/CollisionShapeBack

var player : CharacterBody3D = null
var player_in_cone_vision := false
var player_in_proximity := false

var double_decrement : bool = false
var target_player_floor_num : int

enum State {
	IDLE,
	DOOROPEN,
	CHASE
}

func _ready() -> void:
	GlSignalBus.connect('smiley_chase_end', _handle_chase_end)
	# for decreasing points more if player on diff floor than smiley
	GlSignalBus.connect('player_changed_floor', _handle_player_changed_floor)
	GlSignalBus.connect('smiley_change_floor', _handle_smiley_change_floor)
	# increase detect player area lengths with each note
	GlLightingManager.connect('paper_collected', _handle_player_collected_paper)

func _process(delta: float) -> void:
	if not player:
		return

	# PRIORITY: proximity overrides cone
	if player_in_proximity:
		_handle_detection("proximity")
	elif player_in_cone_vision:
		_handle_detection("cone")


# ========================
# DETECTION CORE
# ========================
func _handle_detection(type: String):

	chase_point_decrement_timer.stop()

	raycast.look_at(player.global_position)
	raycast.force_raycast_update()

	if not raycast.is_colliding():
		return

	if raycast.get_collider() != player:
		return

	# switch to chase if idle
	if smiley_state_machine.curr_state == smiley_state_machine.idle_state:
		smiley_state_machine.switch_state(State.CHASE)

	# only run logic in chase
	if smiley_state_machine.curr_state != smiley_state_machine.chase_state:
		return



	if type == "cone":
		if chase_point_increment_timer.is_stopped():
			chase_point_increment_timer.start()

	elif type == "proximity":
		if proximity_point_increment_timer.is_stopped():
			proximity_point_increment_timer.start()


# ========================
# ENTER EVENTS
# ========================
func _on_cone_vision_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = body
		player_in_cone_vision = true


func _on_proximity_vision_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = body
		player_in_proximity = true


# ========================
# EXIT EVENTS
# ========================
func _on_cone_vision_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_cone_vision = false

		# only start exit delay if NOT in proximity
		if not player_in_proximity:
			if player_exit_delay_timer :
				player_exit_delay_timer.start()


func _on_proximity_vision_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_proximity = false
		proximity_point_increment_timer.stop()

		# fallback to cone OR decay
		if player_in_cone_vision:
			return
		else:
			chase_point_decrement_timer.start()


func _on_player_exit_delay_timer_timeout() -> void:
	# fully lost player
	if not player_in_proximity and not player_in_cone_vision:
		player = null
		chase_point_increment_timer.stop()
		proximity_point_increment_timer.stop()
		chase_point_decrement_timer.start()


# ========================
# POINT SYSTEM
# ========================
func _on_chase_point_increment_timer_timeout() -> void:
	GlSignalBus.emit_signal("smiley_update_points", 10)


func _on_proximity_point_increment_timer_timeout() -> void:
	GlSignalBus.emit_signal("smiley_update_points", 10)


func _on_chase_point_decrement_timeout() -> void:
	
	if double_decrement :
		GlSignalBus.emit_signal("smiley_update_points", -25)
	if not double_decrement :
		GlSignalBus.emit_signal("smiley_update_points", -10)

# ========================
# RESET
# ========================
func _handle_chase_end() -> void:
	player = null
	player_in_cone_vision = false
	player_in_proximity = false

	chase_point_increment_timer.stop()
	proximity_point_increment_timer.stop()
	chase_point_decrement_timer.stop()

func _handle_player_changed_floor(floor_num : int):
	# if smiley floor num != player floor num
	if get_parent().floor_num != floor_num : 
		print('double decrement true')
		target_player_floor_num = floor_num
		double_decrement = true
	
func _handle_smiley_change_floor(floor_num : int) :
	if floor_num == target_player_floor_num :
		double_decrement = false
		print('double decrement false')
	if floor_num != target_player_floor_num :
		double_decrement = true
		print('double decrement true')

func _handle_player_collected_paper() -> void:
	var pts_f = coll_shape_foward.shape.points
	pts_f[0].z += 2
	coll_shape_foward.shape.points = pts_f

	var pts_b = coll_shape_backward.shape.points
	pts_b[0].z += 2
	coll_shape_backward.shape.points = pts_b

	raycast.target_position.z += 2
	
	
	
	

extends Node

# components
@onready var animation_player : AnimationPlayer = $"../../AnimationPlayer"
@onready var smiley : CharacterBody3D = $"../.."
@onready var walk_timer : Timer = $WalkTimer

@export var walk_time := 1
var walk_process_loop : bool = false

# data passed from idle state
var door_pos : Vector3
var target_pos : Vector3


# receive door info
func _ready() -> void:
	GlSignalBus.connect("smiley_door_state_info", _handle_smiley_door_state_info)
	walk_timer.wait_time = walk_time
	walk_timer.timeout.connect(_handle_walk_finished)
	
func _handle_smiley_door_state_info(move_door_pos : Vector3, move_target_pos : Vector3):
	door_pos = move_door_pos
	target_pos = move_target_pos

# state entry
func state_start():
	animation_player.speed_scale = 0.2
	await handle_open_state()
	start_walk()


# OPEN DOOR
func handle_open_state():
	use_animation_player("door_open")
	await animation_player.animation_finished
	GlSignalBus.emit_signal("smiley_open_door", door_pos)


# WALK FORWARD
func start_walk():
	use_animation_player("door_open_walk")
	walk_process_loop = true
	walk_timer.start()
	


func _physics_process(_delta):

	if walk_process_loop :
		handle_walk_state()


func handle_walk_state():

	var direction = target_pos - smiley.global_position
	direction.y = 0

	var distance = direction.length()

	# stop if close enough
	if distance < 0.2:
		smiley.velocity = Vector3.ZERO
		return

	direction = direction.normalized()

	# rotate toward target
	var look_pos = target_pos
	look_pos.y = smiley.global_position.y
	smiley.look_at(look_pos, Vector3.UP)

	# movement
	var speed = get_parent().speed * 0.5
	smiley.velocity.x = direction.x * speed
	smiley.velocity.z = direction.z  * speed

	smiley.move_and_slide()

# WALK END
func _handle_walk_finished():
	smiley.velocity = Vector3.ZERO
	walk_process_loop = false
	handle_stand_state()


# STAND
func handle_stand_state():
	use_animation_player("door_open_stand")
	await animation_player.animation_finished
	# switch state
	get_parent().switch_state(get_parent().State.IDLE)
	


# ANIMATION HELPER
func use_animation_player(anim : String):

	animation_player.stop()

	match anim:
		"door_open":
			animation_player.play("OpenDoor")

		"door_open_walk":
			animation_player.play("OpenDoorWalk")

		"door_open_stand":
			animation_player.play("OpenDoorEnd")


# STATE EXIT
func state_exit():

	animation_player.speed_scale = 0.5
	animation_player.stop()
	smiley.velocity = Vector3.ZERO

	door_pos = Vector3.ZERO
	target_pos = Vector3.ZERO

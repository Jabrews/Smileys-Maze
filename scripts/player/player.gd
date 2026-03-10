extends CharacterBody3D

## export vars
@export var mouse_sensitivity_x := 0.007
@export var mouse_sensitivity_y := 0.002

## BOB 
const BOB_AMP = 0.08
const BOB_FREQ = 2.0
var t_bob = 0.0

## components
@onready var camera_pivot : Node3D = $CameraPivot
@onready var camera := $CameraPivot/Camera3D
@onready var spot_light := $CameraPivot/FlashLightPivot/SpotLight3D

var speed := 5.0
var can_run : bool = true

enum MoveState { IDLE, WALK, RUN }
var current_state := MoveState.IDLE


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	GlSignalBus.connect("stamina_bar_depleted_status", _handle_stamina_bar_depleted_status)
	
	await get_tree().process_frame
	GlSignalBus.emit_signal('map_icon_object_init','PLAYER', global_position, name)


func _physics_process(delta: float) -> void:
	
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	##### dir #####
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (camera_pivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	## movement
	if direction.length() > 0.0:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	
	## -------- MOVEMENT SOUND STATE MACHINE --------
	var moving := direction.length() > 0.0
	var new_state := MoveState.IDLE
	
	if moving:
		if speed == 10 and can_run:
			new_state = MoveState.RUN
		else:
			new_state = MoveState.WALK
	
	if new_state != current_state:
		
		# stop previous state
		match current_state:
			MoveState.WALK:
				sound_emit_signals("stopped_walking")
			MoveState.RUN:
				sound_emit_signals("stopped_running")
		
		# start new state
		match new_state:
			MoveState.WALK:
				sound_emit_signals("started_walking")
			MoveState.RUN:
				sound_emit_signals("started_running")
		
		current_state = new_state
	## ------------------------------------------------
	
	
	## dealing with flashlights ###
	## other 
	handle_run()
	camera_bobble(delta)

	move_and_slide()


### BOBBLE + CAMERA ###
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		camera_pivot.rotate_y(-event.relative.x * mouse_sensitivity_x)
		camera.rotate_x(-event.relative.y * mouse_sensitivity_y)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))


func camera_bobble(delta):
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	return pos
########################


### Sprint Signal ###
func handle_run():
	
	# start run
	if Input.is_action_just_pressed("run"):
		if can_run:
			GlSignalBus.emit_signal("player_started_running")
			speed = 10
	
	# stop run
	if Input.is_action_just_released("run"):
		GlSignalBus.emit_signal("player_stopped_running")
		speed = 5


func _handle_stamina_bar_depleted_status(toggleValue : bool):
	can_run = !toggleValue
	
	if not can_run:
		GlSignalBus.emit_signal("player_stopped_running")
		speed = 5


#########################

func sound_emit_signals(type):
	if type == "started_running":
		GlSoundManager.emit_signal("player_running")
	if type == "started_walking":
		GlSoundManager.emit_signal("player_walked")
	if type == "stopped_running":
		GlSoundManager.emit_signal("player_stopped_running")
	if type == "stopped_walking":
		GlSoundManager.emit_signal("player_stopped_walking")


## For updating mini map icon
func _on_mini_map_update_timer_timeout() -> void:
	# for mini map
	GlSignalBus.emit_signal('icon_moved', name, 'PLAYER', global_position)

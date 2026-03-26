extends Node

# components
@export var floor_display_controller : Node
@export var elevator_cam_shake : Node #
@export var door_controller : Node
@export var front_elevator_buttons : StaticBody3D

# areas we delete
@export var close_door_area : Area3D
@export var exit_scene_start_area : Area3D

# sounds
@export var elevator_moving_sound : AudioStreamPlayer3D
@export var elevator_arrived_sound : AudioStreamPlayer3D

var player_in_open_radius  = false
var button_just_pressed = false

func _ready() -> void:
	# called after increment finished
	GlSignalBus.connect('elevator_arrived', _handle_elevator_arrived)
	
	# called after paper collected
	GlLightingManager.connect('paper_collected', _check_for_all_papers_collected)
	
	opening_scene()
	
# for open door loop
func _process(_delta: float) -> void:
	if player_in_open_radius :
		if not button_just_pressed :
			if Input.is_action_just_pressed('interact') :
				start_end_scene()
				button_just_pressed = true


func opening_scene() :
	elevator_moving_sound.play()
	floor_display_controller.increment_floor_up()
	elevator_cam_shake.up_camera_shake(true)


func _handle_elevator_arrived() :
	elevator_moving_sound.stop()
	elevator_arrived_sound.play()
	door_controller.open_door()
	elevator_cam_shake.end_shake()
	


# auto close door after intro scene
func _on_close_door_area_body_entered(body: Node3D) -> void:
	if body.is_in_group('player') :
		close_door_area.queue_free()
		door_controller.close_door()
		elevator_moving_sound.play()
		floor_display_controller.increment_floor_down()
	
	
func _check_for_all_papers_collected() :
	var papers_collected = GlLightingManager.totalPapersCollected
	if papers_collected == 6 :
		front_elevator_buttons.buttons_available()
		exit_scene_start_area.monitoring = true
		GlSignalBus.emit_signal('all_papers_collected')
		
# for when detecting body of player after button_avaible()
func _on_open_area_body_entered(body: Node3D) -> void:
	if body.is_in_group('player') : 
		player_in_open_radius = true
	
func _on_close_door_area_body_exited(body: Node3D) -> void:
	if body.is_in_group('player') : 
		player_in_open_radius = false

func start_end_scene() :
	front_elevator_buttons.button_pressed()
	GlSignalBus.emit_signal('stop_end_time_ticking')
	elevator_moving_sound.play()	
	floor_display_controller.increment_floor_up()
	
	

# exit scene in elevator
func _on_exit_scene_area_body_entered(body: Node3D) -> void:
	if body.is_in_group('player') :
		GlSignalBus.emit_signal('game_end_fade')
		elevator_moving_sound.stop()	
		await door_controller.wait_for_door_idle()
		door_controller.close_door()
		exit_scene_start_area.queue_free()
		await door_controller.wait_for_door_idle()
		elevator_moving_sound.play()	
		floor_display_controller.increment_floor_down()
		elevator_cam_shake.down_camera_shake(true)

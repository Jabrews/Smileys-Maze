extends Node3D

## components
@onready var door_delay_timer := $DoorOpenDelay
@onready var door_coll_delay := $DoorCollDelay
@onready var door_smiley_auto_close := $AutoSmileyCloseDoorTimer
@onready var door_static_body := $DoorPivot/DoorStaticBody
@onready var door_pivot := $DoorPivot
@onready var door_coll_shape := $DoorPivot/DoorStaticBody/CollShape
@onready var door_mesh := $DoorMesh

## sounds
@onready var s_door_open : AudioStreamPlayer3D = $DoorOpen
@onready var s_door_close : AudioStreamPlayer3D = $DoorClose

var playerInRadius : bool = false
var doorDelay : bool = false
var doorSpriteOpen : bool = false

var closed_rotation : Vector3
var open_rotation : Vector3

func _ready() -> void:
	closed_rotation = door_pivot.rotation
	open_rotation = closed_rotation + Vector3(0, deg_to_rad(90), 0)
	GlSignalBus.connect('smiley_open_door', _handle_smiley_open_door)


func _process(_delta: float) -> void:
	if doorDelay:
		return
	
	if playerInRadius and Input.is_action_just_pressed("interact"):
	
		if doorSpriteOpen:
			close_door()
		else:
			open_door()
		
		doorSpriteOpen = !doorSpriteOpen
		doorDelay = true
		door_delay_timer.start()

	
	
func open_door():
	
	s_door_open.play()
	
	door_coll_delay.start()
	door_coll_shape.disabled = true
	
	GlSoundManager.emit_signal("door_opened")
	
	var tween = create_tween()

	tween.tween_property(door_pivot, "rotation:y", open_rotation.y, 0.4)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
	
	tween.parallel().tween_property(door_mesh, "rotation:y", open_rotation.y, 0.4)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
		


func close_door():
	
	s_door_close.play()
	door_static_body.set_collision_layer_value(2, true)
	
	var tween = create_tween()
	

	tween.tween_property(door_pivot, "rotation:y", closed_rotation.y, 0.4)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN)
	
	tween.tween_property(door_mesh, "rotation:y", closed_rotation.y, 0.4)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN)
	

func _on_door_open_delay_timeout() -> void:
	doorDelay = false

func _on_open_door_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		playerInRadius = true
	if body.is_in_group('smiley') :
		if !doorSpriteOpen :
			GlSignalBus.emit_signal('toggle_smiley_in_door_radius', true, global_position, body.name)
		

func _on_open_door_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		playerInRadius = false
	if body.is_in_group('smiley') :
		if !doorSpriteOpen :
			GlSignalBus.emit_signal('toggle_smiley_in_door_radius', false, Vector3.ZERO, body.name)
	

func _handle_smiley_open_door(door_pos : Vector3) :
	
	if global_position != door_pos :
		return
	# if already open
	if doorSpriteOpen :
		return
		
		
	door_static_body.set_collision_layer_value(2, false)
	open_door()
	doorSpriteOpen = !doorSpriteOpen
	doorDelay = true
	door_delay_timer.start()
	door_smiley_auto_close.start()
	


func _on_door_coll_delay_timeout() -> void:
	door_coll_shape.disabled = false


func _on_auto_smiley_close_door_timer_timeout() -> void:
	door_static_body.set_collision_layer_value(2, true)
	if doorSpriteOpen :
		close_door()
		doorSpriteOpen = false

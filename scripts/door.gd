extends Node3D

## components
@onready var door_delay_timer := $DoorOpenDelay
@onready var door_pivot := $DoorPivot
@onready var door_mesh := $DoorMesh

var playerInRadius : bool = false
var doorDelay : bool = false
var doorSpriteOpen : bool = false

var closed_rotation : Vector3
var open_rotation : Vector3

func _ready() -> void:
	closed_rotation = door_pivot.rotation
	open_rotation = closed_rotation + Vector3(0, deg_to_rad(90), 0)

func _process(delta: float) -> void:
	if doorDelay:
		return
	
	if playerInRadius and Input.is_action_just_pressed("interact"):
	
		if doorSpriteOpen:
			GlSoundManager.emit_signal("door_closed")
			close_door()
		else:
			GlSoundManager.emit_signal("door_opened")
			open_door()
		
		doorSpriteOpen = !doorSpriteOpen
		doorDelay = true
		door_delay_timer.start()

	
	
func open_door():
	
	
	var tween = create_tween()

	tween.tween_property(door_pivot, "rotation:y", open_rotation.y, 0.4)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
	
	tween.parallel().tween_property(door_mesh, "rotation:y", open_rotation.y, 0.4)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
		


func close_door():
	
	
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
		GlSignalBus.emit_signal('toggle_smiley_in_door_radius', true)
		

func _on_open_door_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		playerInRadius = false
	if body.is_in_group('smiley') :
		GlSignalBus.emit_signal('toggle_smiley_in_door_radius', false)
	

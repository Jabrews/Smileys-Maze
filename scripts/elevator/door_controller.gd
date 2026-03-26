extends Node

@onready var door_left : MeshInstance3D = $DoorLeft
@onready var door_right : MeshInstance3D = $DoorRight
@export var max_opening_position : float = 3.0
@export var opening_transform_increment : float = 2.0

# sounds
@export var open_sound : AudioStreamPlayer3D
@export var close_sound : AudioStreamPlayer3D

var door_movement_loop = false

func open_door() :
	var left_tween = create_tween()	
	var right_tween = create_tween()
	
	door_movement_loop = true
	
	open_sound.play()
	
	left_tween.tween_property(door_left, 'position:x', door_left.position.x + opening_transform_increment, max_opening_position)
	right_tween.tween_property(door_right, 'position:x', door_right.position.x + -opening_transform_increment, max_opening_position)
	
	await left_tween.finished
	door_movement_loop = false

func close_door() :
	var left_tween = create_tween()	
	var right_tween = create_tween()
	
	close_sound.play()
	
	door_movement_loop = true
	
	left_tween.tween_property(door_left, 'position:x', door_left.position.x + -opening_transform_increment, max_opening_position)
	right_tween.tween_property(door_right, 'position:x', door_right.position.x + opening_transform_increment, max_opening_position)
	await left_tween.finished
	door_movement_loop = false
	
func wait_for_door_idle() -> void:
	while door_movement_loop:
		await get_tree().process_frame
	
	
	

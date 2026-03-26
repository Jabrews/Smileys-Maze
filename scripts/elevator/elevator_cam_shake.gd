extends Node

@export var camera_pivot : Node3D 
@export var camera_vertical_force : float = 2.0
var org_camera_pivot_pos : Vector3

var shake_tween : Tween


func _ready() -> void:
	org_camera_pivot_pos = camera_pivot.position
	

# up
func up_camera_shake(active: bool) : 
	if not active:
		return
	
	# init horz. shake
	left_right_shake(active)
	
	var up_jolt_tween = create_tween()
	up_jolt_tween.tween_property(
		camera_pivot,
		"position:y",
		camera_pivot.position.y + camera_vertical_force * 0.8,
		0.3
	)
	
	await up_jolt_tween.finished
	
	var return_tween = create_tween()
	return_tween.tween_property(
		camera_pivot,
		"position:y",
		org_camera_pivot_pos.y,
		0.3
	)
	
	await return_tween.finished
	
	var up_tween = create_tween()
	up_tween.tween_property(
		camera_pivot,
		"position:y",
		camera_pivot.position.y + camera_vertical_force,
		15.0
	)
	
	await up_tween.finished
	
	end_shake()


# down
func down_camera_shake(active : bool) :
	if not active:
		return
	
	# init horz. shake
	left_right_shake(true)
	
	var up_tween = create_tween()
	up_tween.tween_property(
		camera_pivot,
		"position:y",
		camera_pivot.position.y + camera_vertical_force,
		15.0
	)
	
	await up_tween.finished
	end_shake()


func left_right_shake(active : bool) : 
	if active :
		# kill old tween so no stacking
		if shake_tween:
			shake_tween.kill()
		
		shake_tween = create_tween()
		shake_tween.set_loops()
		
		var left_random = randf_range(-0.2, -0.05)
		var right_random = randf_range(0.05, 0.2)
		
		shake_tween.tween_property(camera_pivot, "position:x", org_camera_pivot_pos.x + left_random, 0.7)	
		shake_tween.tween_property(camera_pivot, "position:x", org_camera_pivot_pos.x + right_random, 0.7)	
	else:
		# stop shake
		if shake_tween:
			shake_tween.kill()


func end_shake() :
	left_right_shake(false)
	camera_pivot.position = lerp(camera_pivot.position, org_camera_pivot_pos, camera_vertical_force * 0.01)


func _on_delay_timeout() -> void:
	up_camera_shake(true)

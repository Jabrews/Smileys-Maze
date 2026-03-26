extends Node

@export var camera_pivot : Node3D 
@export var xray_body : StaticBody3D

func _ready() -> void:
	GlSignalBus.connect('all_papers_collected', look_at_xray_temp)


func look_at_xray_temp():
	var original_basis = camera_pivot.global_transform.basis
	var duration := 1.0
	var speed := 6.0
	
	var time_passed := 0.0
	
	# look at target smoothly for 1 second
	while time_passed < duration:
		var delta = get_process_delta_time()
		time_passed += delta
		
		var current_transform = camera_pivot.global_transform
		
		var forward = -current_transform.basis.z.normalized()
		var target_dir = (xray_body.global_position - current_transform.origin).normalized()
		
		
		var dot = clamp(forward.dot(target_dir), -1.0, 1.0)
		var angle = acos(dot)
		
		if angle > 0.001:
			var axis = forward.cross(target_dir).normalized()
			var rot = Basis(axis, angle * speed * delta)
			
			var new_basis = rot * current_transform.basis
			camera_pivot.global_transform.basis = new_basis
		
		await get_tree().process_frame
	
	# return smoothly
	var tween = create_tween()
	tween.tween_method(
		func(basis):
			var t = camera_pivot.global_transform
			t.basis = basis
			camera_pivot.global_transform = t,
		camera_pivot.global_transform.basis,
		original_basis,
		0.5
	)

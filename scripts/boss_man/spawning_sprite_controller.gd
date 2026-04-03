extends Node3D

@onready var particles: Array[Node3D] = [$"1", $"2", $"3", $"4"]

@export var radius := 2.0
@export var speed := 2.0

@export var float_amount := 0.2
@export var float_speed := 0.5

var angle := 0.0
var center := Vector3.ZERO

var tweens: Array = []


func _ready() -> void:
	await get_tree().process_frame
	
	center = global_position


func _process(delta):
	angle += speed * delta
	
	var count = particles.size()
	
	for i in range(count):
		var sprite = particles[i]
		
		# spread evenly in circle
		var offset_angle = angle + (i * TAU / count)
		
		var x = cos(offset_angle) * radius
		var z = sin(offset_angle) * radius
		
		sprite.global_position.x = center.x + x
		sprite.global_position.z = center.z + z

func play_particles():
	stop_particles()
	
	for sprite in particles:
		sprite.visible = true
		
		var start_y = sprite.position.y
		
		var tween = create_tween()
		tween.set_loops()
		tween.set_trans(Tween.TRANS_SINE)
		tween.set_ease(Tween.EASE_IN_OUT)
		
		tween.tween_property(sprite, "position:y", start_y + float_amount, float_speed)
		tween.tween_property(sprite, "position:y", start_y - float_amount, float_speed)
		
		tweens.append(tween)


func stop_particles():
	for sprite in particles:
		sprite.visible = false
	
	for tween in tweens:
		if tween:
			tween.kill()
	
	tweens.clear()

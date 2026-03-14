extends Area3D

## components
@onready var animated_sprite : AnimatedSprite3D = $Sprite3D
@onready var omni_light : OmniLight3D = $OmniLight3D
@onready var flame_particle : GPUParticles3D = $FlameParticle

@onready var sound_fire_start : AudioStreamPlayer3D = $FireStart
@onready var sound_fire_crackle : AudioStreamPlayer3D = $FireCrackle
@onready var sound_crumple : AudioStreamPlayer3D = $Crumple
@onready var sound_theme : AudioStreamPlayer3D = $theme


@export var is_dud : bool = false


var ROTATE_SPEED = 5.0


func _ready() -> void:
	scale = Vector3(0.4, 0.4, 0.4)
	
	await get_tree().process_frame
	GlSignalBus.emit_signal("map_icon_object_init", 'PAPER', global_position, name)


func _process(delta: float) -> void:
	rotate_y(ROTATE_SPEED * delta)


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group('player') :
		
		GlSignalBus.emit_signal('map_icon_delete', name, global_position)
		
		# disable collision
		set_deferred("monitoring", false)
		
		if not is_dud :
			
			# sounds
			sound_theme.stop()
			sound_crumple.play()
			
			# signal calls		
			GlLightingManager.emit_signal("paper_collected")
			# visuals
			animated_sprite.play("collected")	
			handle_succses_motion()
		if is_dud :
			
			handle_dud_motion()
			
			# sounds
			sound_theme.stop()
			sound_fire_start.play()

			await sound_fire_start.finished

			sound_fire_crackle.play()
			
		
func handle_succses_motion():

	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUINT)
	
	# up
	var up_tween = tween.tween_property(self, "position:y", position.y + 3.0, 0.6)

	# wait
	tween.tween_interval(0.1)

	# color
	up_tween.finished.connect(func():
		omni_light.light_color = Color.RED
	)
	
	# down
	var down_tween = tween.tween_property(self, "position:y", position.y - 4.0, 0.9)
	
	down_tween.finished.connect(func():
		GlSignalBus.emit_signal('delete_paper_coords', name)
		self.queue_free()
	)
	
## DUD MOTION
func handle_dud_motion() :
	ROTATE_SPEED = ROTATE_SPEED * 2	
	flame_particle.emitting = true
	omni_light.omni_attenuation = lerp(-1, 5, 0.5)
	var tween = create_tween()
	var up_tween = tween.tween_property(self, 'position:y', position.y + 15, 3)
	up_tween.finished.connect(func():
		GlSignalBus.emit_signal('delete_paper_coords', name)
		self.queue_free()
	)
	

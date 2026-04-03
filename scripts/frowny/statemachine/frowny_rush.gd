extends Node

# components
@onready var frowny : CharacterBody3D = $"../.."
@onready var state_machine : Node = $".."
@onready var animation_player : AnimationPlayer = $"../../AnimationPlayer2"
@onready var speed_timer : Timer = $"../../SpeedTimer"
@onready var death_particle : GPUParticles3D = $"../../DeathParticle"
@onready var armature : Node3D = $"../../Armature"

# death mask scene
@onready var death_mask_scene : PackedScene = preload("res://scenes/frowny_mask.tscn")

# sounds
@onready var rush_alert_sound : AudioStreamPlayer3D = $"../../RushAlertStart"
@onready var exsplode_sound : AudioStreamPlayer3D = $"../../Exsplode"


var player_target_position : Vector3
var speed : int = 10
var locked_dir : Vector3
var death_loop : bool = false


func state_start() :
	
	player_target_position = state_machine.player_target_position 
	animation_player.play("Rush")
	rush_alert_sound.play()
	
	# start speed
	speed_timer.start()
	
	
func run_towards_player():
	if locked_dir == Vector3.ZERO:
		locked_dir = (player_target_position - frowny.global_position).normalized()

	frowny.velocity.x = locked_dir.x * speed
	frowny.velocity.z = locked_dir.z * speed
	
	frowny.move_and_slide()

func handle_look_rotation()  :
	
	# dont flip back after passing target pos
	if locked_dir == Vector3.ZERO:
		return
	
	var look_pos = frowny.global_position + locked_dir
	look_pos.y = frowny.global_position.y
	
	frowny.look_at(look_pos, Vector3.UP)
	
func state_process(_delta) :
	run_towards_player()
	handle_look_rotation()
	
	if frowny.is_on_wall() :
		handle_hit_wall()
		death_loop = true


func handle_hit_wall():
	
	if death_loop :
		return
		
	exsplode_sound.play()
	
	# armature	
	armature.visible = false
	
	# mask
	var death_mask = death_mask_scene.instantiate()
	get_tree().current_scene.add_child(death_mask)
	death_mask.global_position = frowny.global_position
	death_mask.global_position.y += 2.0
	
	# particle	
	death_particle.restart()
	death_particle.emitting = true
	await get_tree().create_timer(death_particle.lifetime).timeout
	
	# frowny spawn manager	
	GlSignalBus.emit_signal('frowny_deleted')
	
	## KILL FROWNY
	frowny.queue_free()
	
	

func state_end() :
	speed_timer.stop()

func _on_speed_timer_timeout() -> void:
	speed += 5

	
	

extends Sprite2D 

@onready var paper_collect_particle : CPUParticles2D = $PaperCollectParticle

@export_enum("VENT-UP", "VENT-DOWN", "PAPER", "PLAYER", "ELEVATOR")
var icon_type : String

@export var reveal_radius : float = 20.0

# elevator icon
var flash_tween : Tween

# only for smiley
var icon_sound_signal_sent : bool = false 

var vent_up_sprite = preload("res://models/UI/mini_map/vent_down.png")
var vent_down_sprite = preload("res://models/UI/mini_map/vent_up.png")
var paper_sprite = preload("res://models/UI/mini_map/paper.png")
var player_sprite = preload("res://models/UI/mini_map/player_sprite.png")
var smiley_sprite = preload("res://models/UI/mini_map/smiley.png")
var elevator_sprite = preload("res://models/UI/mini_map/elevator-icon.png")


# shader for smiley
var smiley_shader = preload("res://scripts/shaders/smiley_icon.gdshader")

func _ready() -> void:
	if icon_type == 'VENT-UP' :
		texture = vent_up_sprite
		
	if icon_type == 'VENT-DOWN' :
		texture = vent_down_sprite 
		
	if icon_type == 'PAPER' :
		texture =  paper_sprite
		# player move signal
		GlSignalBus.connect('player_moved', _handle_player_moved)
		reveal_radius = 20
		paper_movement()		
		
	if icon_type == 'PLAYER' :
		texture =  player_sprite 
		z_index += 1
		
	if icon_type == "SMILEY":
		texture = smiley_sprite
		reveal_radius = 15
		z_index += 2

		if material:
			material = material.duplicate()
		else:
			material = ShaderMaterial.new()

		material.shader = smiley_shader
		material.set_shader_parameter("distort_enabled", true)
		GlSignalBus.connect('player_moved', _handle_player_moved)
		
	
	if icon_type == 'ELEVATOR' :
		texture = elevator_sprite 
		
		GlSignalBus.connect('all_papers_collected', _handle_all_papers_collected)
		GlSignalBus.connect('stop_end_time_ticking', _handle_stop_end_time_ticking)
		

	
	
func emit_delete_particle():
	if icon_type == 'PAPER' :
		paper_collect_particle.emitting = true
		await paper_collect_particle.finished
		queue_free()
	queue_free()	

func _handle_player_moved(player_glob_pos : Vector2):
	
	if not visible :
		return	
	
	if icon_type == 'SMILEY' :
		handle_player_move_smiley(player_glob_pos)
	if icon_type == 'PAPER' :
		handle_player_move_paper(player_glob_pos)


	
func handle_player_move_smiley(player_glob_pos) :
	var icon_pos : Vector2 = position
	var dist = player_glob_pos.distance_to(icon_pos)

	var fade = clamp(1.0 - (dist / reveal_radius), 0.0, 250.0)
	
	var in_range = dist < 13.0

	if in_range and not icon_sound_signal_sent and get_parent().visible == true :
		GlSignalBus.emit_signal("smiley_appeared")
		icon_sound_signal_sent = true

	elif not in_range and icon_sound_signal_sent and get_parent().visible == true:
		GlSignalBus.emit_signal("smiley_dissapeard")
		icon_sound_signal_sent = false
	
	modulate.a = fade

func handle_player_move_paper(player_glob_pos) : 
	
	var icon_pos : Vector2 = position
	
	var dist = player_glob_pos.distance_to(icon_pos)
	
	var fade = clamp(1.0 - (dist / reveal_radius), 0.0, 250.0)
	
	var in_range = dist < 10.0

	if in_range and not icon_sound_signal_sent and get_parent().visible == true:
		GlSoundManager.emit_signal('paper_alert')
		GlSignalBus.emit_signal('player_near_paper')
		icon_sound_signal_sent = true

	elif not in_range and icon_sound_signal_sent and get_parent().visible == true:
		icon_sound_signal_sent = false
		GlSignalBus.emit_signal('player_not_near_paper')
	
	modulate.a = fade
	
func paper_movement() :
	var tween = create_tween().set_loops()
	tween.tween_property(self, 'position:y', position.y + 1, 0.5)
	tween.tween_property(self, 'position:y', position.y + -1 , 0.5)
	


func _handle_all_papers_collected() :
	if flash_tween:
		flash_tween.kill()
	
	flash_tween = create_tween()
	flash_tween.set_loops()
	
	var normal_color = Color(1,1,1,1)
	var blue_color = Color(0.6, 0.8, 1.0, 1.0) # light blue
	var white_color = Color(1,1,1,1)
	
	# 1 second total cycle
	flash_tween.tween_property(self, "modulate", blue_color, 1.0)
	flash_tween.tween_property(self, "modulate", white_color, 1.0)
	flash_tween.tween_property(self, "modulate", normal_color, 1.0)
	
	
func _handle_stop_end_time_ticking() :
	
	var normal_color = Color(1,1,1,1)
	
	flash_tween.stop()	
	
	flash_tween.tween_property(self, "modulate", normal_color, 1.0)
	
	if flash_tween:
		flash_tween.kill()
	
	
		

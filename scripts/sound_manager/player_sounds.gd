extends Node

@onready var s_footsteps_carpet := $FootstepsCarpet
@onready var s_footsteps_stairwell := $FootstepsStairwell
@onready var s_running_carpet := $RunCarpet
@onready var s_running_stairwell := $RunStairwell
@onready var s_chase_music := $ChaseMusic

@onready var s_end_section_music := $EndSectionMusic
@onready var s_ambience := $"../Ambience"


enum MoveState { IDLE, WALK, RUN }

var player_in_stairway : bool = false
var current_state := MoveState.IDLE

# for pausing end scene music
var playing_end_music : bool = false 



func _ready() -> void:
	GlSoundManager.connect("player_walked", _on_player_walked)
	GlSoundManager.connect("player_stopped_walking", _on_player_stopped_walking)
	GlSoundManager.connect("player_running", _on_player_running)
	GlSoundManager.connect("player_stopped_running", _on_player_stopped_running)
	GlSoundManager.connect("player_stairway_status", _handle_stairway_status_change)
	# stamina bar depelted	
	GlSignalBus.connect("stamina_bar_depleted_status", _handle_stamina_bar_depleted_status)
	
	# on chase start
	GlSignalBus.connect('smiley_chase_intro_scene_start', _handle_chase_start)
	# on chase end
	GlSignalBus.connect('smiley_chase_end', _handle_chase_end)
	# on end scene start	
	GlSignalBus.connect('all_papers_collected', _handle_all_papers_collected)
	
	
func _on_player_walked() :
	if player_in_stairway :
		s_footsteps_stairwell.play()
	else :
		s_footsteps_carpet.play()

func _on_player_running():
	if player_in_stairway :
		s_running_stairwell.play()
	else :
		s_running_carpet.play()


func _on_player_stopped_walking():
	s_footsteps_stairwell.stop()	
	s_footsteps_carpet.stop()

func _on_player_stopped_running():
	s_running_stairwell.stop()
	s_running_carpet.stop()


func _handle_stairway_status_change(toggleValue : bool):
	player_in_stairway = toggleValue
	
	if toggleValue == false:
		# stair → carpet
		if s_footsteps_stairwell.playing:
			s_footsteps_stairwell.stop()
			s_footsteps_carpet.play()
			
		if s_running_stairwell.playing:
			s_running_stairwell.stop()
			s_running_carpet.play()
	
	else:
		# carpet → stair
		if s_footsteps_carpet.playing:
			s_footsteps_carpet.stop()
			s_footsteps_stairwell.play()
			
		if s_running_carpet.playing:   # <-- FIXED
			s_running_carpet.stop()
			s_running_stairwell.play()

func stop_all_sounds() -> void:
	s_footsteps_carpet.stop()
	s_footsteps_stairwell.stop()
	s_running_carpet.stop()
	s_running_stairwell.stop()

func _handle_stamina_bar_depleted_status(toggle_value : bool) :
	
	if toggle_value == false : 
		if player_in_stairway :
			if s_running_stairwell.playing :
				s_running_stairwell.stop() 
				s_footsteps_stairwell.play()
		if not player_in_stairway :
			if s_running_carpet.playing :
				s_running_carpet.stop() 
				s_footsteps_carpet.play()

###############################
## CHASE AND END GAME MUSIC ###
###############################

func _handle_chase_start(_floor_num : int) :
	s_chase_music.play()
	if playing_end_music :
		s_end_section_music.volume_db = -80

func _handle_chase_end() :
	s_chase_music.stop()
	if playing_end_music :
		s_end_section_music.volume_db = -20.0

func _handle_all_papers_collected() :
	playing_end_music = true
	s_end_section_music.play()
	s_ambience.stop()

func _on_end_section_music_finished() -> void:
	s_ambience.play()
	playing_end_music = false

extends Node

@onready var concrete_slide : AudioStreamPlayer3D = $ConcreteSlide
@onready var looping_hum: AudioStreamPlayer3D = $LoopingHum
@onready var spawn_song : AudioStreamPlayer3D = $SpawnSong

var bossman_floor_diffrent_than_player : bool = false


func _ready() -> void:
	GlSignalBus.connect('player_looking_at_bossman', _handle_play_look_hum)
	GlSignalBus.connect('bossman_intro_start', _handle_bossman_spawn_stop)
	
	# dont play sound if floor nums diffrent
	GlSignalBus.connect('player_changed_floor', _handle_player_changed_floor)
	GlSignalBus.connect('bossman_changed_floor', _handle_bossman_changed_floor)

func _handle_play_look_hum(toggleValue : bool) :
	
	# prevent sound during diffrent floors
	if bossman_floor_diffrent_than_player :
		return	
	else : 
		if toggleValue :
			looping_hum.play()
			concrete_slide.stop()
		if not toggleValue :
			looping_hum.stop()
			concrete_slide.play()
	
func _handle_bossman_spawn_stop(_bossman_char : CharacterBody3D) :
	spawn_song.stop()

func _handle_player_changed_floor(new_player_floor_num : int) :
	if new_player_floor_num != GlSignalBus.bossman_floor_num:
		looping_hum.stop()
		concrete_slide.stop()
		bossman_floor_diffrent_than_player = true
	else :
		bossman_floor_diffrent_than_player = false 

func _handle_bossman_changed_floor(new_bossman_floor_num : int) :
	if new_bossman_floor_num != GlSignalBus.player_floor_num :
		looping_hum.stop()
		concrete_slide.stop()
		bossman_floor_diffrent_than_player = true 
	else :
		bossman_floor_diffrent_than_player = false 
	
	
	

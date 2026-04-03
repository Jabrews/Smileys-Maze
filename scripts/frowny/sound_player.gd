extends Node3D

@onready var sounds = [
	$Sound1,
	$Sound2,
	$Sound3,
	$Sound4
]

var curr_sound_index := 0

func _ready():
	play_next_sound()

func play_next_sound():
	var sound: AudioStreamPlayer3D = sounds[curr_sound_index]
	
	sound.play()
	sound.finished.connect(_on_sound_finished, CONNECT_ONE_SHOT)

func _on_sound_finished():
	curr_sound_index = (curr_sound_index + 1) % sounds.size()
	play_next_sound()

func _on_chase_start():
	# stop everything cleanly
	for s in sounds:
		s.stop()
	
	queue_free()

func stop_sound_loop() :
	self.queue_free()

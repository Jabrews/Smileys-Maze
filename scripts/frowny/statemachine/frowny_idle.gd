extends Node

@onready var frowny : CharacterBody3D = $"../.."
@onready var state_machine : Node = $".."
@onready var sound_player : Node3D = $"../../SoundPlayer"


func state_start() :
	GlSignalBus.connect('player_seen_smiley', _handle_player_seen_smiley)

func state_end() :
	sound_player.stop_sound_loop()
	
func _handle_player_seen_smiley(player_target_pos : Vector3) :
	if state_machine.curr_state.name == 'Idle' :
		state_machine.player_target_position = player_target_pos
		state_machine.switch_state(state_machine.State.RUSH)

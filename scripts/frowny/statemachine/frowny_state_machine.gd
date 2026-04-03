extends Node

@onready var idle_state : Node = $Idle
@onready var rush_state : Node = $Rush

var player_target_position : Vector3 

enum State {
	IDLE,
	RUSH,
}

var states : Dictionary
var curr_state : Node


func _ready():
	
	## speed management to catch up with player floor
	#GlSignalBus.connect('smiley_changed_floor', _handle_player_change_floor)
	#GlSignalBus.connect('smiley_changed_floor', _handle_smiley_change_floor)
	## speed management with each paper
	#GlLightingManager.connect('paper_collected', _handle_paper_collected)


	states = {
		State.IDLE: idle_state,
		State.RUSH: rush_state,
	}

	switch_state(State.IDLE)


func switch_state(new_state : State):

	# exit previous state
	if curr_state and curr_state.has_method("state_end"):
		curr_state.state_end()

	# set new state
	curr_state = states[new_state]

	# start new state
	if curr_state.has_method("state_start"):
		curr_state.state_start()


func _process(delta):
	
	# always apply gravity
	if curr_state and curr_state.has_method("state_process"):
		curr_state.state_process(delta)

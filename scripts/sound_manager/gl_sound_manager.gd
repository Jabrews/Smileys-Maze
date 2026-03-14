extends Node
@warning_ignore("unused_signal")

## player 
# find in sound areas : stairway entrance
#var player_in_stairway : bool = false

signal player_stairway_status(toggleValue : bool)
signal player_walked
signal player_stopped_walking
signal player_running
signal player_stopped_running

## door
signal door_opened
signal door_closed

## mini map
signal smiley_alert()
signal paper_alert()

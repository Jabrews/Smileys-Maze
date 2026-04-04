extends Node

# for death screen sprite rotation
var curr_death_screen = 1




## =========================
## PLAYER / CORE
## =========================
signal stamina_bar_depleted_status(toggleValue : bool)
signal player_started_running
signal player_stopped_running


## =========================
## MOVEMENT / FLOOR SYSTEMS
## =========================
signal vent_floor_travel(vent_floor : int, direction_down : bool)
signal light_area_travel(floor : int)
signal vent_loop_init(vent_downward : bool)
signal vent_loop_end

## =========================
## FLOOR POSITION
## =========================
var player_floor_num : int = 1
var smiley_floor_num : int = 1
var bossman_floor_num : int

signal player_changed_floor(new_floor_num : int)
signal smiley_changed_floor(new_floor_num : int)
signal bossman_changed_floor(new_floor_num : int)

## =========================

## =========================
## PAPER SYSTEM
## =========================
signal paper_object_created(paper_name, paper_glob_pos : Vector3, floor_num : int)
signal delete_paper_coords(paper_name)
signal floor_cleared(floor_num : int)

# player relation to papers
signal player_near_paper()
signal player_not_near_paper()


## =========================
## SMILEY (AI / STATE / COMBAT)
## =========================
signal smiley_update_points(new_points : int)

# chase lifecycle
signal smiley_chase_intro_scene_start(floor_num : int)
signal smiley_chase_intro_scene_end()
signal smiley_chase_end()
signal smiley_caught_player()

# door interaction
signal toggle_smiley_in_door_radius(toggleVal : bool, door_pos : Vector3, smiley_name)
signal smiley_door_state_info(door_pos : Vector3, target_pos : Vector3)
signal smiley_open_door(door_pos)

## =========================
## FROWNY (AI / STATE / COMBAT)
## =========================
signal frowny_active(toggleValue: bool)
signal player_seen_smiley(player_target_pos : Vector3)
signal frowny_toggle_rush_state(toggleValue: bool)
signal frowny_deleted() # after rush
signal frowny_caught_player()

## ==========================
## BOSSMAN (AI / STATE / COMBAT)
## ==========================
signal bossman_spawned()
signal bossman_intro_start(bossman_char : CharacterBody3D)
signal bossman_killed()
signal respawn_bossman()
signal player_looking_at_bossman()
signal bossman_caught_player()



## =========================
## MINIMAP SYSTEM
## =========================
# creation / deletion
signal map_icon_object_init(icon_type, global_pos : Vector3, icon_name)
signal map_icon_delete(icon_name, global_pos : Vector3)

# updates
signal icon_moved(icon_name, icon_type, global_pos : Vector3)
signal icon_changed_floor(icon_name, icon_type, global_pos : Vector3, enter_floor_num : int)

# helpers
signal mini_map_border_set(type, global_pos : Vector3)

# player + alerts
signal player_moved(player_minimap_pos : Vector2)
signal smiley_appeared()
signal smiley_dissapeard()


## =========================
## ELEVATOR / END GAME
## =========================
signal elevator_arrived()
signal all_papers_collected()
signal game_end_fade()
signal stop_end_time_ticking()


## =========================
## AUDIO
## =========================
signal toggle_prevent_ambient_sound(toggleVal : bool)

## =========================
## MAIN MENU
## =========================
signal exit_settings_btn_dwn()
signal btn_hovered()
signal btn_pressed()
signal pause_btn_down()

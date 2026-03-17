extends Node


## player / stamina bar
signal stamina_bar_depleted_status(toggleValue : bool)
signal player_started_running
signal player_stopped_running

## vent / floor_light_area 
signal vent_floor_travel(vent_floor : int , direction_down : bool) #also used in ActiveMapController
signal light_area_travel(floor : int) #also used in ActiveMapController
signal vent_loop_init(vent_downward : bool)
signal vent_loop_end

## DELETE ME ##
## MiniMap ##
## icon creation manager
signal map_icon_object_init(icon_type , global_pos : Vector3, icon_name)
## map math helper
signal mini_map_border_set(type, global_pos : Vector3)
## map delete manager
signal map_icon_delete(icon_name, global_pos : Vector3)
## icon moving manager

# char (player & smiley)
signal icon_moved(icon_name, icon_type, global_pos : Vector3) 
signal icon_changed_floor(icon_name, icon_type, global_pos: Vector3, enter_floor_num : int)
# mini map icons 
signal player_moved(player_minimap_pos: Vector2) 
# mini map alert overlay
signal smiley_appeared()
signal smiley_dissapeard()
#############

## Smiley X Door ##
signal toggle_smiley_in_door_radius(toggleVal : bool, door_pos : Vector3, smiley_name)
# idle state => door state 
signal smiley_door_state_info(door_pos : Vector3, target_pos : Vector3)
signal smiley_open_door(door_pos)

## Paper Manager X Smiley Move Manager ##
signal paper_object_created(paper_name, paper_glob_pos : Vector3, floor_num : int) 
## Minimap Paper Icon X Smiley Move Manager ##
signal player_near_paper()
signal player_not_near_paper()
## Floor Traversal Area X Smiley Move Manager ##
signal smiley_change_floor(smiley_name, new_floor_num : int)

## Paper X Smiley Move Manager ##
signal delete_paper_coords(paper_name)

## Smiley Chase 
signal smiley_chase_intro_scene_start(floor_num : int)
signal smiley_chase_intro_scene_end()

signal smiley_update_points(new_points : int)
signal smiley_chase_end()

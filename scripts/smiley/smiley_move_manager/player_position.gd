extends Node

@export var player : CharacterBody3D 
@export var nav_region : NavigationRegion3D


func get_random_nav_point_around_player(radius: float = 10.0, tries: int = 10) -> Vector3:
	var player_pos = player.global_position
	var nav_map = nav_region.get_navigation_map()

	for i in range(tries):
		var angle = randf() * TAU
		var dist = randf() * radius

		var offset = Vector3(
			cos(angle) * dist,
			0,
			sin(angle) * dist
		)

		var target = player_pos + offset

		var nav_point = NavigationServer3D.map_get_closest_point(nav_map, target)

		if nav_point.distance_to(target) < 2.0:
			return nav_point

	return NavigationServer3D.map_get_closest_point(nav_map, player_pos)

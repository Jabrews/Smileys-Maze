extends Sprite2D

var smiley_chase_points = 100 

func _ready() -> void:
	# start
	GlSignalBus.connect('smiley_chase_intro_scene_start', _handle_show)
	# update effects with point
	GlSignalBus.connect('smiley_update_points', _handle_smiley_update_points)
	# end
	GlSignalBus.connect('smiley_chase_end', _handle_chase_end)


func _handle_show(_floor_num : int) :
	visible = true

func _handle_smiley_update_points(new_points : int) :
	smiley_chase_points += new_points
	var alpha = clamp(smiley_chase_points / 300.0, 0.0, 1.0)
	modulate.a = alpha
	

func _handle_chase_end() :
	visible = false
	smiley_chase_points = 100

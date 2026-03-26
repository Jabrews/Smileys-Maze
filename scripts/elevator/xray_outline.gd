extends StaticBody3D 

# componentgs
@onready var flash_timer : Timer = $FlashTimer
@onready var mesh_circle : MeshInstance3D = $MeshInstance3D

var movement_tween  : Tween


func _ready() -> void:
	visible = false
	GlSignalBus.connect('all_papers_collected', _handle_all_papers_collected)
	GlSignalBus.connect('stop_end_time_ticking', _handle_delete)

	
func _handle_all_papers_collected() :
	flash_timer.start()
	visible = true
	
func _on_flash_timer_timeout() -> void:
	var mat : ShaderMaterial = mesh_circle.get_active_material(0)
	
	var curr_color = mat.get_shader_parameter("wall_visible_color")
	
	var color_one = Color("0097cbbf")
	var color_two = Color("ffffffbf")
	
	if curr_color == null:
		mat.set_shader_parameter("wall_visible_color", color_one)
	elif curr_color.is_equal_approx(color_one):
		mat.set_shader_parameter("wall_visible_color", color_two)
	else:
		mat.set_shader_parameter("wall_visible_color", color_one)
	
func _handle_delete() : 
	self.queue_free()

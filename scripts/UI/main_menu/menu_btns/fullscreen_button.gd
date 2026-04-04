extends TextureRect 

# textures
@export var unchecked_texture : Texture 
@export var checked_texture : Texture

var button_hovered : bool = false
var fullscreen_active : bool = false

func _ready() -> void:
	pivot_offset = size /  2
	
	fullscreen_active = GlSettings.is_fullscren
	if fullscreen_active : 
		texture = checked_texture
	if not fullscreen_active :
		texture = unchecked_texture 
	


func _process(delta: float) -> void:
	if Input.is_action_just_pressed('select') :
		if button_hovered :
			toggle_active()

func _on_mouse_entered() -> void:
	GlSignalBus.emit_signal('btn_hovered')
	
	button_hovered = true
	scale = Vector2(1.1, 1.1)

func _on_mouse_exited() -> void:
	button_hovered = false 
	scale = Vector2(1,1)

func toggle_active() :
	# flip bool
	fullscreen_active = !fullscreen_active 
	
	GlSignalBus.emit_signal('btn_pressed')
	GlSettings.is_fullscren = fullscreen_active
	
	# toggle texture
	if fullscreen_active : 
		texture = checked_texture
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	if not fullscreen_active :
		texture = unchecked_texture 
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	

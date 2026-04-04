extends TextureRect

var float_tween : Tween = null
var start_y : float
var being_hovered : bool = false

## displaying correct card info
# slider pics
var slider_texture_1 = preload("res://models/UI/tutorial_modal/slider/char_viewer-1.png")
var slider_texture_2 = preload("res://models/UI/tutorial_modal/slider/char_viewer-2.png")
var slider_texture_3= preload("res://models/UI/tutorial_modal/slider/char_viewer-3.png")
# img pics
@onready var smiley_picture : Sprite2D = $"../SmileyPic"
@onready var frowny_picture : Sprite2D = $"../FrownyPic"
@onready var bossman_picture : Sprite2D = $"../BossmanPic"
# labels
@onready var top_text_label : Label = $"../TopTextLabel"
@onready var bottom_text_label : Label = $"../BottomTextLabel"

var current_index = 1


func _ready() -> void:
	start_y = position.y
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	start_float_tween()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed('select') :
		if being_hovered :
			GlSignalBus.emit_signal('btn_pressed')
			handle_switch_text()



func start_float_tween() -> void:
	if float_tween:
		float_tween.kill()
	
	position.y = start_y
	
	float_tween = create_tween()
	float_tween.set_loops()
	float_tween.tween_property(self, "position:y", start_y + 1, 0.5)
	float_tween.tween_property(self, "position:y", start_y - 1, 0.5)


func _on_mouse_entered() -> void:
	
	GlSignalBus.emit_signal('btn_hovered')
	being_hovered = true
	
	if float_tween:
		float_tween.kill()
		float_tween = null


func _on_mouse_exited() -> void:
	being_hovered = false
	start_float_tween()
	
func handle_switch_text() :
	
	smiley_picture.visible = false
	frowny_picture.visible = false
	bossman_picture.visible = false
	
	if current_index == 3 :
		current_index = 1	
	else : 
		current_index += 1
	
	match current_index :
		1 :
			top_text_label.text = 'Smiley'
			bottom_text_label.text = 'Navigates through Maze, taking special noti-ce of when player nears paper. When entity enters chase mode avoid appearing in his  vision'
			texture = slider_texture_1
			smiley_picture.visible = true 
		2 :
			top_text_label.text = 'Frowny'
			bottom_text_label.text = 'Spawns in various position around the maze. Will become enraged when player makes eye contact with him. Its reccomended to       shoegaze...'
			texture = slider_texture_2
			frowny_picture.visible = true
		3 :
			top_text_label.text = 'Bossman'
			bottom_text_label.text = 'Spawns in various position around the maze. Approaches player at highspeeds when not   being looked at. Can be vanquished by coll-ecting a paper or changing floors.'
			texture = slider_texture_3
			bossman_picture.visible = true
	
	
			
	

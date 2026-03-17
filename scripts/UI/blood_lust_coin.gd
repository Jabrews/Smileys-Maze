extends Control

# components
@onready var coin_sprite : AnimatedSprite2D = $Coin

@export var max_shake : float = 8.0

var base_position : Vector2
var up_down_tween: Tween

var smiley_chase_point = 0
var update_loop = false

func _ready() -> void:
	# start
	GlSignalBus.connect('smiley_chase_intro_scene_start', _handle_show)
	# update effects with point
	GlSignalBus.connect('smiley_update_points', _handle_smiley_update_points)
	# end
	GlSignalBus.connect('smiley_chase_end', _handle_chase_end)

	base_position = position

	up_down_tween = create_tween()
	up_down_tween.set_loops()
	up_down_tween.set_trans(Tween.TRANS_BACK)
	up_down_tween.set_ease(Tween.EASE_IN)

	up_down_tween.tween_property(self, "position:y", position.y + 3.0, 2)
	up_down_tween.tween_property(self, "position:y", position.y - 3.0, 2)


func _handle_show(_floor_num : int):
	visible = true
	update_loop = true


func _process(delta: float) -> void:
	if not update_loop:
		return

	gradually_shake(smiley_chase_point)

	# 300+ = flash
	if smiley_chase_point >= 200:
		var flash = sin(Time.get_ticks_msec() * 0.005)
		modulate = Color.BLACK if flash > 0 else Color.RED
	else:
		modulate = Color.WHITE


func gradually_shake(points: int):
	var clamped = clamp(points, 0, 300)
	var t = clamped / 300.0  # normalize 0–1

	# stronger curve (feels better)
	t = pow(t, 2.0)

	var shake_amount = t * max_shake

	position = base_position + Vector2(
		randf_range(-shake_amount, shake_amount),
		randf_range(-shake_amount, shake_amount)
	)


func _handle_smiley_update_points(new_point: int):
	smiley_chase_point += new_point
	
	if smiley_chase_point <= 100:
		coin_sprite.play('1')
	elif smiley_chase_point <= 200:
		coin_sprite.play('2')
	elif smiley_chase_point <= 300:
		print('level 3')
		coin_sprite.play('3')
	
func _handle_chase_end() :
	smiley_chase_point = 100	
	visible = false
	coin_sprite.play('1')
	update_loop = false
	

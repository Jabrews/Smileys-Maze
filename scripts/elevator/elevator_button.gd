extends StaticBody3D

@export var hoverable : StaticBody3D
@export var open_area : Area3D

# bouncing sprite scenes
@onready var lock_sprite_scene : PackedScene = preload("res://scenes/hover_bouncing_sprites/lock.tscn")
@onready var interact_sprite_scene : PackedScene = preload("res://scenes/hover_bouncing_sprites/key_e.tscn")

func _ready() -> void:
	hoverable.bouncing_sprite_scene = lock_sprite_scene
	
func buttons_available() :
	hoverable.bouncing_sprite_scene = interact_sprite_scene 
	open_area.monitoring = true

func button_pressed() : 
	open_area.monitoring = false 

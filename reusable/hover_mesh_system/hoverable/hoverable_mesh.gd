extends Node
	
## note, this body should be in 'hoverable' col. layer
## MESH ##

## create new scene of this mesh, put into seperate 'highlight' folder
## this scene's mesh should be in same pos as main scene
@export var hover_mesh_scene : PackedScene 
@export var orignal_mesh : MeshInstance3D 

@export var movement_possible = false
# can leave this blank
@export var bouncing_sprite_scene : PackedScene
@export var custom_b_sprite_pos : Vector3
var bouncing_sprite = null

@export var original_coll_shape : CollisionShape3D
@onready var hoverable_coll_shape : CollisionShape3D = $CollisionShape3D

var hover_mesh = null


func _ready() -> void:
	# set correct shape for hoverable coll shape
	hoverable_coll_shape.shape = original_coll_shape.shape.duplicate()
	hoverable_coll_shape.global_transform = original_coll_shape.global_transform
	
func _process(_delta: float) -> void:
	
	## kinda hacky but works for moving objects
	if movement_possible:
		movement_possible_transforming()
	
		
func display_hover():
	hover_mesh = hover_mesh_scene.instantiate()

	## hover mesh same transform as org. mesh
	hover_mesh.scale = orignal_mesh.scale
	hover_mesh.position= orignal_mesh.position
	hover_mesh.rotation= orignal_mesh.rotation
	
	# breif exspand
	hover_mesh.scale.x += 1
	hover_mesh.position.y -= 0.05 #adjust for blender bottom origin

	if bouncing_sprite_scene :
		handle_create_bouncing_sprite()
	
	add_child(hover_mesh)
	
	
func exit_hover():
	if hover_mesh:
		hover_mesh.queue_free()
		hover_mesh = null
	# Sprite
	if bouncing_sprite :
		bouncing_sprite.exit_bouncing_sprite()
		bouncing_sprite = null

# keeps the hover at the same pos
func movement_possible_transforming() :
	# prevent pre-rendering transform
	if hoverable_coll_shape.global_transform == original_coll_shape.global_transform:
		return
		
	# prevent pre-rendering transform
	if hover_mesh :
		if hover_mesh.transform == orignal_mesh.transform :
			return
		
	# setting these transforms
	hoverable_coll_shape.global_transform = original_coll_shape.global_transform
	if hover_mesh : #only if it exists
		hover_mesh.transform = orignal_mesh.transform

func handle_create_bouncing_sprite() :
	
	bouncing_sprite = bouncing_sprite_scene.instantiate()
	
	add_child(bouncing_sprite)
	
	# pos / transform
	if custom_b_sprite_pos :
		bouncing_sprite.global_position = orignal_mesh.global_position + custom_b_sprite_pos
	else : 
		bouncing_sprite.global_position = orignal_mesh.global_position + Vector3(1, 1, 1) # adjust
	# notice sprite is billboard so not roation nessesary
	bouncing_sprite.show_bouncing_sprite()
	
	
	
	
	

extends Spatial

signal load_world(scene)

export var enable_locomotion = false setget set_enable_locomotion, get_enable_locomotion
export var enable_pointer = false setget set_enable_pointer, get_enable_pointer

var player_node : ARVROrigin

func set_enable_locomotion(new_value):
	enable_locomotion = new_value
	
	if player_node:
		player_node.enable_locomotion = enable_locomotion

func get_enable_locomotion():
	return enable_locomotion

func set_enable_pointer(new_value):
	enable_pointer = new_value
	
	if player_node:
		player_node.enable_pointer = enable_pointer

func get_enable_pointer():
	return enable_pointer

func init_world(new_player_node : ARVROrigin):
	# remember our player node
	player_node = new_player_node
	
	# update our functions
	set_enable_locomotion(enable_locomotion)
	set_enable_pointer(enable_pointer)
	
	# and use our spawn point to set our player position
	player_node.position_player($PlayerSpawnPoint.global_transform)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


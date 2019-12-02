extends "res://scenes/base_scene.gd"

func init_world(new_player_node : ARVROrigin):
	.init_world(new_player_node)
	
	if player_node:
		$Height.global_transform.origin.y = player_node.get_camera_transform().origin.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_node:
		$Height.global_transform.origin.y = lerp($Height.global_transform.origin.y, player_node.get_camera_transform().origin.y, delta) 
	pass

func _on_CanvasLayer_load_world(scene):
	emit_signal("load_world", scene)
	

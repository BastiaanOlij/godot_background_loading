extends CanvasLayer

signal load_world(scene)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Button08_pressed():
	emit_signal("load_world", "res://scenes/test_scene/test_scene.tscn")

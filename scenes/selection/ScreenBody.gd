extends StaticBody

export (NodePath) var viewport = null setget set_viewport, get_viewport
export var screen_size = Vector2(100.0, 100.0)

func set_viewport(path):
	viewport = path
	if is_ready:
		if viewport:
			vp = get_node(viewport)
		else:
			vp = null
		
		if vp:
			viewport_size = vp.size
		else:
			viewport_size = Vector2(100.0, 100.0)

func get_viewport():
	return viewport

var is_ready = false
var vp = null
var viewport_size = Vector2(100.0, 100.0)
var mouse_mask = 0

# Convert intersection point to screen coordinate
func global_to_viewport(p_at):
	var t = $CollisionShape.global_transform
	var at = t.xform_inv(p_at)
	
	# Convert to screen space
	at.x = ((at.x / screen_size.x) + 0.5) * viewport_size.x
	at.y = (0.5 - (at.y / screen_size.y)) * viewport_size.y
	
	return Vector2(at.x, at.y)

func pointer_moved(from, to):
	var local_from = global_to_viewport(from)
	var local_to = global_to_viewport(to)
	
	# Let's mimic a mouse
	var event = InputEventMouseMotion.new()
	event.set_position(local_to)
	event.set_global_position(local_to)
	event.set_relative(local_to - local_from) # should this be scaled/warped?
	event.set_button_mask(mouse_mask)
	
	if vp:
		vp.input(event)

func pointer_pressed(at):
	var local_at = global_to_viewport(at)
	
	# Let's mimic a mouse
	mouse_mask = 1
	var event = InputEventMouseButton.new()
	event.set_button_index(1)
	event.set_pressed(true)
	event.set_position(local_at)
	event.set_global_position(local_at)
	event.set_button_mask(mouse_mask)
	
	if vp:
		vp.input(event)

func pointer_released(at):
	var local_at = global_to_viewport(at)
	
	# Let's mimic a mouse
	mouse_mask = 0
	var event = InputEventMouseButton.new()
	event.set_button_index(1)
	event.set_pressed(false)
	event.set_position(local_at)
	event.set_global_position(local_at)
	event.set_button_mask(mouse_mask)
	
	if vp:
		vp.input(event)

# Called when the node enters the scene tree for the first time.
func _ready():
	is_ready = true
	
	set_viewport(viewport)

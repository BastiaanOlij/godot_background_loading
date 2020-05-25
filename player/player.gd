extends ARVROrigin

export var enable_locomotion = false setget set_enable_locomotion, get_enable_locomotion
export var enable_pointer = false setget set_enable_pointer, get_enable_pointer

onready var teleport_function = $Left_Hand/Function_Teleport
onready var direct_function = $Right_Hand/Function_Direct_movement
onready var left_pointer = $Left_Hand/Function_pointer
onready var right_pointer = $Right_Hand/Function_pointer

# left = 0, right = 1
var pointer_on_hand = 1

func set_enable_locomotion(new_value):
	enable_locomotion = new_value
	
	if teleport_function:
		teleport_function.enabled = enable_locomotion
	
	if direct_function:
		direct_function.enabled = enable_locomotion

func get_enable_locomotion():
	return enable_locomotion

func set_enable_pointer(new_value):
	enable_pointer = new_value
	
	if left_pointer:
		left_pointer.enabled = enable_pointer and pointer_on_hand == 0
	
	if right_pointer:
		right_pointer.enabled = enable_pointer and pointer_on_hand == 1

func get_enable_pointer():
	return enable_pointer

func get_camera_transform():
	return $ARVRCamera.global_transform

# position our player at a given location and orientation
func position_player(new_transform : Transform):
	var t : Transform = $ARVRCamera.transform
	
	# ignore the height of our camera
	t.origin.y = 0.0
	
	# remove the tilt of our camera
	t.basis.y = Vector3(0.0, 1.0, 0.0) # up
	t.basis.z.y = 0.0
	if t.basis.z.length() == 0.0:
		# we're looking straight up or down
		t.basis.x = Vector3(1.0, 0.0, 0.0)
		t.basis.z = Vector3(0.0, 0.0, 1.0)
	else:
		t.basis.z = t.basis.z.normalized()
		t.basis.x = t.basis.y.cross(t.basis.z).normalized()
	
	# inverse the camera matrix
	t = t.inverse()
	
	# and combine it with the transform we want the player at
	global_transform = new_transform * t

# Called when the node enters the scene tree for the first time.
func _ready():
	var interface = ARVRServer.find_interface('OpenVR')
	if interface and interface.initialize():
		var vp = get_viewport()
		
		# turn our arvr mode on for our viewport
		vp.arvr = true
		
		# set 3d linear, colors will look correct in the headset but darker on screen.
		# vp.keep_3d_linear = true
		
		# turn off vsync, our HMD renders at a higher refresh rate
		OS.vsync_enabled = false
		
		# set target FPS to 90
		Engine.target_fps = 90
	
	# reassign this as they are originally called before our scene is ready
	set_enable_locomotion(enable_locomotion)
	set_enable_pointer(enable_pointer)

func _on_Left_Hand_button_pressed(button):
	if button == left_pointer.active_button and enable_pointer and pointer_on_hand == 1:
		pointer_on_hand = 0
		
		# reenable to switch hands
		set_enable_pointer(enable_pointer)

func _on_Right_Hand_button_pressed(button):
	if button == right_pointer.active_button and enable_pointer and pointer_on_hand == 0:
		pointer_on_hand = 1
		
		# reenable to switch hands
		set_enable_pointer(enable_pointer)

func _on_Function_pointer_pointer_moved(on, from, to):
	if on.has_method('pointer_moved'):
		on.pointer_moved(from, to)

func _on_Function_pointer_pointer_pressed(on, at):
	if on.has_method('pointer_pressed'):
		on.pointer_pressed(at)

func _on_Function_pointer_pointer_released(on, at):
	if on.has_method('pointer_released'):
		on.pointer_released(at)

extends Spatial

onready var resource_queue = get_node('/root/resource_queue')

enum LoadingStates {
	FADE_TO_BLACK_1,
	FADE_TO_LOADING,
	LOADING,
	FADE_TO_BLACK_2,
	FADE_TO_WORLD,
	PLAYING
}

var loading_state = LoadingStates.PLAYING
var current_world = null
var loading_world = null

func load_world(scene_to_load):
	# remember which scene we're loading
	loading_world = scene_to_load
	
	# start loading
	resource_queue.queue_resource(loading_world)
	
	# fade to black, if we've already faded to black (startup) we get our signal immediately
	loading_state = LoadingStates.FADE_TO_BLACK_1
	$FadeToBlack.is_faded = true

# Called when the node enters the scene tree for the first time.
func _ready():
	resource_queue.start()
	
	# load our first scene
	#load_world('res://scenes/test_scene/test_scene.tscn')
	load_world('res://scenes/selection/selection.tscn')

func _on_FadeToBlack_finished_fading():
	match loading_state:
		LoadingStates.FADE_TO_BLACK_1:
			# hide our world scene
			$World_scene.visible = false
			
			# remove our current world
			if current_world:
				current_world.disconnect("load_world", self, "load_world")
				$World_scene.remove_child(current_world)
				current_world.queue_free()
				current_world = null
			
			# Position our player in the center
			$OVRFirstPerson.position_player(Transform())
			
			# Disable our functions
			$OVRFirstPerson.enable_locomotion = false
			$OVRFirstPerson.enable_pointer = false
			
			# unhide our loading scene
			$Loading_scene.visible = true
			
			# fade to transparent
			loading_state = LoadingStates.FADE_TO_LOADING
			$FadeToBlack.is_faded = false
		LoadingStates.FADE_TO_LOADING:
			# simply change the state to loading
			loading_state = LoadingStates.LOADING
			set_process(true)
		LoadingStates.FADE_TO_BLACK_2:
			# hide our loading scene
			$Loading_scene.visible = false
			
			# add our new scene
			$World_scene.add_child(current_world)
			current_world.init_world($OVRFirstPerson)
			current_world.connect("load_world", self, "load_world")
			$World_scene.visible = true
			
			# fade to transparent
			loading_state = LoadingStates.FADE_TO_WORLD
			$FadeToBlack.is_faded = false
		LoadingStates.FADE_TO_WORLD:
			# simply set the state to playing
			loading_state = LoadingStates.PLAYING
		_:
			# nothing to do in all other states
			pass

func _process(delta):
	if loading_state == LoadingStates.LOADING:
		# we could do something with a progress bar here
		
		# check if our resource is available
		var new_world = resource_queue.get_resource(loading_world)
		if new_world:
			# if we're finished create a new instance
			current_world = new_world.instance()
			
			# fade to black
			loading_state = LoadingStates.FADE_TO_BLACK_2
			$FadeToBlack.is_faded = true
			set_process(false)

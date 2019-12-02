extends MeshInstance

# Called when the node enters the scene tree for the first time.
func _ready():
	# create a unique material for our viewport
	var material : SpatialMaterial = SpatialMaterial.new()
	
	material.flags_unshaded = true
	material.flags_transparent = true
	material.albedo_texture = $Viewport.get_texture()
	
	set_surface_material(0, material)
	
	$Body.screen_size = Vector2(mesh.size.x, mesh.size.y)

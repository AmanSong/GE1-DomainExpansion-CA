extends Node3D

var building = preload("res://building.tscn")
@onready var world_environment : WorldEnvironment = $WorldEnvironment 

func _ready():
	# Connect to the tree_entered signal of each node in the scene
	$Player.connect("domain_instance_ready", _on_domain_instance_ready)
	
	var cube_size = 6
	var cube_distance = 8
	var cube_count = 26
	var side_length = int(sqrt(cube_count))

	for i in range(cube_count):
		var building_instance = building.instantiate()

		if i < side_length or (i >= side_length and i < cube_count - side_length and (i % side_length == 0 or i % side_length == side_length - 1)) or i >= cube_count - side_length:
			var row = i / side_length
			var col = i % side_length

			var position = Vector3((col - (side_length - 1) * 0.5) * cube_distance, 0, (row - (side_length - 1) * 0.5) * cube_distance)
			building_instance.transform.origin = position * cube_size
			add_child(building_instance)
			


func _on_domain_instance_ready():
	print("Received signal: Domain instance is ready")
		
	world_environment.environment.background_mode = Environment.BG_COLOR
	world_environment.environment.background_color = Color(0, 0, 0)



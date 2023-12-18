extends Node3D

var building = preload("res://building.tscn")
@onready var world_environment : WorldEnvironment = $WorldEnvironment 
@onready var city_asset = $NavigationRegion3D/CityAsset

var enemy_instances = []
var enemy_script = preload("res://enemy.tscn")

@onready var spawn_points = $spawn_points
@onready var navigation_region_3d = $NavigationRegion3D

var monster = load("res://monster.tscn")
var monster_instance

func _ready():
	# Connect to the tree_entered signal of each node in the scene
	$Player.connect("domain_instance_ready", _on_domain_instance_ready)
	$Player.connect("domain_instance_finished", _on_domain_finished)
	
	randomize()
	
	# old code to spawn in red capsule enemies
#	var spawn_radius = 100.0
#	var floor_height = 0.0 
#
#	for i in range(10):
#		var enemy_instance = enemy_script.instantiate()
#
#		# Set random position on the floor
#		var random_position = Vector3(randf(), 0.0, randf()).normalized() * randf() * spawn_radius
#		random_position.y = floor_height
#
#		enemy_instance.transform.origin = random_position
#		enemy_instance.SPEED = randf() * (5 - 1) + 1
#		enemy_instance.player_path = "../Player"
#
#		add_child(enemy_instance)
#		enemy_instances.append(enemy_instance)

	# old code for placing buildings
#	var cube_size = 6
#	var cube_distance = 8
#	var cube_count = 26
#	var side_length = int(sqrt(cube_count))
#
#	for i in range(cube_count):
#		var building_instance = building.instantiate()
#
#		if i < side_length or (i >= side_length and i < cube_count - side_length and (i % side_length == 0 or i % side_length == side_length - 1)) or i >= cube_count - side_length:
#			var row = i / side_length
#			var col = i % side_length
#
#			var position = Vector3((col - (side_length - 1) * 0.5) * cube_distance, 0, (row - (side_length - 1) * 0.5) * cube_distance)
#			building_instance.transform.origin = position * cube_size
#			add_child(building_instance)
			

func _on_domain_instance_ready():
	print("Received signal: Domain instance is ready")
	world_environment.environment.background_mode = Environment.BG_SKY
#	world_environment.environment.background_color = Color(1, 0, 0)
	
	var panorama_sky_material = PanoramaSkyMaterial.new()
	panorama_sky_material = load("res://Images/infinite_void.tres")
	
	world_environment.environment.sky.sky_material = panorama_sky_material
	city_asset.visible = false
	
	for enemy_instance in enemy_instances:
		if is_instance_valid(enemy_instance):
			enemy_instance.domain_hit()
	

func _on_domain_finished():
	print("Received signal: Domain instance is finished")
	city_asset.visible = true
	world_environment.environment.background_mode = Environment.BG_SKY 
	world_environment.environment.sky.sky_material = PhysicalSkyMaterial.new()
	
	for enemy_instance in enemy_instances:
		if is_instance_valid(enemy_instance):
			enemy_instance.purple_hit()
			
# function to choose random spawn point
func _get_random_child(parent_node):
	var random_id = randi() % parent_node.get_child_count()
	return parent_node.get_child(random_id)

func _on_spawn_timer_timeout():
	var spawn_point = _get_random_child(spawn_points).global_position
	monster_instance = monster.instantiate()
	monster_instance.player_path = "../../person"
	monster_instance.position = spawn_point
	navigation_region_3d.add_child(monster_instance)
#	# Add the spawned monster to the array
#	enemy_instances.append(monster_instance)

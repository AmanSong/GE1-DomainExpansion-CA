extends Node3D

var building = preload("res://building.tscn")

func _ready():
	var cube_size = 5 # The size of the cube
	var cube_distance = 4 # The distance between the cubes
	var cube_count = 128 # The number of cubes to spawn

	var side_length = int(sqrt(cube_count)) # Calculate the side length of the square

	for i in range(cube_count):
		var building_instance = building.instantiate()

		# Check if the current iteration is on the perimeter of the square
		if i < side_length or (i >= side_length and i < cube_count - side_length and (i % side_length == 0 or i % side_length == side_length - 1)) or i >= cube_count - side_length:
			var row = i / side_length # Calculate the row
			var col = i % side_length # Calculate the column

			# Adjust the position calculation to spawn buildings at the perimeter
			var position = Vector3((col - (side_length - 1) * 0.5) * cube_distance, 0, (row - (side_length - 1) * 0.5) * cube_distance)

			# Apply the position and adjust for cube size
			building_instance.transform.origin = position * cube_size
			add_child(building_instance)


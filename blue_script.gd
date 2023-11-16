extends Node3D

const SPEED = 40.0

@onready var mesh_instance_3d = $MeshInstance3D
@onready var ray_cast_3d = $RayCast3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.basis * Vector3(0, 0, -SPEED) * delta

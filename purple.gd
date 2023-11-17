extends Node3D

const SPEED = 100.0

@onready var purple = $MeshInstance3D
@onready var ray_cast_3d = $RayCast3D
@onready var purple_animation = $PurpleAnimation

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.basis * Vector3(0, 0, -SPEED) * delta
	await get_tree().create_timer(10.0).timeout
	queue_free()

func _on_timer_timeout():
	queue_free() # Replace with function body.

extends Node3D

const SPEED = 40.0

@onready var blue = $MeshInstance3D
@onready var rayCast3d = $RayCast3D
@onready var particles = $CPUParticles3D2

var is_moving = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_moving:
		position += transform.basis * Vector3(0, 0, -SPEED) * delta
		if rayCast3d.is_colliding():
			blue.visible = false
			particles.emitting = true
			await get_tree().create_timer(10.0).timeout
			queue_free()

func _on_timer_timeout():
	queue_free()

func stop_movement():
	is_moving = false

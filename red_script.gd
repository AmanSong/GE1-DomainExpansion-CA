extends Node3D

const SPEED = 40.0

@onready var red = $MeshInstance3D
@onready var red_rayCast3d = $RayCast3D
@onready var red_particles = $CPUParticles3D2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.basis * Vector3(0, 0, -SPEED) * delta
	if red_rayCast3d.is_colliding():
		red.visible = false
		red_particles.emitting = true
		await get_tree().create_timer(10.0).timeout
		queue_free()

func _on_timer_timeout():
	queue_free()

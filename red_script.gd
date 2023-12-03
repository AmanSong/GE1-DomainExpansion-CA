extends Node3D

const SPEED = 40.0

@onready var red = $MeshInstance3D
@onready var red_rayCast3d = $RayCast3D
@onready var red_particles2 = $CPUParticles3D
@onready var red_particles = $CPUParticles3D2

# Load sound
@onready var audio_player = $AudioStreamPlayer3D 
var red_sound: AudioStream = preload("res://Sounds/red_sfx.mp3")

var is_moving = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_moving:
		# Play the sound when fired
		if not audio_player.playing:
			audio_player.stream = red_sound
			audio_player.play()
			
		position += transform.basis * Vector3(0, 0, -SPEED) * delta
		if red_rayCast3d.is_colliding():
			red.visible = false
			red_particles2.visible = false
			red_particles.emitting = true
			await get_tree().create_timer(10.0).timeout
			queue_free()

func _on_timer_timeout():
	queue_free()

func stop_movement():
	is_moving = false

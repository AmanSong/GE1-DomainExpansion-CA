extends Node3D

const SPEED = 40.0

@onready var blue = $MeshInstance3D
@onready var rayCast3d = $RayCast3D
@onready var particles = $CPUParticles3D2
@onready var particles2 = $CPUParticles3D

# Load sound
@onready var audio_player = $AudioStreamPlayer3D 
var blue_sound: AudioStream = preload("res://Sounds/blue_sfx.mp3")

var is_moving = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_moving:
		# Play the sound when fired
		if not audio_player.playing:
			audio_player.stream = blue_sound
			audio_player.play()
			
		position += transform.basis * Vector3(0, 0, -SPEED) * delta
		if rayCast3d.is_colliding():
			audio_player.stop()
			stop_movement()
			blue.visible = false
			particles2.visible = false
			particles.emitting = true
			await get_tree().create_timer(10.0).timeout
			queue_free()

func _on_timer_timeout():
	queue_free()

func stop_movement():
	is_moving = false

extends Node3D

const SPEED = 50.0

@onready var purple = $MeshInstance3D
@onready var ray_cast_3d = $RayCast3D

# Load sound
@onready var audio_player = $AudioStreamPlayer3D 
var purple_sound: AudioStream = preload("res://Sounds/purple_theme.mp3")

var is_moving = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_moving:
		position += transform.basis * Vector3(0, 0, -SPEED) * delta
		
		if ray_cast_3d.is_colliding():
			print('purple is coliding')
			var collider = ray_cast_3d.get_collider()
			if collider and collider.is_in_group("enemy"):
				collider.purple_hit()
				
			await get_tree().create_timer(10.0).timeout
			queue_free()


func _on_timer_timeout():
	queue_free() 

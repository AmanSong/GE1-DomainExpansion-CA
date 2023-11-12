extends RigidBody3D

@export var speed = 10.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var left_right = Input.get_axis("move_left", "move_right")
	if abs(left_right) > 0:     
		translate(Vector3.RIGHT * speed * left_right * delta)
	
	var for_back = Input.get_axis("move_backward", "move_forward")
	if abs(for_back) > 0:     
		translate(Vector3.FORWARD * speed * for_back * delta)
		

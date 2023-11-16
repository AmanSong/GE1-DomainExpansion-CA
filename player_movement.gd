extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var current_speed = 5.0
@export var walk_speed = 5.0
@export var sprint_speed = 10.0
@export var mouse_sensitivity = 0.25
@onready var pov = $POV

var is_jumping = false
var jump_height = 5.0

# abilities
var blue = preload("res://blue.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	# Reset jump status when the character lands
	if is_on_floor():
		is_jumping = false
		
	if Input.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


# for camera movement
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		pov.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		pov.rotation.x = clamp(pov.rotation.x, deg_to_rad(-89), deg_to_rad(89))
  
	if is_on_floor() and Input.is_action_pressed("jump"):
		is_jumping = true
		velocity.y = sqrt(2.0 * gravity * jump_height)

func _physics_process(delta):
	#to add gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	# for sprinting or walking
	if Input.is_action_pressed("sprint"):
		current_speed = sprint_speed
	else:
		current_speed = walk_speed
		
	var input_direction = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
	
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
		
		
	# to fire blue
	if Input.is_action_just_pressed("technique_blue"):
		technique_blue()

	move_and_slide()
	
func technique_blue():
	if blue:  # Check if the blue scene is loaded
		var blue_instance = blue.instantiate()
		
		blue_instance.position = position + transform.basis.z * 2

		# Set the rotation of the blue_instance based on the camera's transform
		var camera_transform = pov.global_transform  # Assuming the camera is a child of the player
		var camera_forward = -camera_transform.basis.z.normalized()
		var target_rotation = Basis().looking_at(camera_forward, Vector3(0, 1, 0))

		blue_instance.transform.basis = target_rotation

		get_parent().add_child(blue_instance)
	else:
		print("Error: Blue scene not loaded")





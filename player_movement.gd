extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var current_speed = 5.0
@export var walk_speed = 5.0
@export var sprint_speed = 10.0
@export var mouse_sensitivity = 0.25
@onready var pov = $POV
@onready var player = $"."


var is_jumping = false
var jump_height = 5.0

# abilities
var blue = preload("res://blue.tscn")
var red = preload("res://red.tscn")
var purple = preload("res://purple.tscn")

@export var technique_blue_cooldown = 1.0 
@export var technique_red_cooldown = 1.0
# Cooldown timers
var blue_cooldown_timer = 0.0
var red_cooldown_timer = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	# Reset jump status when the character lands
	if is_on_floor():
		is_jumping = false
		
	if Input.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	# Update cooldown timers
	blue_cooldown_timer = max(0, blue_cooldown_timer - delta)
	red_cooldown_timer = max(0, red_cooldown_timer - delta)

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
	if Input.is_action_just_pressed("technique_blue") and blue_cooldown_timer == 0.0:
		technique_blue()
		blue_cooldown_timer = technique_blue_cooldown

	# to fire red
	if Input.is_action_just_pressed("technique_red") and red_cooldown_timer == 0.0:
		technique_red()
		red_cooldown_timer = technique_red_cooldown
	
	# to fire purple
	if Input.is_action_just_pressed("technique_purple"):
		technique_purple()

	move_and_slide()
	
func technique_blue():
	if blue:  # Check if the blue scene is loaded
		var blue_instance = blue.instantiate()
		
		# move blue to the front and more to the left
		blue_instance.position = position + transform.basis.z * -2 + transform.basis.x * -2

		# Set the rotation of the blue_instance based on the camera's transform
		var camera_transform = pov.global_transform 
		var camera_forward = -camera_transform.basis.z.normalized()
		var target_rotation = Basis().looking_at(camera_forward, Vector3(0, 1, 0))

		blue_instance.transform.basis = target_rotation

		get_parent().add_child(blue_instance)
	else:
		print("Error: Blue scene not loaded")

func technique_red():
	if red:  # Check if the red scene is loaded
		var red_instance = red.instantiate()
		
		# move red in front and to the right more
		red_instance.position = position + transform.basis.z * -2 + transform.basis.x * 2

		# Set the rotation of the red_instance based on the camera's transform
		var camera_transform = pov.global_transform 
		var camera_forward = -camera_transform.basis.z.normalized()
		var target_rotation = Basis().looking_at(camera_forward, Vector3(0, 1, 0))

		red_instance.transform.basis = target_rotation

		get_parent().add_child(red_instance)
	else:
		print("Error: Red scene not loaded")

func technique_purple():
	if purple:  # Check if the red scene is loaded
		var purple_instance = purple.instantiate()
		var red_instance = red.instantiate()
		var blue_instance = blue.instantiate()
		
		# move purple in front and to the right more
		purple_instance.global_transform.origin = pov.global_transform.origin + pov.global_transform.basis.z * -2

		# Set the rotation of the purple_instance based on the camera's transform
		var camera_transform = pov.global_transform 
		var camera_forward = -camera_transform.basis.z.normalized()
		var target_rotation = Basis().looking_at(camera_forward, Vector3(0, 1, 0))
		
		# purple facing from camera
		purple_instance.transform.basis = target_rotation
		
		# stop them from moving
		red_instance.stop_movement()
		blue_instance.stop_movement()
		
		# set their starting positions
		red_instance.position = position + transform.basis.z * -2 + transform.basis.x * 2
		red_instance.transform.basis = target_rotation
		blue_instance.position = position + transform.basis.z * -2 + transform.basis.x * -2
		blue_instance.transform.basis = target_rotation
		
		
		get_parent().add_child(red_instance)
		get_parent().add_child(blue_instance)
		
		var mid = pov.global_transform.origin + pov.global_transform.basis.z * -2
		
		var tween_red = get_tree().create_tween()
		var tween_blue = get_tree().create_tween()
		
		tween_red.tween_property(red_instance, "position", mid, 5.0)
		tween_blue.tween_property(blue_instance, "position", mid, 5.0)
		
		await get_tree().create_timer(5).timeout
		red_instance.queue_free()
		blue_instance.queue_free()
		get_parent().add_child(purple_instance)
		
	else:
		print("Error: Purple scene not loaded")
		

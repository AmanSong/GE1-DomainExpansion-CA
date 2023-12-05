extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var current_speed = 5.0
@export var walk_speed = 5.0
@export var sprint_speed = 10.0
@export var mouse_sensitivity = 0.25
@onready var pov = $POV
@onready var player = $"."
@onready var ui = $CanvasLayer


@onready var audio_player = $AudioStreamPlayer3D 

var is_jumping = false
var jump_height = 5.0

# abilities
var blue = preload("res://blue.tscn")
var red = preload("res://red.tscn")
var purple = preload("res://purple.tscn")
var domain = preload("res://infinite_void.tscn")

@export var technique_blue_cooldown = 5.0 
@export var technique_red_cooldown = 5.0
@export var technique_purple_cooldown = 20.0
@export var domain_expansion_cooldown = 65.0

# Cooldown timers
var blue_cooldown_timer = 0.0
var red_cooldown_timer = 0.0
var purple_cooldown_timer = 0.0
var domain_cooldown_timer = 0.0
var blue_cooldown_label : Label
var red_cooldown_label : Label
var purple_cooldown_label : Label
var domain_cooldown_label : Label


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Access the UI labels within the UI hierarchy
	blue_cooldown_label = ui.get_node("Control/MarginContainer/VBoxContainer/HBoxContainer/Panel/Panel/blue_cooldown")
	red_cooldown_label = ui.get_node("Control/MarginContainer/VBoxContainer/HBoxContainer/Panel/Panel2/red_cooldown")
	purple_cooldown_label = ui.get_node("Control/MarginContainer/VBoxContainer/HBoxContainer/Panel/Panel3/purple_cooldown")
	domain_cooldown_label = ui.get_node("Control/MarginContainer/VBoxContainer/HBoxContainer/Panel/Panel4/domain_cooldown")

func _process(delta):
	# Reset jump status when the character lands
	if is_on_floor():
		is_jumping = false
		
	if Input.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	# Update cooldown timers
	blue_cooldown_timer = max(0, blue_cooldown_timer - delta)
	red_cooldown_timer = max(0, red_cooldown_timer - delta)
	purple_cooldown_timer = max(0, purple_cooldown_timer - delta)
	domain_cooldown_timer = max(0, domain_cooldown_timer - delta)
	# Update UI labels with remaining cooldown times
	blue_cooldown_label.text = "Blue Cooldown: " + str(int(blue_cooldown_timer))
	red_cooldown_label.text = "Red Cooldown: " + str(int(red_cooldown_timer))
	purple_cooldown_label.text = "Purple Cooldown: " + str(int(purple_cooldown_timer))
	domain_cooldown_label.text = "Domain Cooldown: " + str(int(domain_cooldown_timer))

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
	if Input.is_action_just_pressed("technique_purple") and purple_cooldown_timer == 0:
		technique_purple()
		purple_cooldown_timer = technique_purple_cooldown
		
	# for domain expansion
	if Input.is_action_just_pressed("domain_expansion") and domain_cooldown_timer == 0:
		domain_expansion()
		domain_cooldown_timer = domain_expansion_cooldown

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
	if purple:  # Check if purple scene is instantiated
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
		
		# using tween to make red and blue merge
		var tween_red = get_tree().create_tween()
		var tween_blue = get_tree().create_tween()
		tween_red.tween_property(red_instance, "position", mid, 3.0)
		tween_blue.tween_property(blue_instance, "position", mid, 3.0)
		
		var purple_sound: AudioStream = preload("res://Sounds/purple_sfx.mp3")
		var purple_theme: AudioStream = preload("res://Sounds/purple_theme.mp3")
		
		if not audio_player.playing:
			audio_player.stream = purple_sound
			audio_player.play()
		
		# just to remove red and blue after 5 seconds
		await get_tree().create_timer(3).timeout
		red_instance.queue_free()
		blue_instance.queue_free()
		
		# create the purple instance
		get_parent().add_child(purple_instance)
		
	else:
		print("Error: Purple scene not loaded")
		
signal domain_instance_ready
func domain_expansion():
	# instantiate domain
	var domain_instance = domain.instantiate()
	
	domain_instance.connect("ready", _on_domain_ready)
	
	# spawn it where player is and move upwards
	domain_instance.global_transform.origin = pov.global_transform.origin+ pov.global_transform.basis.y * 150
	
	# move player up as well
	player.global_transform.origin += pov.global_transform.basis.y * 150
	
	get_parent().add_child(domain_instance)
	
func _on_domain_ready():
	print("Domain instance is ready")
	emit_signal("domain_instance_ready")

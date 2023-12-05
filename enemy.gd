extends CharacterBody3D

var player = null

var SPEED = 5.0
var health = 100.0

var is_hit = false
var hit_timer = 0.0
var hit_duration = 1.0  

@export var player_path : NodePath
@onready var nav_agent : NavigationAgent3D = $NavigationAgent3D
@onready var enemy = $"."  # Make sure this is the correct path to the enemy node
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node(player_path)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if health <= 0:
		purple_hit()
		
	if not is_hit:
		# Calculate normal navigation movement
		nav_agent.set_target_position(player.global_transform.origin)
		var next_nav_point = nav_agent.get_next_path_position()
		velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
		move_and_slide()

	if is_hit:
		hit_timer += delta
		if hit_timer >= hit_duration:
			is_hit = false
			hit_timer = 0.0
			

func _physics_process(delta):
	# To add gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	move_and_slide()

func red_hit():
	if not is_hit:
		is_hit = true
		health -= 25

		# Stop the navigation agent by setting the target_position to the current position
		nav_agent.set_target_position(global_transform.origin)
		
		# Calculate the direction vector from player to enemy
		var direction_to_player = (player.global_transform.origin - global_transform.origin).normalized()

		# Apply a push force in the opposite direction of the player
		enemy.global_transform.origin += direction_to_player * -10 
		
func blue_hit():
	if not is_hit:
		health -= 25
		is_hit = true
		hit_duration = 3

		# Stop the navigation agent by setting the target_position to the current position
		nav_agent.set_target_position(global_transform.origin)
		
		
func purple_hit():
	queue_free()








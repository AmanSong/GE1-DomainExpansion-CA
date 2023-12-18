extends Node3D

@export var HEALTH = 100
@onready var HEALTH_BAR = $CanvasLayer/Control/MarginContainer/VBoxContainer/HBoxContainer/Panel/ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
#	$"../NavigationRegion3D/monster".connect("damage_taken", _on_damage_taken)
	HEALTH_BAR.value = HEALTH
	connect_to_existing_monsters()
	
func _process(delta):
	connect_to_existing_monsters()

func _on_damage_taken(DAMAGE):
	# Reduce health by the specified damage
	HEALTH -= DAMAGE
	HEALTH_BAR.value = HEALTH
	print("Person's health:", HEALTH)

# Function to connect to the damage_taken signal of existing monsters
func connect_to_existing_monsters():
	var monster_region = $"../NavigationRegion3D"

	for i in range(monster_region.get_child_count()):
		var monster_instance = monster_region.get_child(i)

		# Check if the signal exists before attempting to connect
		if monster_instance.has_signal("damage_taken") and !monster_instance.is_connected("damage_taken", _on_damage_taken):
			monster_instance.connect("damage_taken", _on_damage_taken)






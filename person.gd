extends Node3D

@export var HEALTH = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	$"../NavigationRegion3D/monster".connect("damage_taken", _on_damage_taken)
	
func _process(delta):
	pass

func _on_damage_taken(DAMAGE):
	# Reduce health by the specified damage
	HEALTH -= DAMAGE
	print("Person's health:", HEALTH)

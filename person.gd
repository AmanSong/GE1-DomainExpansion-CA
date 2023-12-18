extends Node3D

@export var HEALTH = 100
@onready var HEALTH_BAR = $CanvasLayer/Control/MarginContainer/VBoxContainer/HBoxContainer/Panel/ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready():
	$"../NavigationRegion3D/monster".connect("damage_taken", _on_damage_taken)
	HEALTH_BAR.value = HEALTH
	
func _process(delta):
	pass

func _on_damage_taken(DAMAGE):
	# Reduce health by the specified damage
	HEALTH -= DAMAGE
	HEALTH_BAR.value = HEALTH
	print("Person's health:", HEALTH)

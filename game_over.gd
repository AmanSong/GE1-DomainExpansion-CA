extends Node2D

var final_score : int 

# Called when the node enters the scene tree for the first time.
func _ready():
	print('GAME OVER')
	print(final_score)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

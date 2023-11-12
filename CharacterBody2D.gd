extends CharacterBody2D

var eyeOpen = false
var timer = null
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if my_global.get_reachedBottom() == true:
		get_node("AnimatedSprite2D").play("Blink")
	else:
		get_node("AnimatedSprite2D").play("Closed")
		


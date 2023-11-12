extends CharacterBody2D

var SPEED= 25
var timer = null #timer for fish random behavior

func _ready():
	get_node("AnimatedSprite2D").play("Idle")
	
	timer = Timer.new()
	add_child(timer)
	
	timer.connect("timeout", self._on_Timer_timeout)
	timer.set_wait_time(1)
	timer.set_one_shot(false) # Make sure it loops
	timer.start()
	
func _physics_process(delta): # Called every frame. 'delta' is the elapsed time since the previous frame.
	move_and_slide()

	
func _on_Timer_timeout():
	var random_number = randi()% 4
	if random_number == 0:
		get_node("AnimatedSprite2D").flip_h = true
		velocity.x = 1 * SPEED/5
	if random_number == 1:
		get_node("AnimatedSprite2D").flip_h = false
		velocity.x = -1 * SPEED/5
	if random_number == 3:
		velocity.y = -1 * SPEED/5
	if random_number == 4:
		velocity.y = -1 * SPEED/5

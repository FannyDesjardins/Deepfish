extends CharacterBody2D

var SPEED= 100
var player
var chase = false
var chaseDirection
var continueChase = false

var timer = null #timer for fish random behavior
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	#get_node("AnimatedSprite2D").play("Idle")
	
	timer = Timer.new()
	add_child(timer)
	
	timer.connect("timeout", self._on_Timer_timeout)
	timer.set_wait_time(2)
	timer.set_one_shot(false) # Make sure it loops
	timer.start()


func _physics_process(delta): # Called every frame. 'delta' is the elapsed time since the previous frame.
	if chase == true:
		player = get_node("../../Player/Player")
		var direction = (player.position - self.position).normalized()
		if direction.x > 0:
			get_node("AnimatedSprite2D").flip_h = true;
		else: 
			get_node("AnimatedSprite2D").flip_h = false;
		velocity.x = direction.x * SPEED
		chaseDirection = direction
	if continueChase == true:
		velocity.x = chaseDirection.x * SPEED
	move_and_slide()

func _on_Timer_timeout():
	var random_number = randi()% 2
	if random_number == 0:
		get_node("AnimatedSprite2D").flip_h = true
		velocity.x = 1 * SPEED/5
	else:
		get_node("AnimatedSprite2D").flip_h = false
		velocity.x = -1 * SPEED/5





func _on_hit_zone_body_entered(body):
	if body.name == "Player" && get_node("../../Player/Player").immune == false:
		get_node("../../Player/Player").immune = true
		get_node("../../Player/Player").inHitZone = true


func _on_player_detection_body_entered(body):
	if body.name == "Player":
		chase = true


func _on_player_detection_body_exited(body):
	if body.name == "Player":
		chase = false
		continueChase = true


func _on_hit_zone_body_exited(body):
	if body.name == "Player":
		get_node("../../Player/Player").inHitZone = false

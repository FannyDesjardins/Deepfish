extends CharacterBody2D


var SPEED= 100
var player
var chase = false

var chaseTimer
var chaseTimerOn = false
var idleTimer
var idleTimerOn = false
var timer = null #timer for fish random behavior

func _ready():
	get_node("AnimatedSprite2D").play("Idle")
	
	timer = Timer.new()
	add_child(timer)
	
	timer.connect("timeout", self._on_Timer_timeout)
	timer.set_wait_time(2.5)
	timer.set_one_shot(false) # Make sure it loops
	timer.start()

func _physics_process(delta): # Called every frame. 'delta' is the elapsed time since the previous frame.
		
	if chase == true && chaseTimerOn == true:
		player = get_node("../../Player/Player")
		var direction = (player.position - self.position).normalized()
		if direction.x > 0:
			get_node("AnimatedSprite2D").flip_h = true;
		else: 
			get_node("AnimatedSprite2D").flip_h = false;
		velocity.x = direction.x * SPEED
		velocity.y = direction.y * SPEED
	#else:
	#	velocity.x = 0
	#	velocity.y = 0
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
		



func _on_player_detection_body_entered(body):
	if body.name == "Player":
		if chaseTimerOn == false && idleTimerOn == false:
			chase = true;
			
			chaseTimer = Timer.new()
			add_child(chaseTimer)
			chaseTimer.connect("timeout", self._on_Chase_Timer_timeout)
			chaseTimer.set_wait_time(1)
			chaseTimer.set_one_shot(true) # Make sure it loops
			chaseTimer.start()
			
			chaseTimerOn = true
			

func _on_Chase_Timer_timeout():
	chaseTimerOn = false
	chase = false
	
	idleTimer = Timer.new()
	add_child(idleTimer)
	idleTimer.connect("timeout", self._on_Idle_Timer_timeout)
	idleTimer.set_wait_time(2)
	idleTimer.set_one_shot(true) # Make sure it loops
	idleTimer.start()
	idleTimerOn = true

func _on_Idle_Timer_timeout():
	idleTimerOn = false

func _on_player_detection_body_exited(body):
	if body.name == "Player":
		chase = false;


func _on_hit_zone_body_entered(body):
	if body.name == "Player" && get_node("../../Player/Player").immune == false:
		get_node("../../Player/Player").immune = true
		get_node("../../Player/Player").inHitZone = false


func _on_hit_zone_body_exited(body):
	if body.name == "Player":
		get_node("../../Player/Player").inHitZone = false

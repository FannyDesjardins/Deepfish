extends CharacterBody2D

var health = 3
var immune = false

var timerImmunity
var timerImmunityStarted = false

var flashTimer
var flashOn = false 

var inHitZone = false

const SPEED = 150.0 #control speed moving left right
const JUMP_VELOCITY = -200.0

#@onready var my_global = get_node("/root/global")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim = get_node("AnimationPlayer")
@onready var cam = get_node("Camera2D")

#func _ready():
#	player_vars.set_reachedBottom(false)

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
		
	if my_global.get_reachedBottom() == false:
		if immune==true && timerImmunityStarted == false:
			_get_hurt()
		
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta
			anim.play("Fall")

		# Handle Jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			
			velocity.y = JUMP_VELOCITY
			anim.play("Jump")

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
			if direction > 0:
				get_node("AnimatedSprite2D").flip_h = false;
			else: 
				get_node("AnimatedSprite2D").flip_h = true;
			if velocity.y == 0:
				anim.play("Walk")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if velocity.y == 0:
				anim.play("Idle")

	move_and_slide()
	
func flash():
	if timerImmunityStarted == true:
		if flashOn == false:
			get_node("AnimatedSprite2D").material.set_shader_parameter("flash_modifier",1)
			flashTimer = Timer.new()
			add_child(flashTimer)
			flashTimer.connect("timeout", self._on_FlashTimer_timeout)
			flashTimer.set_wait_time(0.1)
			flashTimer.set_one_shot(true) # false if it loop
			flashTimer.start()
			flashOn = true
		else:
			flashTimer = Timer.new()
			add_child(flashTimer)
			flashTimer.connect("timeout", self._on_FlashTimer_timeout)
			flashTimer.set_wait_time(0.1)
			flashTimer.set_one_shot(true) # false if it loop
			flashTimer.start()
			flashOn = false
	
func _on_immune_timeout():
	immune = false
	timerImmunityStarted = false
	if inHitZone == true:
		_get_hurt()
	
	#timerHitCounter = 0

func _get_hurt():
		immune = true
		health-=1
		$roblox_oof.play()
		if health ==0:
			get_tree().change_scene_to_file("res://game_over.tscn")
		timerImmunity = Timer.new()
		add_child(timerImmunity)
		timerImmunity.connect("timeout", self._on_immune_timeout)
		timerImmunity.set_wait_time(2)
		timerImmunity.set_one_shot(true) # false if it loops
		timerImmunity.start()
		timerImmunityStarted = true
	
		flash()

		
func _on_FlashTimer_timeout():
	if immune==true:
		if flashOn == true:
			get_node("AnimatedSprite2D").material.set_shader_parameter("flash_modifier",0)
		flash()


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		cam.set_position(Vector2(0,-250))
		$eldritch.play()
		self.hide()
		$CollisionShape2D.disabled = true
		#cam.current = false
		
		my_global.set_reachedBottom(true)
		

extends CharacterBody2D

const SPEED = 150.0 #control speed moving left right
@onready var anim = get_node("AnimatedSprite2D")
#@onready var cam = get_node("Camera2D")

#@onready var player_vars = get_node("/root/global")

func _ready():
	$CollisionShape2D.disabled = true
	self.hide()
	#cam.current = true
	

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if my_global.get_reachedBottom() == true:
		self.show()
		$CollisionShape2D.disabled = false
		#cam.current = true
		
		var directionx = Input.get_axis("ui_left", "ui_right")
		
		if directionx:
			velocity.x = directionx * SPEED
			if directionx > 0:
				get_node("AnimatedSprite2D").flip_h = false;
			else: 
				get_node("AnimatedSprite2D").flip_h = true;
			#if velocity.y == 0:
			#	anim.play("Walk")
		var directiony = Input.get_axis("ui_up", "ui_down")
		if directiony:
			velocity.y = directiony * SPEED
			
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.y = move_toward(velocity.x, 0, SPEED)
			if velocity.y == 0 && velocity.x == 0:
				anim.play("Idle")

	move_and_slide()


#func _on_area_2d_body_entered(body):
#	if body.name == "Player":
#		self.set_process(true)
#		self.show()
#		$CollisionShape2D.disabled = false
	

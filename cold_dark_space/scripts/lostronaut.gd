extends Area2D

signal hit #collision signal

signal exited_viewport

@export var speed = 400
var thrust = speed/1.5
var screen_size # Size of the game window.
#moved this here so speed momentum carries over the frames
var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide_jets()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("move_right"):
		velocity.x += thrust
		ion_jet("right")
	if Input.is_action_pressed("move_left"):
		velocity.x -= thrust
		ion_jet("left")
	if Input.is_action_pressed("move_up"):
		velocity.y -= thrust
		ion_jet("up")
	if Input.is_action_pressed("move_down"):
		velocity.y += thrust
		ion_jet("down")
	
	#make jet disappear when key released
	#and also pause animation
	if Input.is_action_just_released("move_right"):
		$ion_jet_right.hide()
		$AnimatedSprite2D.pause()
	if Input.is_action_just_released("move_left"):
		$ion_jet_left.hide()
		$AnimatedSprite2D.pause()
	if Input.is_action_just_released("move_up"):
		$ion_jet_up.hide()
		$AnimatedSprite2D.pause()
	if Input.is_action_just_released("move_down"):
		$ion_jet_down.hide()
		$AnimatedSprite2D.pause()
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		#playing audio doesn't work here
		#audio should be played from main node or somewhere else
		#where it does work
		#$jetloop.play()
	else:
		#i dont thing this ever happens
		hide_jets()
	
	position.x = wrapf(position.x, 0, screen_size.x)
	position.y = wrapf(position.y, 0, screen_size.y)
	
	position += velocity * delta
	
	# Check if player is at the screen boundary and emit the exit signal
	if position.x <= 0 or position.x >= screen_size.x or position.y <= 0 or position.y >= screen_size.y:
		emit_signal("exited_viewport")
	
	#keeps player from flying away. We may need to remove this
	#position = position.clamp(Vector2.ZERO, screen_size)

#shows ion jet animation depending on which direction you're moving
func ion_jet(direction:String):
	$AnimatedSprite2D.play()
	match direction:
		"left":
			$ion_jet_left.show()
			$ion_jet_left.play()
		"right":
			$ion_jet_right.show()
			$ion_jet_right.play()
		"down":
			$ion_jet_down.show()
			$ion_jet_down.play()
		"up":
			$ion_jet_up.show()
			$ion_jet_up.play()
		_:
			print("you did something wrong this should never happen")

#self explanatory
func hide_jets():
	$jetloop.stop()
	$ion_jet_down.hide()
	$ion_jet_left.hide()
	$ion_jet_right.hide()
	$ion_jet_up.hide()

func player_init(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	

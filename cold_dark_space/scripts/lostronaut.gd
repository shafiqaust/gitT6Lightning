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
	
# Handle the collision when a CharacterBody2D enters the Area2D
func _on_body_entered(body):
	if body is CharacterBody2D:
		print("Collision detected with:", body.name)
		emit_signal("hit", body)  # Emit custom hit signal for further handling


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
	else:
		hide_jets()

	# Update position with velocity and delta time
	position += velocity * delta

	# Wrap position and signal exit if wrapping occurs
	var wrapped_x = wrapf(position.x, 0, screen_size.x)
	var wrapped_y = wrapf(position.y, 0, screen_size.y)

	# Detect if wrapping occurred
	if wrapped_x != position.x or wrapped_y != position.y:
		position = Vector2(wrapped_x, wrapped_y)
		emit_signal("exited_viewport")  # Notify enemy of screen wrap
	else:
		position = Vector2(wrapped_x, wrapped_y)
	
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
	

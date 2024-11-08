extends Area2D

signal hit #collision signal
signal exited_viewport

@export var speed = 400
var thrust = speed / 1.5
var screen_size  # Size of the game window.
var can_take_damage = true  # Flag to control damage intake
var damage_cooldown = 0.5  # Half a second cooldown
var velocity = Vector2.ZERO  # Moved here so speed momentum carries over frames
var fast_mode = false  # Flag to track if player is in fast mode
var is_invisible = false  # Flag to track if player is invisible

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide_jets()

# Handle the collision when a CharacterBody2D enters the Area2D
func _on_body_entered(body):
	if body is CharacterBody2D and can_take_damage:
		emit_signal("hit", body)
		can_take_damage = false  # Disable further damage
		await get_tree().create_timer(damage_cooldown).timeout
		can_take_damage = true  # Reset to allow future damage

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
	
	# Make jet disappear when key released
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

	# Toggle fast mode with space
	if Input.is_action_just_pressed("space"):
		toggle_speed()

	# Toggle invisibility with 'v' button
	if Input.is_action_just_pressed("v"):
		toggle_invisibility()

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	else:
		hide_jets()

	# Update position with velocity and delta time
	position += velocity * delta

	# Wrap position and signal exit if wrapping occurs
	var wrapped_x = wrapf(position.x, 0, screen_size.x)
	var wrapped_y = wrapf(position.y, 0, screen_size.y)

	if wrapped_x != position.x or wrapped_y != position.y:
		position = Vector2(wrapped_x, wrapped_y)
		emit_signal("exited_viewport")
	else:
		position = Vector2(wrapped_x, wrapped_y)

# Shows ion jet animation depending on which direction you're moving
func ion_jet(direction: String):
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
			print("Unexpected direction:", direction)

# Hide all jets
func hide_jets():
	$jetloop.stop()
	$ion_jet_down.hide()
	$ion_jet_left.hide()
	$ion_jet_right.hide()
	$ion_jet_up.hide()

# Initialize player position and state
func player_init(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

# Toggle speed between normal and fast mode
func toggle_speed():
	if fast_mode:
		speed = 400
		thrust = speed / 1.5
		fast_mode = false
	else:
		speed = 800
		thrust = speed / 1.5
		fast_mode = true

# Toggle visibility to simulate invisibility
func toggle_invisibility():
	is_invisible = !is_invisible
	visible = not is_invisible  # Toggle the visibility of the player
	$CollisionShape2D.disabled = is_invisible  # Disable collision when invisible

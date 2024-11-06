extends CharacterBody2D

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var lostronaut = get_parent().get_node("lostronaut")  # Adjust this path if needed

@export var speed = 100

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@export var screen_size = Vector2(1148, 645)  # Adjust to your game window size

var player_chase = true

func _ready() -> void:
	set_physics_process(false)
	call_deferred("wait_for_physics")
	collision_shape.position = Vector2.ZERO
	

	# Connect to the player's exited_viewport signal
	var player = get_parent().get_node("lostronaut")  # Adjust if the player node has a different name
	if lostronaut == null:
		print("Error: 'lostronaut' node not found in parent.")
	else:
		print("Lostronaut found:", lostronaut)
		# Connect the viewport exit signal if not connected
		lostronaut.connect("exited_viewport", Callable(self, "_on_player_exited_viewport"))

# This function will run when the player exits and re-enters the screen
func _on_player_exited_viewport() -> void:
	randomize()  # Ensure randomness
	position = Vector2(
		randf_range(0, screen_size.x), 
		randf_range(0, screen_size.y)
	)
	
func wait_for_physics():
	await get_tree().physics_frame
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	if player_chase:
		position += (lostronaut.position - position) / speed
	
	

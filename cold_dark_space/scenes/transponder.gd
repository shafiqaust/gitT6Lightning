extends Area2D

#signal to emit when player collides and wins the game
signal win

var ray_cast: RayCast2D = null  # Initialize or type the variable
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@export var screen_size = Vector2(1148, 645)  # Adjust to your game window size

func _ready() -> void:
	collision_shape.position = Vector2.ZERO
	ray_cast = RayCast2D.new()
	add_child(ray_cast)
	ray_cast.position = Vector2.ZERO
	ray_cast.enabled = true
	ray_cast.collide_with_areas = true

	# Connect to the player's exited_viewport signal
	var player = get_parent().get_node("lostronaut")  # Adjust if the player node has a different name
	player.connect("exited_viewport", Callable(self, "_on_player_exited_viewport"))

# This function will run when the player exits and re-enters the screen
func _on_player_exited_viewport() -> void:
	randomize()  # Ensure randomness
	position = Vector2(
		randf_range(0, screen_size.x), 
		randf_range(0, screen_size.y)
	)

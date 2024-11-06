extends CharacterBody2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@export var screen_size = Vector2(1148, 645)  # Adjust to your game window size

func _ready() -> void:
	collision_shape.position = Vector2.ZERO
	
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

#func _input(event: InputEvent) -> void:
	#if event.is_action_released("ui_left"):
		#var shape = Polygon2D.new()
		#get_parent().add_child(shape)
		#shape.color = Color.RED
	#elif event.is_action_released("ui_right"):
		#self.position = get_global_mouse_position()

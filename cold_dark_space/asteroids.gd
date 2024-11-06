extends AnimatableBody2D

var ray_cast: RayCast2D = null  # Initialize or type the variable
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	collision_shape.position = Vector2.ZERO
	ray_cast = RayCast2D.new()
	add_child(ray_cast)
	ray_cast.position = Vector2.ZERO
	ray_cast.enabled = true
	ray_cast.collide_with_areas = true


func _input(event: InputEvent) -> void:
	if event.is_action_released("ui_left"):
		var shape = Polygon2D.new()
		get_parent().add_child(shape)
		shape.color = Color.RED
	elif event.is_action_released("ui_right"):
		self.position = get_global_mouse_position()

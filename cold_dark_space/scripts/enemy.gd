extends CharacterBody2D

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@export var lostronaut: Area2D

@export var speed = 1


#func _physics_process(delta: float) -> void:
	#navigation_agent_2d.target_position = lostronaut.global_position
	#velocity = global_position.direction_to(navigation_agent_2d.get_next_path_position()) * speed
	#move_and_slide()

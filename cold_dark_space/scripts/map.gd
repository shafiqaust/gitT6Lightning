extends Node2D

@export var tilemap: TileMap # Reference to the TileMap node
@export var tile_ids: Array[int] = [0, 1, 2, 3, 4] # Array of tile IDs to place randomly
@export var tile_count: int = 5 # Number of random tiles to place
@export var cell_size: Vector2 = Vector2(16, 16) # Set to 16x16 tile size
@export var lostronaut: Area2D
var life = 3
var score = 0
var best = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.text = "Find the transponder"
	$ScoreTimer.start()
	# $Area2D.connect("placed", Callable($TileMap, "on_area2D_placed"))
	if tilemap == null:
		tilemap = $TileMap # Ensure tilemap is assigned, adjust the path if necessary
	randomize_tile_positions()
	
	 ## Connect the body_entered signal
	#$lostronaut.connect("body_entered", Callable(self, "_on_lostronaut_body_entered"))
	
	  # Connect the hit signal from lostronaut to _on_lostronaut_hit function
	#$lostronaut.connect("hit", Callable(self, "_on_lostronaut_hit"))
	
	#added a way to escape the game while playing
func _process(delta: float) -> void:
	if Input.is_action_pressed("pause"):
		get_tree().change_scene_to_file("res://scenes/options.tscn")
		

# Method to randomize the positions of all tiles
func randomize_tile_positions() -> void:
	if tilemap == null:
		print("TileMap node is not assigned.")
		return

	if tile_ids.is_empty():
		print("tile_ids array is empty; please add tile IDs to use.")
		return

		#tilemap.clear_all_cells() # Clear all existing tiles

	# Use the manually defined cell size
	var screen_size = get_viewport_rect().size

	# Calculate the number of cells in x and y directions based on the viewport and cell size
	var cells_x = int(screen_size.x / cell_size.x)
	var cells_y = int(screen_size.y / cell_size.y)

	# Place random tiles in random positions within the grid
	for i in range(tile_count):
		var random_tile_id = tile_ids[randi_range(0, tile_ids.size() - 1)]
		var random_x = randi_range(0, cells_x - 1)
		var random_y = randi_range(0, cells_y - 1)
		tilemap.set_cell(0, Vector2i(random_x, random_y), random_tile_id)

# Call this function when the player exits the viewport
func _on_lostronaut_exited_viewport() -> void:
	randomize_tile_positions()
	$Label.text = "Find the transponder"
 
func _on_sound_pressed():
	if $AudioStreamPlayer.playing:
		$AudioStreamPlayer.stop()
		$TextureButton.texture_normal = load("res://scenes/mute-sound.png")
		
	else:
		$AudioStreamPlayer.play()
		$TextureButton.texture_normal = load("res://scenes/sound_new.png")

#1 out of 10 chance of transponder working
func _on_transponder_area_exited(area: Area2D) -> void:
	var working = randi()%10 
	if working == 9:
		show_message("You Won!!")
		$Label.text = "Yayyy!!"
		# Wait until the MessageTimer has counted down.
		await $MessageTimer.timeout
		$Message.hide()
		# Make a one-shot timer and wait for it to finish.
		await get_tree().create_timer(1.0).timeout
		new_game()
	else:
		$Label.text = "Transponder doesn't work..."

# Wrapper function to handle the signal with an argument
func _on_lostronaut_hit(body):
		life_lost()

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout
	$Message.hide()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	new_game()
	
		
func life_lost() -> void:
	life -= 1
	$LifeLabel.text = str("Lives: ", life)
	if (life <= 0):
		game_over()

func game_over() -> void:
	if (score > best):
		best = score
	#$BestScore.text = str("Best:\n", best)
	$ScoreTimer.stop()
	show_game_over()
	$lostronaut/CollisionShape2D.set_deferred("disabled", true)
	
func new_game():
	if get_tree():
		get_tree().reload_current_scene()
	else:
		print("Error: Scene tree is not available.")
	score = 0
	life = 3
	#$lostronaut.start($StartPosition.position)
	$lostronaut/CollisionShape2D.set_deferred("disabled", false)
	$ScoreTimer.start()
	$ScoreLabel.text = str("Timer: ", score)
	$LifeLabel.text = str("Lives: ", life)
	show_message("Get Ready")
	
	
func _on_score_timer_timeout():
	score += 1
	$ScoreLabel.text = str("Timer: ", score)
	await $MessageTimer.timeout
	$Message.hide()

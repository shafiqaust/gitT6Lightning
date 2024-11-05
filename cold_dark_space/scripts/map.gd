extends Node2D

@export var tilemap: TileMap # Reference to the TileMap node
@export var tile_ids: Array[int] = [0, 1, 2, 3, 4] # Array of tile IDs to place randomly
@export var tile_count: int = 5 # Number of random tiles to place
@export var cell_size: Vector2 = Vector2(16, 16) # Set to 16x16 tile size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if tilemap == null:
		tilemap = $TileMap # Ensure tilemap is assigned, adjust the path if necessary
	randomize_tile_positions()

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
func on_player_exit_viewport() -> void:
	print("called")
	randomize_tile_positions()
	
	



 
func _on_sound_pressed():
	if $AudioStreamPlayer.playing:
		$AudioStreamPlayer.stop()
		$TextureButton.texture_normal = load("res://scenes/mute-sound.png")
		
	else:
		$AudioStreamPlayer.play()
		$TextureButton.texture_normal = load("res://scenes/sound_new.png")

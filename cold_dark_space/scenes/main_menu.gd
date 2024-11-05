extends Control


func _ready() -> void:
	pass





func _on_start_game_pressed():
	get_tree().change_scene_to_file("res://scenes/map.tscn")



func _on_options_pressed():
	get_tree().change_scene_to_file("res://scenes/options.tscn")




func _exit_pressed():
	get_tree().quit()

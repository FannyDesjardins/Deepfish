extends Node2D

func _ready():
	get_node("Play").visible = false
	get_node("Quit").visible = false

func _process(delta):
	if $sound.playing==false:
		$sound.play()
	if $bubbles.playing==false:
		$bubbles.play()
		
	if my_global.get_reachedBottom() == true:
		get_node("Play").visible = true
		get_node("Quit").visible = true


func _on_play_pressed():
	my_global.set_reachedBottom(false)
	get_tree().reload_current_scene()


func _on_quit_pressed():
	get_tree().quit()

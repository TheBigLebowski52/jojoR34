extends Area2D

@export var surface_type: String = "default"  

func _process(delta):
	var player = get_tree().get_root().get_node("Player")
	if player and self.overlaps_body(player):
		player.current_surface = surface_type

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.current_surface = surface_type

func _on_body_exited(body):
	if body.is_in_group("player"):
		body.current_surface = "default"

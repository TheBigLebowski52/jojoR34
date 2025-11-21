extends Area2D

@export_file("*.tscn") var target_scene: String
@export var spawn_point_name: String 

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		Global.next_spawn = spawn_point_name
		get_tree().change_scene_to_file(target_scene)

extends Area2D

@onready var message: Label = $"../../Player/Camera2D/DialogueLayer/Label"
@onready var player: CollisionShape2D = $"../../Player/CollisionShape2D"


var triggered : bool = false

func _on_body_entered(player):
	if triggered == false:
		triggered = true
		message.text = "You wouldn't steal a car"
		message.modulate.a = 1.0
		await get_tree().create_timer(2).timeout
		var tween = get_tree().create_tween()
		tween.tween_property(message, "modulate:a", 0.0, 1.0)  # fade out in 1 secondo
		await tween.finished
		message.text = ""

extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var message: Label = $"../../Player/Camera2D/DialogueLayer/Label"

var triggered: bool = false

func _ready():
	# collega il segnale body_entered usando un Callable
	self.body_entered.connect(Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if triggered:
		return
	
	if body.name == "Player":
		triggered = false
		GameManager.char1_hp -= 100  
		animated_sprite.play("new_animation")
		if GameManager.char1_sat < GameManager.char1_maxSat:
			GameManager.char1_sat += 10
		elif GameManager.char1_sat >= GameManager.char1_maxSat:
			message.text = (GameManager.char1_name + " puked all the food on the ground")
			message.modulate.a = 1.0
			await get_tree().create_timer(2).timeout
			var tween = get_tree().create_tween()
			tween.tween_property(message, "modulate:a", 0.0, 1.0)  # fade out in 1 secondo
			await tween.finished
			message.text = ""

extends Area2D

var triggered: bool = false

func _ready():
	# collega il segnale body_entered usando un Callable
	self.body_entered.connect(Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if triggered:
		return
	
	if body.name == "Player":
		GameManager.area = 0
		GameManager.room = 0

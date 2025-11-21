extends Node2D

@onready var minchia_fa_buio: CanvasModulate = $"minchia fa buio"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	minchia_fa_buio.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

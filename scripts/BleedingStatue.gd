extends StaticBody2D

@onready var dialogue : NinePatchRect = get_node("/root/Game/Player/Camera2D/DialogueLayer/Dialogo")
@onready var label : Label = dialogue.get_node("Label")



func _ready():
	add_to_group("save")
	randomize()
	if dialogue == null:
		print ("si ma porcoddio")

func save():
	get_tree().paused = true
	dialogue.visible = true
	await type_text(label, "Mark your sins in blood and memory?")

func type_text(label: Label, full_text: String, speed: float = 0.01) -> void:
	label.text = ""
	for i in full_text.length():
		label.text += full_text[i]
		await get_tree().create_timer(speed).timeout

func _input(event):
	if get_tree().paused and event.is_action_pressed("interact") and is_in_group("save"):
		label.visible = false
		label.text = ""
		#opt1.visible = true
		#opt1.text = "Save"
		#opt2.visible = true
		#opt2.text = "Leave"
		#

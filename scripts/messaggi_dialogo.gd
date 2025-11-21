extends Area2D

@onready var dialogue: NinePatchRect = get_node("/root/Silvera's Gates/Player/Camera2D/DialogueLayer/Dialogo")
@onready var label: Label = get_node("/root/Silvera's Gates/Player/Camera2D/DialogueLayer/Dialogo/Label")
@onready var type_sound: AudioStreamPlayer = get_node("/root/Silvera's Gates/Player/Camera2D/DialogueLayer/Dialogo/TypeSound")

var dialogue_lines := [
	"You got so far, why go back?",
]
var dialogue_index: int = 0
var awaiting_input: bool = false
var typing: bool = false
var dialogue_locked: bool = false  
var typing_speed: float = 0.02

func _ready():
	randomize()
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))


func _on_body_entered(body):
	if not body.is_in_group("player"):
		return

	#se il dialogo è ancora li allora non fare niente
	if dialogue_locked:
		return

	dialogue_locked = true
	_start_dialogue()

# quando esci ci puoi parlare di nuovo
func _on_body_exited(body):
	if body.is_in_group("player"):
		dialogue_locked = false

func _start_dialogue():
	if dialogue.visible or typing or awaiting_input:
		return

	dialogue_index = 0
	get_tree().paused = true
	dialogue.visible = true
	await _show_next_line()

func _input(event):
	if not dialogue.visible:
		return
	
	if event.is_action_pressed("skip_dialogue") and typing:
		typing_speed = 0.005
	
	if get_tree().paused and event.is_action_pressed("interact"):
		if typing:
			label.text = dialogue_lines[dialogue_index]
			typing = false
			awaiting_input = true
		elif awaiting_input:
			dialogue_index += 1
			if dialogue_index < dialogue_lines.size():
				await _show_next_line()
			else:
				await _end_dialogue()

func _end_dialogue():
	get_tree().paused = false
	dialogue.visible = false
	label.text = ""
	awaiting_input = false
	dialogue_index = 0
	typing = false

func _show_next_line():
	awaiting_input = false
	await type_text(label, dialogue_lines[dialogue_index])
	awaiting_input = true

func type_text(label_t: Label, full_text: String, speed: float = 0.0) -> void:
	label_t.text = ""
	typing = true
	if speed <= 0:
		speed = typing_speed
	for i in full_text.length():
		if not typing:
			break
		label_t.text += full_text[i]
		var c := full_text[i]
		if c != " " and c != "\n" and c != "\t":
			if type_sound.playing:
				type_sound.stop()
			type_sound.play()
		await get_tree().create_timer(speed).timeout
	typing = false
	awaiting_input = true

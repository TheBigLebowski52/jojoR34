extends Area2D

# PARAMETRI ESPORTATI 
@export var npc_name: String = "" 
@export var initial_dialogue_lines: Array[String] = [
	"A massive wooden door stands in front of you",
	"You can't see any lock or handle",
	"Maybe there's a way to break it?",
]

@export var repeat_dialogue: String = "Now fuck off"
@export var typing_speed: float = 0.02
@export var dialogue_repeatable: bool = false


# RIFERIMENTI 
@onready var dialogue: NinePatchRect = Global.dialogue
@onready var label: Label = Global.dialogue_label
@onready var type_sound: AudioStreamPlayer = Global.dialogue_sound

# VARIABILI DI STATO 
var talked: bool = false
var dialogue_index : int = 0
var awaiting_input : bool = false
var typing : bool = false
var dialogue_just_finished : bool = false
var dialogue_finished: bool = false


# READY 
func _ready():
	add_to_group("npc")
	randomize()
	

# INTERACTION 
func interact():
	if dialogue.visible or typing or awaiting_input or dialogue_just_finished:
		return

	if dialogue_repeatable:
		dialogue_finished = false

	if not dialogue_finished or dialogue_repeatable:
		if not talked or dialogue_repeatable:
			talked = true
			dialogue_index = 0
			get_tree().paused = true
			dialogue.visible = true
			await _show_next_line()
	else:
		get_tree().paused = true
		dialogue.visible = true
		label.text = ""
		await type_text(label, repeat_dialogue)
		awaiting_input = true



# INPUT 
func _input(event):
	if not dialogue.visible:
		return
	
	if event.is_action_pressed("skip_dialogue") and typing:
		typing_speed = 0.005
	
	if get_tree().paused and event.is_action_pressed("interact"):
		if typing:
			# Quando premi E mentre scrive, mostra subito tutta la frase corrente
			label.text = initial_dialogue_lines[dialogue_index]
			typing = false
			awaiting_input = true

		elif awaiting_input:
			if dialogue_finished:
				_end_dialogue()
			else:
				dialogue_index += 1
				if dialogue_index < initial_dialogue_lines.size():
					await _show_next_line()
				else:
					_end_dialogue()



# END DIALOGUE 
func _end_dialogue():
	get_tree().paused = false
	dialogue.visible = false
	label.text = ""
	awaiting_input = false
	dialogue_index = 0
	typing = false

	if not dialogue_finished:
		dialogue_finished = true

	dialogue_just_finished = true
	await get_tree().create_timer(0.1).timeout
	dialogue_just_finished = false


# SHOW NEXT 
func _show_next_line():
	awaiting_input = false
	await type_text(label, initial_dialogue_lines[dialogue_index])
	awaiting_input = true


# TYPEWRITER 
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

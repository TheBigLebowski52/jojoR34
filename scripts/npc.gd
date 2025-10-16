extends CharacterBody2D

@onready var dialogue := get_node("/root/Game/Player/Camera2D/Dialogo")
@onready var label : Label = dialogue.get_node("Label")
@onready var type_sound: AudioStreamPlayer = get_node("/root/Game/Player/Camera2D/Dialogo/TypeSound")

var talked: bool = false #divena true quando ci ho già parlato
var dialogue_lines := [ #primo dialogo
	"Ayo, take this mushroom",
	"No?",
	"Your loss.",
	"I'm going to fuck you in the ass so hard you will forget your own name, you will only feel pain, a pain so intense, that it will esare your own identity and humanity"
]
var dialogue_index : int = 0 #tiene traccia della battuta che sta mostrando
var awaiting_input : bool = false #diventa true se aspetta che il player prema per andare avanti
var typing : bool = false #true se la battuta si sta ancora srivendo
var dialogue_just_finished : bool = false #impedisce di parlare subito dopo
var dialogue_finished: bool = false #true quando finisce di blaterare
var typing_speed: float = 0.02

func _ready():
	add_to_group("npc")
	randomize()


func interact():
	#il dialogo è visibile, sta ancora scrivendo, sta aspettando input, ha appena finito di parlare
	#sta fermo, non fa un cazzo
	if dialogue.visible or typing or awaiting_input or dialogue_just_finished:
		return

	#non ha ancora finito il dialogo principale
	if not dialogue_finished: 
		if not talked: #interagisce per la prima volta
			talked = true
			dialogue_index = 0
			get_tree().paused = true
			dialogue.visible = true
			await _show_next_line()
	
	#dialogo post dialogo
	else: 
		get_tree().paused = true
		dialogue.visible = true
		label.text = ""
		await type_text(label, "Now fuck off")
		awaiting_input = true


#
func _input(event):
	#controlla gli input solo se il gioco è in pausa
	if not dialogue.visible:
		return
	
	if event.is_action_pressed("skip_dialogue") and typing:
		typing_speed = 0.005
	
	if get_tree().paused and event.is_action_pressed("interact"):
		if typing:
			# Se sta ancora scrivendo, mostra tutta la frase
			if dialogue_finished:
				label.text = "Now fuck off"
			else:
				label.text = dialogue_lines[dialogue_index]
			typing = false
			awaiting_input = true
		#ha finito di scrivere ad è il turno del player
		elif awaiting_input:
			if dialogue_finished:
				_end_dialogue()
			else:
				dialogue_index += 1
				if dialogue_index < dialogue_lines.size():
					await _show_next_line()
				else:
					_end_dialogue()



func _end_dialogue():
	#fa ripartire il gioco
	get_tree().paused = false
	dialogue.visible = false
	label.text = ""
	awaiting_input = false
	dialogue_index = 0
	typing = false
	talked = true

	#segna che il dialogo principale è finito
	if not dialogue_finished:
		dialogue_finished = true  # Non più dialogo principale

	#impedisce di riattivare il dialogo subito dopo
	dialogue_just_finished = true
	await get_tree().create_timer(0.1).timeout
	dialogue_just_finished = false

#mostra la prossima linea crivendola lettera per lettera
func _show_next_line():
	awaiting_input = false
	await type_text(label, dialogue_lines[dialogue_index])
	awaiting_input = true

#effetto typewriter
func type_text(label_t: Label, full_text: String, speed: float = 0.0) -> void:
	label_t.text = ""
	typing = true
	if speed <= 0:
		speed = typing_speed
	for i in full_text.length():
		if not typing:
			break
		label_t.text += full_text[i]
	
		# Play sound for letters
		var c := full_text[i]
		if c != " " and c != "\n" and c != "\t":
			if type_sound.playing:
				type_sound.stop()
			type_sound.play()

		await get_tree().create_timer(speed).timeout

	typing = false
	awaiting_input = true

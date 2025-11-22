extends CharacterBody2D

@onready var dialogue := get_node("/root/Game/Player/Camera2D/DialogueLayer/Dialogo")
@onready var label : Label = dialogue.get_node("Label")
@onready var choice_box : Control = dialogue.get_node("ChoiceBox") # Finestra con le scelte
@onready var yes: Button = get_node("/root/Game/Player/Camera2D/DialogueLayer/Dialogo/ChoiceBox/PanelContainer/VBoxContainer/yes")
@onready var no: Button = get_node("/root/Game/Player/Camera2D/DialogueLayer/Dialogo/ChoiceBox/PanelContainer/VBoxContainer/no")
@onready var type_sound: AudioStreamPlayer = get_node("/root/Game/Player/Camera2D/DialogueLayer/Dialogo/TypeSound")
var is_active_speaker: bool = false


var talked: bool = false #diventa true quando ci ho già parlato
var dialogue_lines := [ #primo dialogo
	"Want some company?",
]
var dialogue_index : int = 0 #tiene traccia della battuta che sta mostrando
var awaiting_input : bool = false #diventa true se aspetta che il player prema per andare avanti
var typing : bool = false #true se la battuta si sta ancora scrivendo
var dialogue_just_finished : bool = false #impedisce di parlare subito dopo
var dialogue_finished: bool = false #true quando finisce di blaterare

var typing_speed: float = 0.02

var in_choice: bool = false
var selected_choice: int = 0 # 0 = Yes, 1 = No

func _ready():
	add_to_group("npc")
	randomize()
	if choice_box:
		choice_box.visible = false

func interact():
	# Non fa nulla se il dialogo è visibile o in fase di scrittura/input
	if dialogue.visible or typing or awaiting_input or dialogue_just_finished:
		return

	if not dialogue_finished: 
		if not talked: # prima interazione
			is_active_speaker = true
			talked = true
			dialogue_index = 0
			get_tree().paused = true
			dialogue.visible = true
			await _show_next_line()

# Gestione input
func _input(event):
	if not dialogue.visible or not is_active_speaker:
		return
	if event.is_action_pressed("interact"):
		print("Input rilevato: typing=", typing, ", awaiting=", awaiting_input, ", in_choice=", in_choice)


	# ... resto del codice uguale ...
	if get_tree().paused and not in_choice and event.is_action_pressed("interact"):
		if typing:
			# Mostra tutta la frase se ancora in scrittura
			label.text = dialogue_lines[dialogue_index]
			typing = false
			awaiting_input = true
		elif awaiting_input:
			dialogue_index += 1
			if dialogue_index < dialogue_lines.size():
				await _show_next_line()
			else:
				_show_choices() # Finito dialogo principale → mostra scelte
	elif in_choice:
		_handle_choice_input(event)

# Gestione scelte
func _handle_choice_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_s") or event.is_action_pressed("ui_left"):
		selected_choice = clamp(selected_choice - 1, 0, 1)
		_update_choice_highlight()
	elif event.is_action_pressed("move_n") or event.is_action_pressed("ui_right"):
		selected_choice = clamp(selected_choice + 1, 0, 1)
		_update_choice_highlight()
	elif event.is_action_pressed("interact"):
		_resolve_choice()

func _update_choice_highlight() -> void:
	if selected_choice == 0:
		yes.modulate = Color(1, 1, 1)
		no.modulate = Color(0.6, 0.6, 0.6)
	else:
		yes.modulate = Color(0.6, 0.6, 0.6)
		no.modulate = Color(1, 1, 1)

func _show_choices() -> void:
	in_choice = true
	awaiting_input = false
	choice_box.visible = true
	selected_choice = 0
	_update_choice_highlight()

func _resolve_choice() -> void:
	in_choice = false
	choice_box.visible = false
	label.text = ""

	if selected_choice == 0:
		await type_text(label, "Alright, let's go then.")
	else:
		await type_text(label, "Suit yourself.")

	await get_tree().create_timer(0.5).timeout
	_end_dialogue()

# Fine dialogo
func _end_dialogue():
	is_active_speaker = false
	get_tree().paused = false
	dialogue.visible = false
	label.text = ""
	awaiting_input = false
	dialogue_index = 0
	typing = false
	talked = true
	dialogue_finished = true
	dialogue_just_finished = true
	await get_tree().create_timer(0.1).timeout
	dialogue_just_finished = false

# Mostra la prossima linea con typewriter
func _show_next_line():
	awaiting_input = false
	await type_text(label, dialogue_lines[dialogue_index])
	awaiting_input = true

# Effetto typewriter
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
		if type_sound and c != " " and c != "\n" and c != "\t":
			if type_sound.playing:
				type_sound.stop()
			type_sound.play()
		await get_tree().create_timer(speed).timeout

	typing = false
	awaiting_input = true

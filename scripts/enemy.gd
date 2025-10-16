extends CharacterBody2D

@onready var player: CharacterBody2D = get_node("/root/Game/Player")
@onready var vision: Node = $vision
@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var areac: Area2D = $"area combatt_"
@onready var raycasts := [
	$vision/ray1, $vision/ray2, $vision/ray3, $vision/ray4,
	$vision/ray5, $vision/ray6, $vision/ray7
]

const PATROL_SPEED: int = 50
const CHASE_SPEED: int = 100
var speed: int = PATROL_SPEED

var path_points: Array = [
	Vector2(-320, -1280),
	Vector2(320, -1280),
	Vector2(320, -1152),
	Vector2(-320, -1152)
]
var current_point := 0

var chasing := false
var chase_timeout := 10.0
var chase_timer := 0.0

var angles_deg = [-45, -30, -15, 0, 15, 30, 45]
var length = 320.0

func _ready():
	vision.position = Vector2.ZERO
	for ray in raycasts:
		ray.enabled = true

	nav.velocity_computed.connect(_on_velocity_computed)
	nav.path_desired_distance = 4
	nav.target_desired_distance = 4
	areac.body_entered.connect(_on_body_entered)

	# Imposta il primo punto di pattuglia
	nav.target_position = path_points[current_point]

func _physics_process(delta):
	if _sees_player():
		chasing = true
		chase_timer = chase_timeout
		nav.target_position = player.global_position
	else:
		if chasing:
			chase_timer -= delta
			if chase_timer <= 0:
				chasing = false
				_set_next_patrol_target()

	if chasing:
		nav.target_position = player.global_position

	# Muovi lungo il path usando il NavigationAgent2D
	if not nav.is_navigation_finished():
		var next_pos = nav.get_next_path_position()
		var dir = _get_cardinal_direction(next_pos - global_position)
		velocity = dir * (CHASE_SPEED if chasing else PATROL_SPEED)
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		if not chasing:
			_advance_patrol()

	var dir = (player.global_position - global_position).normalized() if chasing else (path_points[current_point] - global_position).normalized()
	update_raycast_cone(dir)

func _advance_patrol():
	# Quando raggiunge il punto, passa al successivo
	var dist = global_position.distance_to(path_points[current_point])
	if dist < 8:
		current_point = (current_point + 1) % path_points.size()
	_set_next_patrol_target()

func _set_next_patrol_target():
	nav.target_position = path_points[current_point]

func update_raycast_cone(facing_direction: Vector2):
	var base_angle = facing_direction.angle()
	for i in range(raycasts.size()):
		var angle = base_angle + deg_to_rad(angles_deg[i])
		var offset = Vector2(cos(angle), sin(angle)) * length
		raycasts[i].position = Vector2.ZERO
		raycasts[i].target_position = offset

func _sees_player() -> bool:
	for ray in raycasts:
		if ray.is_colliding():
			var collider = ray.get_collider()
			if collider and collider.is_in_group("player"):
				return true
	return false

func _on_body_entered(body):
	if body.is_in_group("player"):
		print("i got your ass")

func _get_cardinal_direction(dir: Vector2) -> Vector2:
	dir = dir.normalized()
	if abs(dir.x) > abs(dir.y):
		return Vector2(sign(dir.x), 0)
	else:
		return Vector2(0, sign(dir.y))


func _on_velocity_computed(safe_velocity: Vector2):
	# Usiamo il safe_velocity solo per sicurezza
	velocity = _get_cardinal_direction(safe_velocity) * speed

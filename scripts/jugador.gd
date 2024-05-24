extends CharacterBody3D


@onready var animated_sprite = $CanvasLayer/Linterna/AnimatedSprite2D
@onready var ray_cast = $RayCast3D
@onready var sonido_linterna = $SonidoLinterna

const SPEED = 5.0
const MOUSE_SENS = 0.2

var dead = false
var linterna_off = true

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event):
	if dead:
		return
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * MOUSE_SENS
		
	
	
func _process(delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
		
	if Input.is_action_just_pressed("flashlight"):
		flashlight()
	if dead:
		return
	


func _physics_process(delta):
	if dead:
		return
	var input_dir = Input.get_vector("move-left", "move-right", "move-forward", "move-backwards")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()
	
func flashlight():
	if linterna_off:
		animated_sprite.play("Prendida")
		sonido_linterna.play()
	elif !linterna_off:
		animated_sprite.play("Apagada")
		sonido_linterna.play()

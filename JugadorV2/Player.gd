extends CharacterBody3D

@onready var head = $Head
@onready var head_x = $Head/HeadXRotation
@onready var flashlight = $Flashlight
@onready var flashlight_light = $Flashlight/FlashLightMesh/SpotLight
@onready var flashlight_sound = $Flashlight/FlashLightMesh/FlashlightSound
@onready var anim_tree = $Head/HeadXRotation/Camera/AnimationTree

var sensitivity = -0.1
var anim_blend: float = 0.0

const SPEED = 2.0
const FLASHLIGHT_FOLLOW_SPEED = 15.0
const ANIM_SMOOTHING_SPEED = 8.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

func _input(event):
	if event is InputEventMouseMotion:
		head.rotation_degrees.y += sensitivity * event.relative.x
		head_x.rotation_degrees.x += sensitivity * event.relative.y
		head_x.rotation_degrees.x = clamp(head_x.rotation_degrees.x, -89, 89)
		
	if Input.is_action_just_pressed("flashlight"):
			flashlight_light.visible = !flashlight_light.visible
			flashlight_sound.play()


func _process(delta: float) -> void:
	make_flashlight_follow(delta)
	
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	
	var head_basis = head.get_global_transform().basis
	velocity = Vector3.ZERO
	
	if Input.is_action_pressed("move-forward"):
		velocity -= head_basis.z
	elif Input.is_action_pressed("move-backwards"):
		velocity += head_basis.z
	if Input.is_action_pressed("move-left"):
		velocity -= head_basis.x
	elif Input.is_action_pressed("move-right"):
		velocity += head_basis.x
		
	velocity = velocity.normalized() * SPEED
	move_and_slide()
	
	anim_blend = lerp(anim_blend, velocity.length(), delta * ANIM_SMOOTHING_SPEED)
	anim_tree.set("parameters/blend_position", anim_blend)


func make_flashlight_follow(delta):
	flashlight.rotation.y = lerp(flashlight.rotation.y, head.rotation.y, delta * FLASHLIGHT_FOLLOW_SPEED)
	flashlight.rotation.x = lerp(flashlight.rotation.x, head_x.rotation.x, delta * FLASHLIGHT_FOLLOW_SPEED)

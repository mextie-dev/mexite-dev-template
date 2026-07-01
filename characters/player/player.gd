extends CharacterBody3D

@onready var head: Node3D = $Head

@onready var camera_3d: Camera3D = $Head/Camera3D
@onready var interact_cast: RayCast3D = $Head/Camera3D/InteractCast

@export var speed = 5

var mouseSensitivity := 0.25

@onready var input_dir




func _ready() -> void:
	
	# capture the mouse and initialize the input direction vector idk why im doing this here but whatever
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	

## manage opening inventory screen, also every time input is pressed run a raycast scan instead of doing it every fram
# (i have no idea if this is faster but hopefully it is because it causes a lot of bugs but i dont wanna refactor it)
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("escape"):
		fullscreen()
	if Input.is_action_just_pressed("show_mouse"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

		
	pass





func fullscreen():
	var fs = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	if fs:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


## i put all the actual player input and mouse movement in unhandledinput becuase i thought it would fix a bug but it didnt
## however it didnt hurt anything so whateverrrrrrrrrrrrrrrrrrrrr
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * mouseSensitivity
		head.rotation_degrees.x -= event.relative.y * mouseSensitivity
		head.rotation_degrees.x = clamp(head.rotation_degrees.x, -75, 75)

	
	
	

## do phisicks
func _physics_process(delta: float) -> void:
	
	input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Get the input direction and handle the movement/deceleration.
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = (direction.x * speed)
		velocity.z = (direction.z * speed)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	# this makes the moving train part work
	get_platform_velocity()

	move_and_slide()

## gets the raycast collider on interaction and passes it to different places based on what it is
func raycastScans():
	pass
	#if isInDialogue:
		#return
	#if optionsOpen:
		#return
	#var currentCollider = interact_cast.get_collider()
	#if interact_cast.is_colliding():
		#if currentCollider.is_in_group("items"):
			#interactedWithItem.emit(currentCollider)
			##await Engine.get_main_loop().process_frame
		#if currentCollider.is_in_group("doors"):
			#print("hitting door")
			#interactedWithDoor.emit(currentCollider)
		#if currentCollider.is_in_group("characters"):
			#print("hitting character")
			#interactedWithChar.emit(currentCollider)
			#get_tree().paused = true

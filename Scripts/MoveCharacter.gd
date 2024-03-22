extends CharacterBody2D
var gravity : Vector2
@export var jump_height : float ## How high should they jump?
@export var movement_speed : float ## How fast can they move?
@export var horizontal_air_coefficient : float ## Should the player move more slowly left and right in the air? Set to zero for no movement, 1 for the same
@export var speed_limit : float ## What is the player's max speed? 
@export var friction : float ## What friction should they experience on the ground?

# Called when the node enters the scene tree for the first time.
func _ready():
	#set's the gravity constant to move at velocity of 100 down.
	gravity = Vector2(0, 100)
	pass # Replace with function body.

#function the is called to handle input
func _get_input():
	#if the godot bot is on the floor
	if is_on_floor():
		#if the players presses the left arrow key while on the floor
		if Input.is_action_pressed("move_left"):
			#add the godot bot's movement speed to its current movement velocity in the left direction
			velocity += Vector2(-movement_speed,0)

		#if the players presses the right arrow key while on the floor
		if Input.is_action_pressed("move_right"):
			#add the godot bot's movement speed to its current movement velocity in the left direction
			velocity += Vector2(movement_speed,0)

		#if the player presses the space button while on the floor
		if Input.is_action_just_pressed("jump"): # Jump only happens when we're on the floor (unless we want a double jump, but we won't use that here)
			#add 1 speed to right and the jump_height moving up - it's negative because origin is at the top of the game
			velocity += Vector2(1,-jump_height)

	#if the godot bot is in the air
	if not is_on_floor():
		#if the left arrow key is pressed while the godot bot is in the air
		if Input.is_action_pressed("move_left"):
			#add the godot bot's movement speed, multiplied by air friction, to the left direction
			velocity += Vector2(-movement_speed * horizontal_air_coefficient,0)

		#if the right arrow key is pressed while the godot bot is in the air
		if Input.is_action_pressed("move_right"):
			# add the godot bot's movement speed, multiplied by air friction, to the right direction
			velocity += Vector2(movement_speed * horizontal_air_coefficient,0)

func _limit_speed():
	#if the godot bot is traveling too fast in the right direction
	if velocity.x > speed_limit:
		#set the speed to the fastest defined velocity in the right direction
		velocity = Vector2(speed_limit, velocity.y)
		
	#if the godot bot is traveling too fast in the left direction
	if velocity.x < -speed_limit:
		#set the speed to the fastest defined velocity in the left direction
		velocity = Vector2(-speed_limit, velocity.y)

func _apply_friction():
	#if the godotbot is on the floor and the user is not moving the bot in the left or right direction
	if is_on_floor() and not (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")):
		#slow down the godot bots horizontal movement based on the current speed multiplied by the defined friction value
		velocity -= Vector2(velocity.x * friction, 0)
		#if the speed of the godot bot is less than 5
		if abs(velocity.x) < 5:
			#set the godot bot's horizontal velocity to 0
			velocity = Vector2(0, velocity.y) # if the velocity in x gets close enough to zero, we set it to zero

func _apply_gravity():
	#if the godot bot is in the air
	if not is_on_floor():
		#change the vertical speed by the negative velocity caused by gravity
		velocity += gravity

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#call a function to handle the user input
	_get_input()
	#call a function to set the speed to the max defined speed if it is too high
	_limit_speed()
	#call a function to apply friction to the godot bot, kinetic if it's moving fast and static if it's slow
	_apply_friction()
	#call a function to apply gravity when the godot bot is in the air
	_apply_gravity()

	#godot collision response
	move_and_slide()
	pass

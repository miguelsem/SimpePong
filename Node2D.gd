extends Node2D

# Member variables
var screen_size
var pad_size
var direction_value = 1.0
var direction = Vector2(direction_value, 0.0)
var count_left = 0
var count_right = 0
var gameType

# Constant for ball speed (in pixels/second)
const INITIAL_BALL_SPEED = 100
# Speed of the ball (also in pixels/second)
var ball_speed = INITIAL_BALL_SPEED
# Constant for pads speed
const PAD_SPEED = 150

func _ready():
    screen_size = get_viewport_rect().size
    pad_size = get_node("left").get_texture().get_size()
    # Initial score
    get_node("scoreboard/score").set_text('0  -  0')
    #set_process(true)

func _process(delta):
    var ball_pos = get_node("ball").get_pos()
    var left_rect = Rect2( get_node("left").get_pos() - pad_size*0.5, pad_size )
    var right_rect = Rect2( get_node("right").get_pos() - pad_size*0.5, pad_size )
    # Integrate new ball position
    ball_pos += direction * ball_speed * delta
    # Flip when touching roof or floor
    if ((ball_pos.y < 0 and direction.y < 0) or (ball_pos.y > screen_size.y and direction.y > 0)):
        direction.y = -direction.y

    # Flip, change direction and increase speed when touching pads
    if ((left_rect.has_point(ball_pos) and direction.x < 0) or (right_rect.has_point(ball_pos) and direction.x > 0)):
        direction.x = -direction.x
        direction.y = randf()*2.0 - 1
        direction = direction.normalized()
        ball_speed *= 1.1
    # Check gameover
    if (ball_pos.x < 0 or ball_pos.x > screen_size.x):
        ball_pos = screen_size*0.5
        ball_speed = INITIAL_BALL_SPEED
        direction = Vector2(-1, 0)
        if (ball_pos.x < 0):
            count_left += 1
        else:
            count_right += 1
        get_node("scoreboard/score").set_text(str(count_left) + '  -  ' + str(count_right) )
    get_node("ball").set_pos(ball_pos)
    # Move left pad
    var left_pos = get_node("left").get_pos()
    if (left_pos.y > 0 and Input.is_action_pressed("left_move_up")):
        left_pos.y += -PAD_SPEED * delta
    if (left_pos.y < screen_size.y and Input.is_action_pressed("left_move_down")):
        left_pos.y += PAD_SPEED * delta
    get_node("left").set_pos(left_pos)
    # Move right pad
    var right_pos = get_node("right").get_pos()
    if gameType:
        if (right_pos.y > 0 and Input.is_action_pressed("right_move_up")):
            right_pos.y += -PAD_SPEED * delta
        if (right_pos.y < screen_size.y and Input.is_action_pressed("right_move_down")):
            right_pos.y += PAD_SPEED * delta
    else:
        var ball_pos = get_node("ball").get_pos()
        var ai_speed =  PAD_SPEED/2*(ball_speed/INITIAL_BALL_SPEED)
        if (right_pos.y - ball_pos.y) > 0:
            right_pos.y += - ai_speed * delta
        else:
            right_pos.y += ai_speed * delta
    get_node("right").set_pos(right_pos)
    if Input.is_action_pressed("ui_cancel"):
        showButtons()
        set_process(false)


func _on_1player_button_down():
	runInitializations()
	hideButtons()
	var gameType = false
	set_process(true)

func _on_2player_button_down():
	runInitializations()
	hideButtons()
	var gameType = true
	set_process(true)


func _on_continue_button_down():
	hideButtons()
	set_process(true)

func runInitializations():
	#direction = Vector2(1.0, 0.0)
	direction_value = randi()%2+1
	if direction_value == 2:
		direction_value = -1.0;
	direction = Vector2(direction_value, 0.0)
	count_left = 0
	count_right = 0
	# Constant for ball speed (in pixels/second)
	INITIAL_BALL_SPEED = 100
	# Speed of the ball (also in pixels/second)
	ball_speed = INITIAL_BALL_SPEED
	# Constant for pads speed
	PAD_SPEED = 150
	
	get_node("ball").set_pos( Vector2(320, 188) )
	get_node("left").set_pos( Vector2(67, 183) )
	get_node("right").set_pos( Vector2(577, 183) )

func hideButtons():
	get_node("1player").set_hidden(true)
	get_node("2player").set_hidden(true)
	get_node("continue").set_hidden(true)
	get_node("tutorial").set_hidden(true)
	get_node("separator").set_hidden(false)
	get_node("scoreboard").set_hidden(false)

func showButtons():
	get_node("1player").set_hidden(false)
	get_node("2player").set_hidden(false)
	get_node("continue").set_hidden(false)
	get_node("tutorial").set_hidden(false)
	get_node("separator").set_hidden(true)
	get_node("scoreboard").set_hidden(true)


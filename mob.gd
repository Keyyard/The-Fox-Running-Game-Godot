extends CharacterBody2D


const SPEED = 100.0
const JUMP_STRENGTH = 400.0
var jump_counter = 0.0
var player
var chase = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	velocity.y += gravity * delta
	player = get_node("../../Player/Player")
	var direction = (player.position - self.position).normalized()
	if $AnimatedSprite2D.animation != "death":
		if chase:
			jump_counter += delta
			if jump_counter > 1.0 and is_on_floor():
				velocity.y = -JUMP_STRENGTH
				jump_counter = 0.0

			if is_on_floor():
				velocity.x = 0  # Stop horizontal movement when on the ground
			else:
				velocity.x = direction.x * SPEED  # Move horizontally only while jumping
				$AnimatedSprite2D.play("jump")
				if direction.x > 0:
					$AnimatedSprite2D.flip_h = true
				else:
					$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.play("idle")
	move_and_slide()


func _on_player_detects_body_entered(body):
	if body.name == "Player":
		chase = true

func _on_player_detects_body_exited(body):
	if body.name == "Player":
		chase = false

func _on_dead_body_entered(body):
	if body.name == "Player":
		$AnimatedSprite2D.play("death")
		await $AnimatedSprite2D.animation_finished
		self.queue_free()


func _on_players_dead_zone_body_entered(body):
	if body.name == "Player":
		body.disable_movement()

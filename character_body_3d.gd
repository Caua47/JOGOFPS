extends CharacterBody3D
const decal_spr = preload("res://decal.tscn")


const SPEED = 3

func _physics_process(delta: float) -> void:
	var direcao = Input.get_vector("esquerda", "direita", "cima", "baixo") * SPEED
	velocity = Vector3(direcao.x, velocity.y, direcao.y).rotated(Vector3.UP, $"%CharacterBody3D/character-male-f/Camera3D".rotation.y)
	var forward = -%CharacterBody3D.transform.basis.z
	var right = %CharacterBody3D.transform.basis.x
	var move_dir = (right * direcao.x) + (forward * direcao.y)
	velocity.x = move_dir.x
	velocity.z = move_dir.z
	move_and_slide()

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		%CharacterBody3D.rotation.y += -event.relative.x * 0.01
		$"%CharacterBody3D/character-male-f/Camera3D".rotation.x += -event.relative.y * 0.01
		$"%CharacterBody3D/character-male-f/Camera3D".rotation.x = clamp($"%CharacterBody3D/character-male-f/Camera3D".rotation.x, deg_to_rad(-30), deg_to_rad(60))

func atirar_raio_da_camera_fps(mouse_pos: Vector2):
	var camera = get_viewport().get_camera_3d()
	var origin = camera.project_ray_origin(mouse_pos)
	var end = origin + camera.project_ray_normal(mouse_pos) * 1000
	var space_state = get_world_3d().direct_space_state

	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.exclude = [%CharacterBody3D]

	var result = space_state.intersect_ray(query)

	if result.is_empty():
		return null
	else:
		return result

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		atirar_projetil(event.position)

func atirar_projetil(from):
	var alvo = atirar_raio_da_camera_fps(from)
	if alvo != null:
		if alvo.collider.has_method("dano"):
			alvo.collider.dano(50)
		var dcl = decal_spr.instantiate()
		get_parent().add_child(dcl)
		dcl.global_position = alvo.position + (alvo.normal * 0.01)
		dcl.look_at(alvo.position + alvo.normal, Vector3.UP, true)

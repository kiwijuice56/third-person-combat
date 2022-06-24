@tool
extends EditorScript

var psx_shader_path: Shader = load("res://main/shader/psx_shader.gdshader")

func _run():
	var nodes: Array[Node] = get_scene().get_children()
	while len(nodes) > 0:
		var node: Node = nodes.pop_back()
		for child in node.get_children():
			nodes.append(child)
		
		### Set loop animations ###
		if node is AnimationPlayer:
			var anim: AnimationPlayer = node as AnimationPlayer
			for animation in anim.get_animation_list():
				if animation.ends_with("-loop"):
					print(anim, " " + animation + " set to loop ")
					anim.get_animation(animation).set_loop(true)
		
		if node.get("mesh") == null:
			continue
		
		#### Apply PSX shader ###
		var textures: Array[Texture] = []
		# get automatically imported textures
		for i in range(node.mesh.get_surface_count()):
			var material: StandardMaterial3D = node.mesh.surface_get_material(i) as StandardMaterial3D
			if material == null: 
				continue
			textures.append(material.albedo_texture)
		# create shader materials and apply the textures with the psx shader
		for i in range(node.mesh.get_surface_count()):
			var shader_material: ShaderMaterial = ShaderMaterial.new()
			shader_material.shader = psx_shader_path.duplicate()
			node.set_surface_override_material(i, shader_material)
			if textures[i] == null: 
				continue
			node.get_surface_override_material(i).set_shader_param("albedo", textures[i])
		print(node, " applied PSX shader")

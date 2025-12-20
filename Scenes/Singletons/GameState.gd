extends Node
var active_player=null
var active_id=1
var active_object=null

func set_active_object(node):
	if node!=active_object:
		for object in ObjectFactory.get_all_objects():
			object.active_object_changed(node)
		active_object=node

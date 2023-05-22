/// @description Load room data
__EZRE_ROOM_FILE	= $"{__EZRE_ROOMS_PATH}\\{room_get_name(room)}\\{room_get_name(room)}.yy";

if (get_size(__EZRE_EDIT_INSTANCES_AVAILABLE) == 0) {
	var _file = file_text_open_read(__EZRE_ROOM_FILE);
	var _str = file_text_read_whole(_file);
	file_text_close(_file);
	var _json = json_parse(_str);
	var _layers = _json[$ "layers"];
	var _instance_layers = [];

	for (var i = 0; i < get_size(_layers); i++) {
		if (_layers[i][$ "resourceType"] == "GMRInstanceLayer") {
			array_push(_instance_layers, _layers[i]);
		}
	}

	for (var i = 0; i < get_size(_instance_layers); i++) {
		var _layer = _instance_layers[i];
		for (var j = 0; j < get_size(_layer[$ "instances"]); j++) {
			var _inst = _layer[$ "instances"][j];
			__EZRE_EDIT_INSTANCES_AVAILABLE[$ _inst[$ "name"]] = {
				data: _inst,
				inst_in_room_id: ezRoomEditor_core_get_instance_id(
					_inst[$ "objectId"][$ "name"],
					_inst[$ "x"],
					_inst[$ "y"]
				),
			};
		
			var _inst_id = __EZRE_EDIT_INSTANCES_AVAILABLE[$ _inst[$ "name"]][$ "inst_in_room_id"];
			if (_inst_id == noone) {
				struct_remove(__EZRE_EDIT_INSTANCES_AVAILABLE, _inst[$ "name"]);
				continue;
			}
		
			var _inst_is_editable = variable_instance_get(_inst_id, "__EZRE_IS_EDITABLE");
			if (!_inst_is_editable) {
				struct_remove(__EZRE_EDIT_INSTANCES_AVAILABLE, _inst[$ "name"]);
				continue;
			}
		
			_inst_id.__EZRE_EDIT_CONST_ID = _inst[$ "name"];
			_inst_id.__EZRE_EDIT_ACTIVE = true;
		}
	}
}
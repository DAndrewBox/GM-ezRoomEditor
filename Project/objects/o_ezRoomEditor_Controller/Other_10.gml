/// @description Load room data
__EZRE_ROOM_FILE	= $"{__EZRE_ROOMS_PATH}\\{room_get_name(room)}\\{room_get_name(room)}.yy";

if (get_size(__EZRE_EDIT_INSTANCES_AVAILABLE) == 0) {
	instance_activate_all();
	var _file = file_text_open_read(__EZRE_ROOM_FILE);
	var _str = file_text_read_whole(_file);
	file_text_close(_file);
	var _json = json_parse(_str);
	var _layers = _json[$ "layers"];
	var _instance_layers = [];
	var _layers_len = get_size(_layers);

	for (var i = 0; i < _layers_len; i++) {
		if (_layers[i][$ "resourceType"] == "GMRInstanceLayer") {
			array_push(_instance_layers, _layers[i]);
		}
	}

	var _inst_layers_len = get_size(_instance_layers);
	for (var i = 0; i < _inst_layers_len; i++) {
		var _layer = _instance_layers[i];
		var _inst_len = get_size(_layer[$ "instances"]);
		for (var j = 0; j < _inst_len; j++) {
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
		
			var _inst_is_editable = variable_instance_get(_inst_id, "__EZRE_IS_EDITABLE") ?? false;
			if (!_inst_is_editable) {
				struct_remove(__EZRE_EDIT_INSTANCES_AVAILABLE, _inst[$ "name"]);
				continue;
			}
		
			_inst_id.__EZRE_EDIT_CONST_ID = _inst[$ "name"];
			_inst_id.__EZRE_EDIT_ACTIVE = true;
			_inst_id.__EZRE_EDIT_CREATION_CODE =
				_inst[$ "hasCreationCode"]
				? ezRoomEditor_core_get_creation_code(_inst[$ "name"])
				: false;
		}
	}
} else {
	var _instances = ezRoomEditor_core_get_editable_instances_ids();
	var _inst_len = get_size(_instances);
	for (var i = 0; i < _inst_len; i++) {
		if (!instance_exists(_instances[i])) continue;
		_instances[i].__EZRE_EDIT_ACTIVE = true;
	}
}
/// @description Save room file
var _file = file_text_open_read(__EZRE_ROOM_FILE);
var _str = file_text_read_whole(_file);
file_text_close(_file);
var _json = json_parse(_str);
var _layers = _json[$ "layers"];
var _instance_layers_index = [];
var _layers_len = get_size(_layers);

for (var i = 0; i < _layers_len; i++) {
	if (_layers[i][$ "resourceType"] == "GMRInstanceLayer") {
		array_push(_instance_layers_index, i);
	}
}

var _inst_layers_len = get_size(_instance_layers_index);
for (var i = 0; i < _inst_layers_len; i++) {
	var _layer = _layers[_instance_layers_index[i]];
	var _instances = _layer[$ "instances"];
	var _edited_instances_keys = struct_keys(__EZRE_EDIT_INSTANCES_AVAILABLE);
	var _edited_inst_keys_len = get_size(_edited_instances_keys);
		
	for (var j = 0; j < _edited_inst_keys_len; j++) {
		var _inst_name = _edited_instances_keys[j];
		var _insts_len = get_size(_instances);

		for (var k = 0; k < _insts_len; k++) {
			if (_instances[k][$ "name"] != _inst_name) continue;
			_json[$ "layers"][_instance_layers_index[i]][$ "instances"][k] = __EZRE_EDIT_INSTANCES_AVAILABLE[$ _inst_name][$ "data"];
		}
	}
}
	
_file = file_text_open_write(__EZRE_ROOM_FILE);
_str  = json2yy(_json);
file_text_write_string(_file, _str);
file_text_close(_file);
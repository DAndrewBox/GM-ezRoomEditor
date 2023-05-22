/// @description Save room file
var _file = file_text_open_read(__EZRE_ROOM_FILE);
var _str = file_text_read_whole(_file);
file_text_close(_file);
var _json = json_parse(_str);
var _layers = _json[$ "layers"];
var _instance_layers_index = [];

for (var i = 0; i < get_size(_layers); i++) {
	if (_layers[i][$ "resourceType"] == "GMRInstanceLayer") {
		array_push(_instance_layers_index, i);
	}
}
	
for (var i = 0; i < get_size(_instance_layers_index); i++) {
	var _layer = _layers[_instance_layers_index[i]];
	var _instances = _layer[$ "instances"];
	var _edited_instances_keys = struct_keys(__EZRE_EDIT_INSTANCES_AVAILABLE);
		
	for (var j = 0; j < get_size(_edited_instances_keys); j++) {
		var _inst_name = _edited_instances_keys[j];
			
		for (var k = 0; k < get_size(_instances); k++) {
			if (_instances[k][$ "name"] != _inst_name) continue;
			_instances[k] = __EZRE_EDIT_INSTANCES_AVAILABLE[$ _inst_name][$ "data"];
		}
	}
}
	
_file = file_text_open_write(__EZRE_ROOM_FILE);
_str  = json2yy(_json);
file_text_write_string(_file, _str);
file_text_close(_file);
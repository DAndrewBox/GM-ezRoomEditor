/// @description Deactivate Edit Mode
var _instances = ezRoomEditor_core_get_editable_instances_ids();
var _inst_len = get_size(_instances);
for (var i = 0; i < _inst_len; i++) {
	if (!instance_exists(_instances[i])) continue;
	_instances[i].__EZRE_EDIT_ACTIVE = false;
}
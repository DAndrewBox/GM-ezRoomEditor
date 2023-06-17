/// @func	ezRoomEditor_set_as_editable_object()
function ezRoomEditor_set_as_editable_object() {
	__EZRE_IS_EDITABLE	  = true;
	
	__EZRE_EDIT_CONST_ID = "";
	__EZRE_EDIT_ACTIVE   = true;
	__EZRE_EDIT_VARIABLES = [];
	__EZRE_EDIT_IGNORED	 = [];
	__EZRE_CURSOR_GRAB	 = false;
	__EZRE_CURSOR_OFFSET = [0, 0];
	__EZRE_CURSOR_RADIUS = 12;
	__EZRE_GRID_SIZE	 = [1, 1];
	
	ezRoomEditor_set_ignored_variables([
		"__EZRE_IS_EDITABLE",
		"__EZRE_EDIT_CONST_ID",
		"__EZRE_EDIT_ACTIVE",
		"__EZRE_EDIT_IGNORED",
		"__EZRE_CURSOR_GRAB",
		"__EZRE_CURSOR_OFFSET",
		"__EZRE_CURSOR_RADIUS",
		"__EZRE_GRID_SIZE",
		"__EZRE_EDIT_VARIABLES",
	]);
}

/// @func	ezRoomEditor_get_edit_active(id)
/// @param	{ref}	id
function ezRoomEditor_get_edit_active(_id = id) {
	return variable_instance_get(_id, "__EZRE_EDIT_ACTIVE") ?? false;
}

/// @func	ezRoomEditor_get_edit_active(id)
/// @param	{ref}	id
function ezRoomEditor_get_is_grab(_id = id) {
	return variable_instance_get(_id, "__EZRE_CURSOR_GRAB") ?? false;
}

/// @func	ezRoomEditor_get_camera_width()
function ezRoomEditor_get_camera_width() {
	return camera_get_view_width(__EZRE_CONTROLLER.__EZRE_CAMERA);
}

/// @func	ezRoomEditor_get_camera_height()
function ezRoomEditor_get_camera_height() {
	return camera_get_view_height(__EZRE_CONTROLLER.__EZRE_CAMERA);
}

/// @func	ezRoomEditor_set_editable_grid(grid_w, grid_h)
/// @param	{real}	grid_w
/// @param	{real}	grid_h
function ezRoomEditor_set_editable_grid(_grid_w, _grid_h) {
	__EZRE_GRID_SIZE = [_grid_w, _grid_h];
}

/// @func	ezRoomEditor_set_editable_variables(var_array, is_property, _type)
/// @param	{array}	var_array
/// @param	{bool}	is_property
/// @param	{real}	type
function ezRoomEditor_set_editable_variables(_arr, _is_prop = false, _type = ezre_type_any) {
	__EZRE_EDIT_VARIABLES = [];
	
	for (var i = 0; i < get_size(_arr); i++) {
		if (ezRoomEditor_core_get_forbidden_variable(_arr[i])) continue;
		
		__EZRE_EDIT_VARIABLES[i] = {
			name: _arr[i],
			value: variable_instance_get(id, _arr[i]),
			type: _type,
			isProperty: _is_prop,
		};
	}
}

/// @func	ezRoomEditor_add_editable_variables(str_or_array, is_property, type)
/// @param	{str|array}	str_or_array
/// @param	{bool}	is_property
/// @param	{real}	type
function ezRoomEditor_add_editable_variables(_vars, _is_prop = false, _type = ezre_type_any) {
	if (is_string(_vars)) {
		_vars = [_vars];
	}
	var _len = get_size(_vars);
	
	for (var i = 0; i < _len; i++) {
		if (ezRoomEditor_core_get_forbidden_variable(_vars[i])) continue;
		
		array_push(__EZRE_EDIT_VARIABLES, {
			name: _vars[i],
			value: variable_instance_get(id, _vars[i]),
			type: _type,
			isProperty: _is_prop,
		});
	}
}

/// @func	ezRoomEditor_set_ignored_variables(var_name_array)
/// @param	{array}	var_name_array
function ezRoomEditor_set_ignored_variables(_arr) {
	__EZRE_EDIT_IGNORED = [];
	
	for (var i = 0; i < get_size(_arr); i++) {
		__EZRE_EDIT_IGNORED[i] = _arr[i];
	}
}

/// @func	ezRoomEditor_add_ignored_variables(var_name_str_or_array)
/// @param	{str|array}	var_name_str_or_array
function ezRoomEditor_add_ignored_variables(_vars) {
	if (is_string(_vars)) {
		_vars = [_vars];
	}
	var _len = get_size(_vars);
	
	for (var i = 0; i < _len; i++) {
		array_push(__EZRE_EDIT_IGNORED, _vars[i]);
	}
}


/// @func	ezRoomEditor_set_edit_mode(flag)
/// @param	{bool}	flag
function ezRoomEditor_set_edit_mode(_flag) {
	with (__EZRE_CONTROLLER) {
		event_user(!_flag);
		__EZRE_EDIT_ENABLED = _flag;
	}
}

/// @func	ezRoomEditor_get_edit_mode()
function ezRoomEditor_get_edit_mode() {
	return __EZRE_CONTROLLER.__EZRE_EDIT_ENABLED;
}

/// @func	ezRoomEditor_editable_event_step()
function ezRoomEditor_editable_event_step() {
	if !(__EZRE_CONTROLLER.__EZRE_EDIT_ENABLED) return;
	
	var _collision_eval = (
		(bbox_right - bbox_left <= 0 && bbox_bottom - bbox_top <= 0) && __EZRE_CURSOR_RADIUS > 0
		? point_in_circle(mouse_x, mouse_y, x, y, __EZRE_CURSOR_RADIUS)
		: point_in_rectangle(mouse_x, mouse_y, bbox_left, bbox_top, bbox_right, bbox_bottom)
	);
	
	if (_collision_eval) {
		if (!__EZRE_CURSOR_GRAB) {
			
			var _mouse_on_modal = (
				__EZRE_CONTROLLER.__EZRE_MODAL_STATE == __EZRE_MODAL_STATES.OPEN && 
				between(gui_mouse_x(), __EZRE_CONTROLLER.__EZRE_MODAL_X, __EZRE_CONTROLLER.__EZRE_MODAL_X + __EZRE_CONTROLLER.__EZRE_MODAL_WIDTH) &&
				between(gui_mouse_y(), __EZRE_CONTROLLER.__EZRE_MODAL_Y, __EZRE_CONTROLLER.__EZRE_MODAL_Y + __EZRE_CONTROLLER.__EZRE_MODAL_HEIGHT)
			);
			if (mouse_check_button_pressed(mb_left)) {
				if (_mouse_on_modal) return;
				
				__EZRE_CURSOR_OFFSET = [
					mouse_x - x,
					mouse_y - y,
				];
				__EZRE_CURSOR_GRAB = true;
				
				if (__EZRE_CONTROLLER.__EZRE_MODAL_INST_TO_TRACK != noone) {
					__EZRE_CONTROLLER.__EZRE_MODAL_INST_TO_TRACK = id;
				}
			}
			
			if (mouse_check_button_pressed(mb_right)) {
				if (_mouse_on_modal) return;
				var _vw_x = camera_get_view_x(__EZRE_CONTROLLER.__EZRE_CAMERA);
				var _vw_w = ezRoomEditor_get_camera_width();
				var _gui_w = gui_width();
				var _modal_w = __EZRE_CONTROLLER.__EZRE_MODAL_WIDTH;
				var _modal_x = ( ((x - _vw_x) < (_vw_w / 2)) ? _gui_w : 0 );
				var _modal_xstart_offset = ( ((x - _vw_x) < (_vw_w / 2)) ? _modal_w : -_modal_w );

				if (__EZRE_CONTROLLER.__EZRE_MODAL_INST_TO_TRACK == id) {
					if (__EZRE_CONTROLLER.__EZRE_MODAL_STATE != __EZRE_MODAL_STATES.OPEN) {
						__EZRE_CONTROLLER.__EZRE_MODAL_X = _modal_x + _modal_xstart_offset;
						__EZRE_CONTROLLER.__EZRE_MODAL_Y = 0;
						__EZRE_CONTROLLER.__EZRE_MODAL_INST_TO_TRACK = id;
						__EZRE_CONTROLLER.__EZRE_MODAL_STATE = __EZRE_MODAL_STATES.APPEAR;
					} else {
						__EZRE_CONTROLLER.__EZRE_MODAL_STATE = __EZRE_MODAL_STATES.DISAPPEAR;
					}
				} else {
					__EZRE_CONTROLLER.__EZRE_MODAL_X = _modal_x + _modal_xstart_offset;
					__EZRE_CONTROLLER.__EZRE_MODAL_INST_TO_TRACK = id;
				}
			}
		}
	}
	
	if (__EZRE_CURSOR_GRAB) {
		if (mouse_check_button(mb_left)) {
			x = clamp(mouse_x - __EZRE_CURSOR_OFFSET[0], 0, room_width);
			y = clamp(mouse_y - __EZRE_CURSOR_OFFSET[1], 0, room_height);
			move_snap(__EZRE_GRID_SIZE[0], __EZRE_GRID_SIZE[1]);
		}
		
		if (mouse_check_button_released(mb_left)) {
			ezRoomEditor_editable_set_variable_value(__EZRE_EDIT_CONST_ID, "x", x);
			ezRoomEditor_editable_set_variable_value(__EZRE_EDIT_CONST_ID, "y", y);
		
			__EZRE_CURSOR_GRAB = false;
		}
	}
}

///	@func	ezRoomEditor_editable_set_variable_value(inst_const_name, variable, value, type)
/// @param	{str}	inst_const_name
/// @param	{str}	variable
/// @param	{any}	value
/// @param	{real}	type
function ezRoomEditor_editable_set_variable_value(_inst_name, _var_name, _value, _type = ezre_type_any) {
	var _inst = __EZRE_CONTROLLER.__EZRE_EDIT_INSTANCES_AVAILABLE[$ _inst_name];
	var _variables = _inst[$ "inst_in_room_id"].__EZRE_EDIT_VARIABLES;
	var _var_index = -1;
	
	for (var i = 0; i < get_size(_variables); i++) {
		if (_var_name == _variables[@ i][$ "name"]) {
			_var_index = i;
			break;
		}
	}
	
	if (_var_index != -1) {
		_inst[$ "inst_in_room_id"].__EZRE_EDIT_VARIABLES[_var_index][$ "value"] = _value;
		variable_instance_set(_inst[$ "inst_in_room_id"], _var_name, _value);
		_var_name = ezRoomEditor_core_get_builtin_equivalent(_var_name);
	
						
		// Image blend save
		if (_var_name == "colour") {
			_value = dec_rgb2rgba(_inst[$ "inst_in_room_id"].image_blend, _inst[$ "inst_in_room_id"].image_alpha);
		} else {
			// Fix rgb -> rgba decimals on .yy files
			if (_type == ezre_type_color || _type == ezre_type_color_rgba) {
				_value = dec_rgb2rgba(_value, _type == ezre_type_color ? 1.0 : (_value >> 24) / 255);
			}
		
			// Fix strings "replace \n" with "\\n"
			if (_type == ezre_type_string_long || _type == ezre_type_string) {
				if (string_contains(_value, "\n")) {
					_value = string_replace_all(_value, "\n", "\\n");
				}
			}
			
			// Fix assets to save names instead of int values
			if (_type == ezre_type_asset_sprite) {
				_value = __EZRE_CONTROLLER.__EZRE_ASSETS[$ "sprites"][_value];
			}
			
			if (_type == ezre_type_asset_object) {
				_value = __EZRE_CONTROLLER.__EZRE_ASSETS[$ "objects"][_value];
			}
			
			if (_type == ezre_type_asset_script) {
				_value = __EZRE_CONTROLLER.__EZRE_ASSETS[$ "scripts"][_value - 100001];
			}
		}
		
		if (_inst[$ "inst_in_room_id"].__EZRE_EDIT_VARIABLES[_var_index].isProperty) {
			// Save color values as HEX #RRGGBBAA on room file
			if (_type == ezre_type_color || _type == ezre_type_color_rgba) {
				var _hex_value = rgba_dec2hex(_value, (_type == ezre_type_color_rgba ? (_value >> 24) / 255 : 1.0));
				_value = _hex_value;
			}
			
			var _prop_index = -1;
			for (var i = 0; i < get_size(_inst[$ "data"][$ "properties"]); i++) {
				if (_var_name == _inst[$ "data"][$ "properties"][@ i][$ "propertyId"][$ "name"]) {
					_prop_index = i;
					break;
				}
			}
			
			// If prop was found
			if (_prop_index != -1) { 
				_inst[$ "data"][$ "properties"][_prop_index][$ "value"] = string(_value);
				return;
			}
			
			// If no prop found
			array_push(_inst[$ "data"][$ "properties"], ezRoomEditor_core_property_get_override_struct(_inst[$ "inst_in_room_id"], _var_name, _value));
		} else {
			// Check if prop is part of room file variables
			var _valid_var = struct_key_exists(_inst[$ "data"], _var_name);
			if (_valid_var) {
				_inst[$ "data"][$ _var_name] = _value;
			}
		}
		return;
	}
	
	trace( $"⚠ WARNING: Variable \"{_var_name}\" cannot be found as an editable variable or property on instance \"{_inst_name}\".\n",
			"Make sure it was defined using the \"ezRoomEditor_set_editable_variables()\" or \"ezRoomEditor_add_editable_variables()\" functions.")
}
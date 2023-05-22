/// @func	ezUI_core_validate_value_same_type(prop_type, _value)
/// @param	{real}	prop_type
/// @param	{any}	_value
function ezUI_core_validate_value_same_type(_prop_type, _value) {	
	switch (_prop_type) {
		case ezui_type_any:			return true;	break;
		case ezui_type_bool:		return is_bool(_value);		break;
		case ezui_type_string:		return is_string(_value);	break;
		case ezui_type_real:		return is_numeric(_value) || is_infinity(_value);	break;
		case ezui_type_int:			return is_int32(_value) || is_int64(_value) || round(_value) == _value;	break;
		case ezui_type_array:		return is_array(_value);	break;
		case ezui_type_struct:		return is_struct(_value);	break;
		case ezui_type_callable:	return is_callable(_value) || (is_array(_value) && get_size(_value) > 1);	break;
	}
	
	ezUI_warning("No type defined when setting property value.")
	return false;
}

/// @func	ezUI_core_merge_props_structs(props_struct, new_values_struct)
/// @param	{struct}	props_struct
/// @param	{struct}	new_values_struct
function ezUI_core_merge_props_structs(_props, _values) {
	var _keys = struct_keys(_values);
	var _new_props = {};
	
	for (var i = 0; i < get_size(_keys); i++) {
		_new_props[$ _keys[i]] = variable_clone(_props[$ _keys[i]]);
		_new_props[$ _keys[i]][$ "value"] = _values[$ _keys[i]];
	}
	
	return struct_merge(_props, _new_props, true);
}

/// @func	ezUI_core_get_type_name(type)
/// @param	{real}	type
function ezUI_core_get_type_name(_type) {
	switch (_type) {
		case ezui_type_any:			return "Any";		break;
		case ezui_type_bool:		return "Boolean";	break;
		case ezui_type_string:		return "String";	break;
		case ezui_type_real:		return "Real";		break;
		case ezui_type_int:			return "Integer";	break;
		case ezui_type_array:		return "Array";		break;
		case ezui_type_struct:		return "Struct";	break;
		case ezui_type_callable:	return "Callable";	break;
	}
}

/// @func	ezUI_core_get_instance_on_top(x, y)
/// @param	{real}	x
/// @param	{real}	y
function ezUI_core_get_instance_on_top(_x, _y) {
	var _inst = noone;
	
	with (parent_ezUI) {
		if (object_index != o_ezUI_Button
			&& object_index != o_ezUI_Modal
			&& object_index != o_ezUI_Input
		) continue;
		
		var _style = props;		
		if (object_index == o_ezUI_Button) {
			_style = ezUI_button_get_style();
		}
		var _inst_x = x + _style[$ "x"][$ "value"];
		var _inst_y = y + _style[$ "y"][$ "value"] + ( object_index == o_ezUI_Modal ? -ezUI_get_prop_value("titleBarHeight") * ezUI_get_prop_value("titleBarEnabled") : 0 );
		
		var _mouse_in = point_in_rectangle(
			_x, _y,
			_inst_x, _inst_y,
			_inst_x + _style[$ "width"][$ "value"], _inst_y + _style[$ "height"][$ "value"]
		);
		
		if (_mouse_in) {
			if (_inst == noone) {
				_inst = id;
				continue;
			}

			_inst = ( depth <= _inst.depth ? id : _inst );
			break;
		}
	}
	
	return _inst;
}

/// @func	ezUI_core_validate_charset_char(char, charset)
/// @param	{str}	char
/// @param	{real}	charset
function ezUI_core_validate_charset_char(_char, _charset = ezui_charset_all) {
	var _charset_index = 0;
	static _charset_str = [
		" abcdefghijklmnñopqrstuvwxyzABCDEFGHIJKLMNÑOPQRSTUVWXYZ.:,;-_¡!¿?0123456789áéíóúÁÉÍÓÚàèìòùÀÈÌÒÙäëïöüÄËÏÖÜ\\\"'#$%&/()=@[]{}+~^<>|°*",
		"0123456789.",
		" abcdefghijklmnñopqrstuvwxyzABCDEFGHIJKLMNÑOPQRSTUVWXYZ.:,;-_¡!¿?áéíóúÁÉÍÓÚàèìòùÀÈÌÒÙäëïöüÄËÏÖÜ\\\"'#$%&/()=@[]{}+~^<>|°*",
		" abcdefghijklmnñopqrstuvwxyzABCDEFGHIJKLMNÑOPQRSTUVWXYZáéíóúÁÉÍÓÚàèìòùÀÈÌÒÙäëïöüÄËÏÖÜ",
	];
	
	switch (_charset) {
		case ezui_charset_all:				_charset_index = 0;	break;
		case ezui_charset_numbers:			_charset_index = 1;	break;			
		case ezui_charset_text:				_charset_index = 2;	break;
		case ezui_charset_text_no_special:	_charset_index = 3;	break;
	}
	
	return string_contains(_charset_str[_charset_index], str(_char));
}

/// @func	ezUI_core_execute_callable(callback)
/// @param	{callable}	callback
function ezUI_core_execute_callable(_callback) {
	if (is_array(_callback)) {
		script_execute_ext(_callback[0], _callback, 1);
		return;
	}
	_callback();
	return;
}

/// @func	ezUI_core_get_instance_variable_names(instance)
/// @param	{ref}	instance
function ezUI_core_get_instance_variable_names(_inst) {
	static _builtin_vars = [
		"id",
		"bbox_left",
		"bbox_right",
		"bbox_bottom",
		"bbox_top",
		"x",
		"y",
		"depth",
		"direction",
		"friction",
		"gravity",
		"gravity_direction",
		"hspeed",
		"vspeed",
		"image_alpha",
		"image_angle",
		"image_blend",
		"image_index",
		"image_number",
		"image_speed",
		"image_xscale",
		"image_yscale",
		"layer",
		"mask_index",
		"solid",
		"speed",
		"sprite_height",
		"sprite_width",
		"sprite_index",
		"visible",
		"xprevious",
		"yprevious",
		"xstart",
		"ystart",
	];
	
	return _builtin_vars;
}

/// @func	ezUI_warning(message)
/// @param	{str}	message
function ezUI_warning(_msg) {
	trace($"(ez-UI) ⚠ WARNING: {_msg}");
}

/// @func	ezUI_error(message)
/// @param	{str}	message
function ezUI_error(_msg) {
	trace($"(ez-UI) ❌ ERROR: {_msg}");
}
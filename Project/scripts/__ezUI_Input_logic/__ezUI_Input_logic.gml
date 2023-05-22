
/// @func	ezUI_create_input(props)
/// @param	{struct}	props
function ezUI_create_input(_props) {
	var _inst = instance_create_depth(0, 0, 0, o_ezUI_Input);
	var _final_props = ezUI_core_merge_props_structs(_inst.props, _props);
	_inst.props		= _final_props;
	_inst.prevProps = variable_clone(_final_props);
	_inst.depth		= ezUI_get_prop_value("depth", 0, _inst);
	
	return _inst;
}

/// @func	ezUI_input_sync_variable()
function ezUI_input_sync_variable() {
	var _inst_to_sync = ezUI_get_prop_value("inputSyncInstance");
	var _var_to_sync  = ezUI_get_prop_value("inputSyncVariable");
	if (_inst_to_sync == noone || _var_to_sync == "") return;
	ezUI_set_prop_value("inputText", string(variable_instance_get(_inst_to_sync, _var_to_sync)));
}

/// @func	ezUI_input_ev_step()
function ezUI_input_ev_step() {
	t_backspace--;
	t_pointer++;
	
	if (t_pointer > room_speed) {
		t_pointer = 0;
	}
	
	if (state != __EZUI_INPUT_STATE.FOCUS) {
		ezUI_input_sync_variable();
	}
	
	var _mouse_x = gui_mouse_x();
	var _mouse_y = gui_mouse_y();
	var _mouse_in = point_in_rectangle(
		_mouse_x, _mouse_y,
		x + props[$ "x"][$ "value"], y + props[$ "y"][$ "value"],
		x + props[$ "x"][$ "value"] + props[$ "width"][$ "value"], y + props[$ "y"][$ "value"] + props[$ "height"][$ "value"]
	);
	
	if (_mouse_in) {
		var _inst_on_top = ezUI_core_get_instance_on_top(_mouse_x, _mouse_y);
		if (_inst_on_top == id) {
			if (mouse_check_button_pressed(mb_left)) {
				state = __EZUI_INPUT_STATE.FOCUS;
				keyboard_string = ezUI_get_prop_value("inputText");
				var _onFocus = ezUI_get_prop_value("onFocus");
				if (_onFocus) {
					_onFocus();
				}
				return;
			};		
			state = ( state != __EZUI_INPUT_STATE.FOCUS ? __EZUI_INPUT_STATE.HOVER : state );
		} else {
			state = __EZUI_BUTTON_STATE.DEFAULT;
		}
	} else {
		if (mouse_check_button_pressed(mb_left) || state != __EZUI_INPUT_STATE.FOCUS) {
			state = __EZUI_BUTTON_STATE.DEFAULT;
		}
	}
	
	// On key press
	if (state == __EZUI_INPUT_STATE.FOCUS) {
		var _last_key	 = keyboard_lastkey;
		var _last_char	 = keyboard_lastchar;
		var _actual_text = ezUI_get_prop_value("inputText");
		
		if (keyboard_check(vk_backspace) && t_backspace <= 0) {
			_actual_text = string_delete(_actual_text, string_length(_actual_text), 1);
			keyboard_string = _actual_text;
			ezUI_set_prop_value("inputText", _actual_text);
			t_backspace = room_speed * .16;
			t_backspace_hold++;
			if (t_backspace_hold > 0) {
				t_backspace = t_backspace - (t_backspace_hold * .16);
			}
			var _onChange = ezUI_get_prop_value("onChange");
			if (_onChange) {
				ezUI_core_execute_callable(_onChange);
			}
			return;
		}
		
		if (keyboard_check_released(vk_backspace)) {
			t_backspace_hold = 0;
		}
		
		if (keyboard_check(vk_anykey)) {
			draw_set_font(ezUI_get_prop_value("inputTextFont"));
			var _text_len_is_valid = string_length(_actual_text) < ezUI_get_prop_value("inputTextMaxChars");
			var _text_w_less_than_input_width = string_width(_actual_text) < (ezUI_get_prop_value("width") - 8);
			
			if (_text_len_is_valid && _text_w_less_than_input_width) {
				switch (_last_key) {
					case vk_enter:
						state = __EZUI_INPUT_STATE.DEFAULT;
						var _onEnter = ezUI_get_prop_value("onEnter");
						if (_onEnter != noone) {
							ezUI_core_execute_callable(_onEnter);
						}
						return;
						break;
				}
		
				if (ezUI_core_validate_charset_char(_last_char, ezUI_get_prop_value("inputTextCharset"))) {
					ezUI_set_prop_value("inputText", keyboard_string);
					keyboard_string = ezUI_get_prop_value("inputText");
					var _onChange = ezUI_get_prop_value("onChange");
					if (_onChange) {
						ezUI_core_execute_callable(_onChange);
					}
				} else {
					keyboard_string = _actual_text;
				}
			}
		}
	}
}

/// @func	ezUI_input_ev_draw()
function ezUI_input_ev_draw() {
	var _x = x + ezUI_get_prop_value("x");
	var _y = y + ezUI_get_prop_value("y");
	var _w = ezUI_get_prop_value("width");
	var _h = ezUI_get_prop_value("height");
	
	draw_set_alpha(1);
	draw_set_font(ezUI_get_prop_value("inputTextFont"));
	
	// Draw Input background
	if (ezUI_get_prop_value("inputUseBackground")) {
		draw_set_color(state == __EZUI_INPUT_STATE.HOVER ? ezui_color_background_secondary : ezui_color_background_primary);
		draw_rectangle(_x, _y, _x + _w, _y + _h, false);
	}
	
	// Draw Input border
	if (ezUI_get_prop_value("inputUseBorders")) {
		draw_set_color(state != __EZUI_INPUT_STATE.FOCUS ? ezui_color_text_secondary : ezui_color_highlight_primary);
		draw_rectangle(_x, _y, _x + _w, _y + _h, true);
	}
	
	// Draw label
	var _label = ezUI_get_prop_value("inputLabel");
	if (_label != "") {
		draw_set_align(fa_left, fa_bottom);
		draw_set_color(ezui_color_text_secondary);
		draw_text_size(_x - 2, _y + 2, _label + ":", 10);
	}
	
	draw_set_align(fa_left, fa_center);
	// Draw placeholder text
	var _text = ezUI_get_prop_value("inputText");
	var _placeholderText = ezUI_get_prop_value("inputTextPlaceholder");
	if (_text == "" && _placeholderText != "" && state != __EZUI_INPUT_STATE.FOCUS) {
		draw_set_color(ezui_color_text_secondary);
		draw_text_size(_x + 2, _y + _h / 2 + 2, ezUI_get_prop_value("inputTextPlaceholder"), 10);
	}
	
	// Draw text
	var _text_w = string_width(_text);
	var _pointer = (
		state == __EZUI_INPUT_STATE.FOCUS
		&& _text_w < (_w - 8)
		&& t_pointer < room_speed * .66
		&& string_length(_text) < ezUI_get_prop_value("inputTextMaxChars")
		? "_"
		: ""
	);
	draw_set_color(ezui_color_text_primary);
	draw_text_size(_x + 2, _y + _h / 2 + 2, _text + _pointer, 10);
	
}

/// @func	ezUI_input_get_typed_value(instance)
/// @param	{ref}	instance
function ezUI_input_get_typed_value(_inst) {
	var _input_type = ezUI_get_prop_value("inputSyncType",, _inst);
	var _input_value = ezUI_get_prop_value("inputText",, _inst);
	
	try {
		switch (_input_type) {
			default:
			case ezui_type_any:
			case ezui_type_string:		return _input_value;
			case ezui_type_bool:		return bool(_input_value);
			case ezui_type_real:		return real(_input_value);
			case ezui_type_int:			return int64(floor(real(_input_value)));
			case ezui_type_instance:	return instance_find(_input_value, 0);
		}
	} catch(e) {
		ezUI_error($"Cannot get input typed value, be sure it's the correct type.\nMore details: {e.message}");
		return _input_value;
	}
}

/// @func	ezUI_create_button(props, propsOnHover, propsOnFocus)
/// @param	{struct}	props
/// @param	{struct}	propsOnHover
/// @param	{struct}	propsOnFocus
function ezUI_create_button(_props, _propsOnHover = {}, _propsOnFocus = {}) {
	var _inst = instance_create_depth(0, 0, 0, o_ezUI_Button);
	var _final_props = ezUI_core_merge_props_structs(_inst.props, _props);
	var _default_hover_props = ezUI_core_merge_props_structs(variable_clone(_final_props), {
		color: ezui_color_highlight_primary,
		textColor: ezui_color_text_primary,
	});
	var _default_focus_props = ezUI_core_merge_props_structs(variable_clone(_final_props), {
		color: ezui_color_highlight_secondary,
		textColor: ezui_color_text_primary,
	});
	
	_final_props.styleOnHover = ezUI_core_merge_props_structs(_default_hover_props, _propsOnHover);
	_final_props.styleOnFocus = ezUI_core_merge_props_structs(_default_focus_props, _propsOnFocus);
	
	_inst.props		= _final_props;
	_inst.prevProps = variable_clone(_final_props);
	_inst.onClick	= ezUI_get_prop_value("onClick", -1, _inst);
	_inst.depth		= ezUI_get_prop_value("depth", 0, _inst);
	
	var _button_text = ezUI_create_text({
		x:		ezUI_get_prop_value("x",, _inst) + ezUI_get_prop_value("width",, _inst) / 2,
		y:		ezUI_get_prop_value("y",, _inst) + ezUI_get_prop_value("height",, _inst) / 2,
		depth:	ezUI_get_prop_value("depth", 0, _inst) - 1,
		text:	ezUI_get_prop_value("text",, _inst),
		color:	ezUI_get_prop_value("textColor",, _inst),
		size:	ezUI_get_prop_value("textSize",, _inst),
		font:	ezUI_get_prop_value("textFont",, _inst),
	});
	
	ezUI_add_children(_inst, _button_text);
	
	return _inst;
}

/// @func	ezUI_button_ev_onClick()
/// @desc	This the default onClick event. Should be called only inside the ezUI_Button object.
function ezUI_button_ev_onClick() {
	alert_async("Button clicked");
}

/// @func	ezUI_button_ev_step()
function ezUI_button_ev_step() {
	var _style	 = ezUI_button_get_style();
	var _mouse_x = gui_mouse_x();
	var _mouse_y = gui_mouse_y();
	var _mouse_in = point_in_rectangle(
		_mouse_x, _mouse_y,
		x + _style[$ "x"][$ "value"], y + _style[$ "y"][$ "value"],
		x + _style[$ "x"][$ "value"] + _style[$ "width"][$ "value"], y + _style[$ "y"][$ "value"] + _style[$ "height"][$ "value"]
	);
	
	if (_mouse_in) {
		var _inst_on_top = ezUI_core_get_instance_on_top(_mouse_x, _mouse_y);
		
		if (_inst_on_top == id) {
			if (mouse_check_button_pressed(mb_left)) {
				state = __EZUI_BUTTON_STATE.FOCUS;
				return;
			} else if (mouse_check_button_released(mb_left) && onClick != noone && state == __EZUI_BUTTON_STATE.FOCUS) {
				ezUI_core_execute_callable(onClick);
			}		
			state = ( state != __EZUI_BUTTON_STATE.FOCUS ? __EZUI_BUTTON_STATE.HOVER : state );
		} else {
			state = __EZUI_BUTTON_STATE.DEFAULT;
		}
	} else {
		state = __EZUI_BUTTON_STATE.DEFAULT;
	}
	
	if (get_size(children) > 0) {
		// Move text children
		ezUI_set_prop_value("text", _style[$ "text"][$ "value"], children[0]);
		ezUI_set_prop_value("color", _style[$ "textColor"][$ "value"], children[0]);
		ezUI_set_prop_value("font", _style[$ "textFont"][$ "value"], children[0]);
		ezUI_set_prop_value("size", _style[$ "textSize"][$ "value"], children[0]);
	
		// Built-in x & y are used as offset from modal
		children[0].x = x;
		children[0].y = y;
	}
}

/// @func	ezUI_button_get_style()
function ezUI_button_get_style() {
	var _style;
	
	switch (state) {
		default:
		case __EZUI_BUTTON_STATE.DEFAULT:	_style	=	props;	break;
		case __EZUI_BUTTON_STATE.HOVER:		_style	=	props.styleOnHover;	break;
		case __EZUI_BUTTON_STATE.FOCUS:		_style	=	props.styleOnFocus;	break;
	}
	
	return _style;
}

/// @func	ezUI_button_ev_draw()
function ezUI_button_ev_draw() {
	var _style = ezUI_button_get_style();
	
	// Draw button
	if (_style[$ "sprite"][$ "value"] == noone) {
		draw_set_alpha(_style[$ "alpha"][$ "value"]);
		draw_set_color(_style[$ "color"][$ "value"]);
		draw_rectangle(
			x + _style[$ "x"][$ "value"],
			y + _style[$ "y"][$ "value"],
			x + _style[$ "x"][$ "value"] + _style[$ "width"][$ "value"],
			y + _style[$ "y"][$ "value"] + _style[$ "height"][$ "value"],
			false
		);
	} else {
		draw_sprite_stretched_ext(
			_style[$ "sprite"][$ "value"],
			0,
			x + _style[$ "x"][$ "value"],
			y + _style[$ "y"][$ "value"],
			_style[$ "width"][$ "value"],
			_style[$ "height"][$ "value"],
			_style[$ "color"][$ "value"],
			_style[$ "alpha"][$ "value"]
		);
	}
}
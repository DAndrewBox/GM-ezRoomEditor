
/// @func	ezUI_create_text(props)
/// @param	{struct}	props
function ezUI_create_text(_props) {
	var _inst = instance_create_depth(0, 0, 0, o_ezUI_Text);
	var _final_props = ezUI_core_merge_props_structs(_inst.props, _props);
	_inst.props		= _final_props;
	_inst.prevProps = variable_clone(_inst.props);
	_inst.onChange	= ezUI_text_ev_onChange;
	_inst.depth		= ezUI_get_prop_value("depth", 0, _inst);
	
	return _inst;
}

/// @func	ezUI_text_ev_onChange()
/// @desc	This the default onChange event. SHould be called only inside the ezUI_Text object.
function ezUI_text_ev_onChange() {
	prevProps = variable_clone(props);
}

/// @func	ezUI_text_ev_draw()
function ezUI_text_ev_draw() {
	if (!struct_equal(prevProps, props)) {
		onChange();
	}
	
	draw_set_font(ezUI_get_prop_value("font"));
	draw_set_color(ezUI_get_prop_value("color"));
	draw_set_align(ezUI_get_prop_value("hAlign"), ezUI_get_prop_value("vAlign"));
	draw_set_alpha(ezUI_get_prop_value("alpha"));
	
	draw_text_size(
		x + ezUI_get_prop_value("x"),
		y + ezUI_get_prop_value("y"),
		ezUI_get_prop_value("text"),
		ezUI_get_prop_value("size")
	);
	draw_set_alpha(1);
}
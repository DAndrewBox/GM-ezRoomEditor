/// @func	ezUI_add_prop(prop_name, default_value, prop_type)
/// @param	{str}	prop_name
/// @param	{any}	default_value
/// @param	{real}	prop_type
function ezUI_add_prop(_name, _value, _type = ezui_type_any) {
	struct_set(props, _name, {value: _value, type: _type});
}

/// @func	ezUI_set_prop_value(prop_name, new_value, instance)
/// @param	{str}	prop_name
/// @param	{any}	new_value
/// @param	{ref}	instance
function ezUI_set_prop_value(_name, _value, _id = noone) {
	var _props_struct = _id == noone ? props : _id.props;
	
	var _prop_org_type = _props_struct[$ _name][$ "type"];
	if (ezUI_core_validate_value_same_type(_prop_org_type, _value)) {
		_props_struct[$ _name][$ "value"] = _value;
		return true;
	}
	
	ezUI_error($"Cannot assign value with type \"{typeof(_value)}\" instead of \"{ezUI_core_get_type_name(_prop_org_type)}\" on property \"{_name}\"");
	return false;
}

/// @func	ezUI_get_prop_value(prop_name, default, instance_id)
/// @param	{str}	prop_name
/// @param	{any}	default
/// @param	{ref}	instance_id
function ezUI_get_prop_value(_name, _default_value = undefined, _id = noone) {
	var _props_struct = ( (_id == noone || _id == undefined) ? props : _id.props );
	var _value = _props_struct[$ _name][$ "value"];
	if (is_undefined(_value)) return _default_value;
	return _value;
}

/// @func	ezUI_add_children(parent_id, child_id)
/// @param	{ref}	parent_id
/// @param	{ref}	child_id
function ezUI_add_children(_p_id, _c_id) {
	with (_p_id) {
		array_push(children, _c_id);
	}
}

/// @func	ezUI_get_children_by_uuid(instance, uuid)
/// @param	{ref}	instance
/// @param	{str}	uuid
function ezUI_get_children_by_uuid(_inst, _uuid) {
	var _children = _inst.children;
	for (var i = 0; i < get_size(_children); i++) {	
		var _child = _children[i];
		if (ezUI_get_uuid(_child) == _uuid) return _child;
	}
	return noone;
}

/// @func	ezUI_get_uuid(instance)
/// @param	{ref}	instance
function ezUI_get_uuid(_inst_id) {
	return _inst_id.__UUID;
}
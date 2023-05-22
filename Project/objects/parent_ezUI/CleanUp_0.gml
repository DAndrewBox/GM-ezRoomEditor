/// @description Free up memory
delete props;
delete prevProps;

for (var i = 0; i < get_size(children); i++) {
	del(children[i]);
}
array_clear(children);
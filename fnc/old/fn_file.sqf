params["_mode"];
switch _mode do {
	case "write":{
		_params params ["_file", "_content"];
		["biki_utils_py.write_to_file", _params]
	};
};
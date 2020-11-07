params ["_fileName", "_content"];
_file = getMissionPath format ["dumps\rootCTClasses\%1", _fileName];
["Writing to file: %1", _file] call BIS_fnc_logFormat;
["biki_utils_py.write_to_file", [_file, _content]] call py3_fnc_callExtension;
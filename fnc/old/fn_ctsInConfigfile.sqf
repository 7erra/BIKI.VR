#define BREAKPOINT if true exitWith {};
params ["_ct"];
//--- Collect controls from the main config that have the correct control type
_filter = format ["getNumber(_x >> 'type') == %1 && isNumber(_x >> 'style')", _ct];
_classes = _filter configClasses configFile;
//--- Only collect unique styles because controls of the same style will not
//--- differ significantly
_styles = [];
_classes = _classes select {
	_style = getNumber(_x >> "style");
	if (_style in _styles) then {
		false
	} else {
		_styles pushBack _style;
		true
	};
};

_fncAddParents = {
	params ["_cfg", "_arr"];
	_parent = inheritsFrom _cfg;
	if !(isNull _parent) then {
		[_parent, _arr] call _fncAddParents;
	};
	_arr pushBackUnique _cfg;
};
_classesWithParents = [];
{
	[_x, _classesWithParents] call _fncAddParents;
} forEach _classes;
//--- Convert classes to strings
_classesWithParents = _classesWithParents apply {
	[_x] call BIKI_fnc_configToString;
};

_return = _classesWithParents joinString toString[10];
[format["CT_%1_examples.hpp", _ct], _return] call BIKI_fnc_writeFile;
_return

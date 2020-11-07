#include "\a3\ui_f\hpp\defineResincl.inc"
/*
	Author: Terra

	Description:
	Generates the Cfg ref code for the given control type. It is recommended to 
	either execVM or spawn the function. Calling it unsuspended will freeze the 
	game for a while and not show a loading screen.

	Parameter(s):
		0	STRING/NUMBER - Macro or number of the control type
	
	Returns:
	Nothing. Output is copied to cliboard.

	Examples:
	[0] execVM "fnc\generateTempalteCT.sqf";
	// is equal to
	["CT_STATIC"] execVM "fnc\generateTemplateCT.sqf";
*/
params ["_ct"];
startLoadingScreen [""];
if (_ct isEqualType "") then {
	_ct = [_ct] call BIKI_fnc_convertCTMacro;
};
_controls = [_ct, nil, false] call compile preprocessFileLineNumbers "fnc\fn_collectCtrls.sqf";
_props = [];
_exclude = loadFile "dumps\cts\excludeatts.txt" splitString endl apply {toLower _x};
_controls apply {
	configProperties [_x] apply {
		_xprop = configName _x;
		if !(toLower _xprop in _exclude) then {
			_props pushBack _x;
		};
	};
};

//--- Sort the config array by config name
_props = _props apply {[configName _x, _x]};
_props sort true;
_props = _props apply {_x#1};

//--- Collect all attributes from the config
_dbAttributes = [];
{
	private ["_value", "_type"];
	_xname = configName _x;
	switch true do {
		case isNumber(_x):{
			_value = getNumber(_x);
			_type = "Number";
		};
		case isText(_x):{
			_value = getText(_x);
			_type = "String";
		};
		case isArray(_x):{
			_value = getArray(_x);
			_type = "Array";
		};
		case isClass(_x):{
			_value = [_x, true] call BIKI_fnc_configToString;
			_type = "Class";
		};
	};

	if !([_dbAttributes, [_xname]] call BIS_fnc_dbClassCheck) then {
		//--- Class does not exist
		[["name",_xname], ["values",[_value]], ["types",[_type]]] apply {
			_x params ["_key", "_value"];
			[_dbAttributes, [_xname, _key], _value] call BIS_fnc_dbValueSet;
		};
	} else {
		_types = [_dbAttributes, [_xname, "types"], []] call BIS_fnc_dbValueReturn;
		if (_types pushBackUnique _type > -1) then {
			_values = [_dbAttributes, [_xname, "values"], []] call BIS_fnc_dbValueReturn;
			_values pushBack _value;
		};
	};
	progressLoadingScreen (_forEachIndex/count(_props));
} forEach _props;
endLoadingScreen;

//--- Convert the database to the BIKI list
_lastLetter = "";
_bikiText = ([_dbAttributes, []] call BIS_fnc_dbClassList) apply {
	private _name = [_dbAttributes, [_x, "name"]] call BIS_fnc_dbValueReturn;
	private _values = [_dbAttributes, [_x, "values"]] call BIS_fnc_dbValueReturn;
	private _types = [_dbAttributes, [_x, "types"]] call BIS_fnc_dbValueReturn;
	diag_log [_name, _values, _types];

	_firstLetter = _name select [0,1];
	_letterHeader = "";
	if (_firstLetter != _lastLetter) then {
		_letterHeader = format["=== %1 ===%2", toUpperANSI _firstLetter, endl];
		_lastLetter = _firstLetter;
	};

	_examples = [];
	{
		_fei = _forEachIndex;
		_type = format["|type%1=%2", _fei +1, _x];
		_value = _values select _fei;
		_value = switch _x do {
			case "Array": {
				_value = str _value;
				"{" + (_value select [1, count _value -2]) + "}";
			};
			case "String": {
				str _value
			};
			default {_value};
		};
		_value = format["|value%1=%2", _fei +1, _value];

		_examples pushBack ([_type,_value] joinString endl);
	} forEach _types;

	_value = _values select 0;

	[format["%1{{CT|attribute", _letterHeader],
	format["|name=%1", _name],
	_examples joinString endl,
	"|description=",
	"}}",
	""] joinString endl

} joinString endl;
copyToClipboard _bikiText;
_bikiText
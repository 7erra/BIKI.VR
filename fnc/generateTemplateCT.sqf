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
params ["_ctMacro"];
startLoadingScreen [""];
_dictCTs = [
	//Macro, Value
	["CT_STATIC", CT_STATIC],
	["CT_BUTTON", CT_BUTTON],
	["CT_EDIT", CT_EDIT],
	["CT_SLIDER", CT_SLIDER],
	["CT_COMBO", CT_COMBO],
	["CT_LISTBOX", CT_LISTBOX],
	["CT_TOOLBOX", CT_TOOLBOX],
	["CT_CHECKBOXES", CT_CHECKBOXES],
	["CT_PROGRESS", CT_PROGRESS],
	["CT_HTML", CT_HTML],
	["CT_STATIC_SKEW", CT_STATIC_SKEW],
	["CT_ACTIVETEXT", CT_ACTIVETEXT],
	["CT_TREE", CT_TREE],
	["CT_STRUCTURED_TEXT", CT_STRUCTURED_TEXT],
	["CT_CONTEXT_MENU", CT_CONTEXT_MENU],
	["CT_CONTROLS_GROUP", CT_CONTROLS_GROUP],
	["CT_SHORTCUTBUTTON", CT_SHORTCUTBUTTON],
	["CT_HITZONES", CT_HITZONES],
	["CT_CONTROLS_TABLE", CT_CONTROLS_TABLE],
	["CT_XKEYDESC", CT_XKEYDESC],
	["CT_XBUTTON", CT_XBUTTON],
	["CT_XLISTBOX", CT_XLISTBOX],
	["CT_XSLIDER", CT_XSLIDER],
	["CT_XCOMBO", CT_XCOMBO],
	["CT_ANIMATED_TEXTURE", CT_ANIMATED_TEXTURE],
	["CT_OBJECT", CT_OBJECT],
	["CT_OBJECT_ZOOM", CT_OBJECT_ZOOM],
	["CT_OBJECT_CONTAINER", CT_OBJECT_CONTAINER],
	["CT_OBJECT_CONT_ANIM", CT_OBJECT_CONT_ANIM],
	["CT_LINEBREAK", CT_LINEBREAK],
	["CT_USER", CT_USER],
	["CT_MAP", CT_MAP],
	["CT_MAP_MAIN", CT_MAP_MAIN],
	["CT_LISTNBOX", CT_LISTNBOX],
	["CT_ITEMSLOT", CT_ITEMSLOT],
	["CT_CHECKBOX", CT_CHECKBOX],
	["CT_VEHICLE_DIRECTION", CT_VEHICLE_DIRECTION]
];
if (_ct isEqualType "") then {
	_ct = _dictCTs select (_dictCTs findIf {_x#0 == _ctMacro}) params ["", "_ct"];
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

	_toSet = [["value", _value],/*/*/["type", _type]];
	if !([_dbAttributes, [_xname]] call BIS_fnc_dbClassCheck) then {
		//--- Class does not exist
		[_dbAttributes, [_xname, "name"], _xname] call BIS_fnc_dbValueSet;
		_toSet apply {
			_x params ["_key", "_value"];
			[_dbAttributes, [_xname, _key], [_value]] call BIS_fnc_dbValueSet;
		};
	} else {
		_toSet apply {
			_x params ["_key", "_value"];
			private _valueOrType = [_dbAttributes, [_xname, _key], []] call BIS_fnc_dbValueReturn;
			diag_log ["_valueOrType", _valueOrType];
			_valueOrType pushBackUnique _value;
			[_dbAttributes, [_xname, _key], _valueOrType] call BIS_fnc_dbValueSet;
		};
	};
	progressLoadingScreen (_forEachIndex/count(_props));
} forEach _props;
endLoadingScreen;
//--- Convert the database to the BIKI list
_lastLetter = "";
_bikiText = ([_dbAttributes, []] call BIS_fnc_dbClassList) apply {
	private _name = [_dbAttributes, [_x, "name"]] call BIS_fnc_dbValueReturn;
	private _values = [_dbAttributes, [_x, "value"]] call BIS_fnc_dbValueReturn;
	private _types = [_dbAttributes, [_x, "type"]] call BIS_fnc_dbValueReturn;
	diag_log [_name, _values, _types];

	_firstLetter = _name select [0,1];
	_letterHeader = "";
	if (_firstLetter != _lastLetter) then {
		_letterHeader = format["=== %1 ===%2", toUpperANSI _firstLetter, endl];
		_lastLetter = _firstLetter;
	};

	_typesText = [];
	{
		_typesText pushBack format["|type%1=%2", _forEachIndex +1, _x];
	} forEach _types;

	_value = _values select 0;
	_value = switch (_types select 0) do {
		case "Array": {
			_value = str _value;
			"{" + (_value select [1, count _value -2]) + "}";
		};
		case "String": {
			str _value
		};
		default {_value};
	};

	[format["%1{{CT|attribute", _letterHeader],
	format["|name=%1", _name],
	format["|value=%1", _value],
	_typesText joinString endl,
	"|description=",
	"}}",
	""] joinString endl

} joinString endl;
copyToClipboard _bikiText;
_bikiText
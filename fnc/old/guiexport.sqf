/*
	File: guiexport.sqf
	Author: Terra

	Description:
	Export all possible attributes for a control type to the clipboard as a BIKI table.

	Parameter(s):
	0: NUMBER - Control type (default: 0)

	Returns:
	STRING copied to clipboard
*/
params [["_filterCT", 0], ["_isdebug", false]];
if (!_isdebug) then {startLoadingScreen ["Fetching attributes..."];};
_mainCfg = [configFile, missionConfigFile] select _isdebug;
guiexport_guis = "isNumber(_x >> 'idd')" configClasses _mainCfg;
_filterCTStr = format ["getNumber(_x >> 'type') == %1", _filterCT];
_excludeList = [
	"access", "show", "x", "y", "w", "h", "tooltip", "tooltipColorBox", "tooltipColorShade",
	"tooltipColorText", "tooltipMaxWidth", "type", "style", "default", "deleteable", 
	"deletable", "enable", "fade", "idc", "moving", "Scrollbar", "sizeEx", "text",
	"colorBackground", "colorText", "colorDisabled", "blinkingPeriod", "font"
];
_excludeList = _excludeList apply {toLower _x};

#define EXAMPLE_MAX_CHARS 100
_fnGetExample = {
	params ["_cfgAtt"];
	private _att = configName _cfgAtt;
	private _eg = if (isClass _cfgAtt) then {
		format ["class %1;", _att];
	} else {
		_value = [_cfgAtt] call BIS_fnc_getCfgData;
		_useArray = ["", "[]"] select isArray _cfgAtt;
		_useString = ["", """"] select isText _cfgAtt;
		format ["%1%2 = %3%4%3;", _att, _useArray, _useString, _value]
	};
	if (count _eg > EXAMPLE_MAX_CHARS) exitWith {
		nil // Dont use examples that are too long for the table
	};
	_eg
};

_fnAddAtt = {
	params ["_cfgAtt"];
	_att = configName _cfgAtt;
	_type = _cfgAtt call {
		if (isClass _this) exitWith {"Class"};
		if (isNumber _this) exitWith {"Number"};
		if (isText _this) exitWith {"String"};
		"Array"
	};
	if (
		toLower _att in _excludeList OR
		_att select [0,2] == "on"
	) exitWith {};
	{
		if (isNil "_x") exitWith {
			private _eg = [_cfgAtt] call _fnGetExample;
			if (isNil "_eg") then {
				guiexport_ctAtts pushBack [_att, [[_type]]];
			} else {
				guiexport_ctAtts pushBack [_att, [[_type], _eg]];
			};
		};
		_x params ["_name", "_data"];
		_data params ["_types", "_example"];
		if (toLower _name == toLower _att) exitWith {
			_types pushBackUnique _type;
			if (isNil "_example") then {
				// get new example
				private _eg = [_cfgAtt] call _fnGetExample;
				if (!isNil "_eg") then {_data set [1, _eg];};
			};
		};
	} forEach (guiexport_ctAtts + [nil]);
};

_fnCTAtts = {
	params ["_ctrlCfgs"];
	_ctrlCfgs apply {
		configProperties [_x, "true"] apply {
			if (configName _x == "controls" && isClass _x) then {
				// recursive
				[_filterCTStr configClasses _x] call _fnCTAtts;
			} else {
				// Normal attribute, add to list
				[_x] call _fnAddAtt;
			};
		};
	};
};

guiexport_ctAtts = [];
{
	_searchStart = 
		(_filterCTStr configClasses (_x >> "controls")) + 
		(_filterCTStr configClasses (_x >> "controlsBackground"));
	[_searchStart] call _fnCTAtts;
	
	if(!_isdebug) then {progressLoadingScreen (_forEachIndex/(count guiexport_guis));};
} forEach guiexport_guis;
// Format to table
_table = ["{|class=""wikitable"" border=""1"" align=""left"" cellpadding=""3"" cellspacing=""0"" |"];
_table pushBack "! colspan=""3"" bgcolor=""#bbbbff"" | Properties";
_table pushBack "|-";
{
	_table pushBack _x;
} forEach ["! bgcolor=""#ddddff"" | Name", "! bgcolor=""#ddddff"" | Type", "! bgcolor=""#ddddff"" | Remark"];
_na = "{{n/a|?}}";
guiexport_ctAtts sort true;
guiexport_ctAtts apply {
	_x params ["_name", "_values"];
	_values params ["_types", "_eg"];
	_table pushBack "|-";
	_table pushBack (format["| '''%1'''", _name]);
	_types = _types apply {
		if (_x != "Class") then {
			"[[" + toUpper(_x select [0,1]) + toLower(_x select [1]) + "]]"
		} else {
			_x
		};
	};
	_types = _types joinString "/";
	_table pushBack (format["| %1", _types]);
	_table pushBack (format["| %1", _na]);
	_table pushBack "|-";
	_egLine = "| colspan=""3""";
	if (isNil "_eg") then {
		_table pushBack format ["%1 %2", _egLine, _na];
	} else {
		_table pushBack (format["%1 | <syntaxhighlight lang=""cpp"">%2</syntaxhighlight>", _egLine, _eg]);
	};
};
_table pushBack "|}<br clear=""all"">";
_table = _table joinString endl;
copyToClipboard _table;
guiexport_ctAtts = nil;
if(!_isdebug) then {endLoadingScreen;};
_table
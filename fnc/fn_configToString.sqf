#define SELF BIKI_fnc_configToString
#define TABCHAR "	"
params["_cfg", ["_inh", false], ["_tabCount", 0], ["_lineBreak", toString[10]]];
private _props = configProperties[_cfg, "true", _inh];
private _fncNewLine = {
	params["_outarr", "_line", "_tcount"];
	private _strTab = "";
	for "_t" from 1 to _tcount do {
		_strTab = _strTab + TABCHAR;
	};
	_outarr pushBack (_strTab + _line);
};
private _outarr = [];
private _parent = "";
if (!_inh && inheritsFrom _cfg != confignull) then {
	_parent = format [": %1", configname inheritsFrom _cfg];
};
[_outarr, format["class %1%2", configName _cfg, _parent], 0] call _fncNewLine;
[_outarr, "{", _tabCount] call _fncNewLine;
_tabCount = _tabCount +1;
_props apply {
	private _xprop = _x;
	private _xname = configName _xprop;
	_linestr = "";
	switch true do {
		case isClass _xprop:{
			_linestr = [_xprop, _inh, _tabCount, _lineBreak] call SELF;
		};
		case isNumber _xprop:{
			_linestr = format["%1 = %2;", _xname, getNumber _xprop];
		};
		case isText _xprop:{
			_linestr = format["%1 = ""%2"";", _xname, getText _xprop];
		};
		case isArray _xprop:{
			private _xval = str getArray _xprop;
			_linestr = format["%1[] = {%2};", _xname, _xval select [1,count _xval -2]];
		};
		default {_linestr = ""};
	};
	[_outarr, _linestr, _tabCount] call _fncNewLine;
};
_tabCount = _tabCount -1;
[_outarr, "};", _tabCount] call _fncNewLine;
_return = _outarr joinString _lineBreak;
_return
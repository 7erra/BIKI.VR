#define SELF (compile preprocessFileLineNumbers "fnc\verbClassToArray.sqf")
params [
	["_cfg", configNull, [configFile]],
	["_inh", true, [true]],
	["_rec", false, [false]]
];

_props = configProperties[_cfg, "true", _inh];
_arr = _props apply {
	private _xcfg = _x;
	private _xname = configName _xcfg;
	//--- _xdata format:
	//--- [value, typename, example]
	private _xdata = switch true do {
		case isNumber _xcfg:{
			[getNumber _xcfg, typeName 1, format["%1 = %2;", _xname, getNumber _xcfg]];
		};
		case isText _xcfg:{
			[getText _xcfg, typeName "", format["%1 = ""%2"";", _xname, getText _xcfg]];
		};
		case isArray _xcfg:{
			private _xval = str getArray _xcfg;
			_xval = _xval select [1, count(_xval) -2];
			[getArray _xcfg, typeName [], format["%1[] = {%2};", _xname, _xval]];
		};
		case isClass _xcfg:{
			[[_xcfg, _inh, true] call SELF, "CLASS", format ["class %1;", _xname]]
		};
	};
	[_xname, _xdata]
};
//--- Arr return format:
//--- ["attribute", [value, typename, example]]
if (_rec) then {
	_arr
} else {
	[format["%1", configName _cfg], [_arr, "CLASS", format["class %1;", configName _cfg]]]
};

/*
[
	"TestCfg",
	[
		["x", [0, "NUMBER", "x = 0;"]],
		[
			"A",
			[
				["sub", ["test", "STRING", "sub = ""test"";"]
				"CLASS", "class A;"
			]

		],
		"CLASS", "class TestCfg;"
	]
]

*/
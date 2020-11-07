#define SELF (compile preprocessFileLineNumbers "ui\s\RscDisplayExportGUITypes.sqf")
params ["_mode", "_params"];
switch _mode do {
	case "onLoad":{
		_params params ["_display"];
		_btns = (allControls _display) select {(ctrlClassName _x) select [0,3] == "CT_"};
		_btns apply {
			_ctrl = _x;
			_ctrl ctrlAddEventHandler ["ButtonClick", {
				["ctClick", _this] spawn SELF;
			}];
		};
	};
	case "ctClick":{
		_params params ["_btn"];
		_display = ctrlParent _btn;
		_ct = ctrlIDC _btn -100;
		_r = [_ct] call compile preprocessFileLineNumbers "BIKI\guiexport.sqf";
		_ctrlOutput = _display displayCtrl 900;
		_ctrlOutput ctrlSetText _r;
		_ctrlOutput ctrlSetPositionH (ctrlTextHeight _ctrlOutput);
		_ctrlOutput ctrlCommit 0;
	};
};
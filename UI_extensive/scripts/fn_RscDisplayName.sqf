/*
    Author: Terra
    
    Description:
    	__DESCRIPTION___
    
    Parameter(s):
    	0:	__TYPE__ - __EXPLANATION__
    	Optional:
    	N:	__TYPE___ - __EXPLANATION__
    		Default: __DEFAULT___
    
    Returns:
    	__TYPE__ - __EXPLANATION___
    
    Example(s):
    	__PARAMETER__ __EXECUTIONMETHOD__ __FUNCTION___; //-> __RETURN__
*/
#define SELF TAG_fnc_RscDisplayName
#include "defines.inc"
#include "\a3\ui_f\hpp\defineCommonGrids.inc"
params ["_mode", "_params"];
switch _mode do {
	case "onLoad":{
		_params params ["_display"];
		_ctrlMoveLeft = _display displayCtrl IDC_TAG_RSCDISPLAYNAME_MOVELEFT;
		_ctrlMoveRight = _display displayCtrl IDC_TAG_RSCDISPLAYNAME_MOVERIGHT;
		_ctrlMoveLeft ctrlAddEventHandler ["ButtonClick", {
			["move", [_this select 0, -1]] call SELF;
		}];
		_ctrlMoveRight ctrlAddEventHandler ["ButtonClick", {
			["move", [_this select 0, +1]] call SELF;
		}];
	};
	case "move":{
		_params params ["_ctrlMove", "_step"];
		_display = ctrlParent _ctrlMove;
		_ctrlTestImage = _display displayCtrl IDC_TAG_RSCDISPLAYNAME_TESTIMAGE;
		ctrlPosition _ctrlTestImage params ["_xPos"];
		_ctrlTestImage ctrlSetPositionX (_xPos + _step * GUI_GRID_W);
		_ctrlTestImage ctrlCommit 0; 
	};
};

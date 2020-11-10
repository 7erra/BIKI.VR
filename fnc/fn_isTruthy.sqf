/*
    Author: Terra
    
    Description:
    	Checks if the given value is "truthy". This means that for example empty
		strings or arrays are false.
		
		Suported datatypes and condition to be truthy:
			- BOOL: true or false. pls dont code like that.
			- ARRAY: Contains at least one element.
			- STRING: Has to have at least one charachter.
			- CONFIG: Expects config class. Class has to have at least one property.
			- CODE: Code is not empty.
			- CONTROL, DISPLAY, SCRIPT: Value is not null.
			- OBJECT: Not null and alive.
			- GROUP: Not null and has at least one member.
			- LOCATION: Not null, not at world origin ([0,0,0]) and has to have area.
			- NAMESPACE: At least one variable in it.
			- SIDE: At least one unit on it.
			- TASK: Task is not null and not completed.
		Unsupported:
			- TEXT
			- TEAM_MEMBER
			- DIARY_RECORD
    
    Parameter(s):
    	0:	ANYTHING - Value to check
    	Optional:
    	1:	BOOLEAN - Value returned when function can't handle given datatype.
    		Default: false
    
    Returns:
    	BOOLEAN - True when value is truthy.
    
    Example(s):
    	0 call BIKI_fnc_isTruthy; //-> false
    	1 call BIKI_fnc_isTruthy; //-> true
    	[[]] call BIKI_fnc_isTruthy; //-> false
    	[[0,1,2]] call BIKI_fnc_isTruthy; //-> true
*/
params ["_value", ["_fallBack", false, [false]]];
if (_value isEqualType true) exitWith {_value}; // y tho
if (_value isEqualTypeAny [[], ""]) exitWith {count _value > 0};
if (_value isEqualType 0) exitWith {_value > 0};
if (_value isEqualType configNull) exitWith {count configProperties[_value] > 0};
if (_value isEqualType {}) exitWith {!(_value isEqualTo {})};
if (_value isEqualTypeAny [controlNull, displayNull, scriptNull]) exitWith {!isNull _value};
if (_value isEqualType objNull) exitWith {!isNull _value and alive _value};
if (_value isEqualType grpNull) exitWith {!isNull _value or {count units _value > 0}};
if (_value isEqualType locationNull) exitWith {!isNull _value and !(locationPosition _value select [0,2] isEqualTo [0,0]) and !(0 in size _value)};
if (_value isEqualType missionNamespace) exitWith {count allVariables _value > 0};
if (_value isEqualType sideUnknown) exitWith {_value countSide allUnits > 0};
if (_value isEqualType taskNull) exitWith {!isNull _value and taskState _value in ["Created", "Assigned", "Current"]};
false


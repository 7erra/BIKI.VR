_version = str(productVersion select 2);
_version = format["%1.%2", _version select [0,1], _version select [1,count _version]];
_firstLine = format ["Fonts for {{GVI|arma3|%1}}:<br>", _version];
_s = [_firstLine, "<ol start{{=}}""0"">"];
_cfgFonts = configproperties [configfile >> "cfgfontfamilies","isclass _x"];
_cfgFonts apply {
	_s pushBack format["<li>%1</li>", configName _x];
};
_s pushBack "</ol>";
_s = _s joinString endl;
copyToClipboard _s;
_s
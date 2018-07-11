exports.calledName = "";
exports.names=["xpath"];

exports.parms=[
	{"name":"xpath","value":null,"defaultValue":null},
	{"name":"separator","value":null,"defaultValue":"\n"}
];

exports.helpText = "xpath - returns the values from an xpath expression\r\n"+
	"Syntax: pasty xpath <xpath>\r\n";
exports.oneLiner = "returns the values from an xpath expression";

exports.edit=function(input, switches){
	var DOMParser = require("./node_modules/xmldom").DOMParser;
	var query = require('./node_modules/xpath');

	var doc = (new DOMParser()).parseFromString(input,"text/xml");
	var xpath = exports.parms[0].value;
	var sep = exports.parms[1].value;

	var output = query.select(xpath, doc);

	if(switches.indexOf('L') === -1){
		for(var i=0;i<output.length;i++){
			if(output[i].value){
				output[i] = output[i].value;
			} else {
				output[i] = output[i].firstChild.data;
			}
		}
	}

	return output.join(sep);
};


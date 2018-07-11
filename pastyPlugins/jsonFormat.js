exports.calledName = "";
exports.names=["jsonformat"];

exports.parms=[];

exports.helpText = "jsonformat - formats json as a pretty string\r\n"+
	"(Must be valid JSON)\r\n"+
	"Syntax: pasty jsonformat\r\n";
exports.oneLiner = "formats json as a pretty string";

exports.edit=function(input, switches){
	var obj = JSON.parse(input);
	return JSON.stringify(obj, null, '\t');
};


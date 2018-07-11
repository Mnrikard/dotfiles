exports.calledName = "";
exports.names=["reverse"];

exports.parms=[];

exports.helpText = "reverse - reverses a string\r\n"+
	"Syntax: pasty reverse\r\n"+
	"Example: echo abcd | pasty reverse\r\n"+
	">> dcba";
exports.oneLiner = "reverses a string";

exports.edit=function(input, switches){
	var output = [];
	for(var i=input.length-1;i>=0;i--){
		output.push(input[i]);
	}
	return output.join("");
};

